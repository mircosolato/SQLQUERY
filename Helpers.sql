/* TOP SLOW REQUESTS */
/* time is in microseconds */
SELECT  creation_time 
        ,last_execution_time
        ,total_physical_reads
        ,total_logical_reads 
        ,total_logical_writes
        , execution_count
        , total_worker_time
        , total_elapsed_time
        , (total_elapsed_time / execution_count) avg_elapsed_time
        ,SUBSTRING(st.text, (qs.statement_start_offset/2) + 1,
         ((CASE statement_end_offset
          WHEN -1 THEN DATALENGTH(st.text)
          ELSE qs.statement_end_offset END
            - qs.statement_start_offset)/2) + 1) AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
WHERE execution_count > 10 -- filter out rare requests
ORDER BY total_elapsed_time / execution_count DESC;


/* NUMBER OF OPEN CONNECTIONS */
SELECT DB_NAME(dbid) as "Database", COUNT(dbid) as "Number Of Open Connections",
loginame as LoginName
FROM sys.sysprocesses
WHERE dbid > 0
GROUP BY dbid, loginame

/* STORED PROCEDURES AND FUNCTIONS EXECUTION TIME, COUNT AND AVERAGE */
/* time is in microseconds */
SELECT DB_NAME(st.dbid) DBName
      ,OBJECT_SCHEMA_NAME(st.objectid,dbid) SchemaName
      ,OBJECT_NAME(st.objectid,dbid) StoredProcedure
      ,max(cp.usecounts) Execution_count
      ,sum(qs.total_worker_time) total_cpu_time
      ,sum(qs.total_worker_time) / (max(cp.usecounts) * 1.0)  avg_cpu_time
 
FROM sys.dm_exec_cached_plans cp join sys.dm_exec_query_stats qs on cp.plan_handle = qs.plan_handle
     CROSS APPLY sys.dm_exec_sql_text(cp.plan_handle) st
where DB_NAME(st.dbid) is not null and cp.objtype = 'proc'
group by DB_NAME(st.dbid),OBJECT_SCHEMA_NAME(objectid,st.dbid), OBJECT_NAME(objectid,st.dbid) 
order by sum(qs.total_worker_time) desc

/* FIND OUT WHO IS BLOCKING */
/* Use BlkBy column		 */
exec sp_who2

 /* SEE WHICH CONNECTION IS DOING WHAT */
SELECT s.session_id, s.host_name, s.host_process_id,s.total_elapsed_time, (select text from sys.dm_exec_sql_text(r.sql_handle)) as command
FROM sys.dm_exec_sessions AS s
left join sys.dm_exec_requests AS r
on r.session_id = s.session_id
where s.status ='running'
order by command

/* FIND UNUSED INDEXES - MIGHT AFFECT LOG WRITES */

SELECT o.name Object_Name,
i.name Index_name, 
i.Type_Desc
FROM sys.objects AS o
JOIN sys.indexes AS i
ON o.object_id = i.object_id 
LEFT OUTER JOIN 
sys.dm_db_index_usage_stats AS s 
ON i.object_id = s.object_id 
AND i.index_id = s.index_id
WHERE o.type = 'u'
-- Clustered and Non-Clustered indexes
AND i.type IN (1, 2) 
-- Indexes without stats
AND (s.index_id IS NULL) OR
-- Indexes that have been updated but not used
(s.user_seeks = 0 AND s.user_scans = 0 AND s.user_lookups = 0 );


/* DMV to find useful indexes: */

PRINT 'Missing Indexes: '
PRINT 'The "improvement_measure" column is an indicator of the (estimated) improvement that might '
PRINT 'be seen if the index was created. This is a unitless number, and has meaning only relative '
PRINT 'the same number for other indexes. The measure is a combination of the avg_total_user_cost, '
PRINT 'avg_user_impact, user_seeks, and user_scans columns in sys.dm_db_missing_index_group_stats.'
PRINT ''
PRINT '-- Missing Indexes --'
SELECT CONVERT (varchar, getdate(), 126) AS runtime, 
  mig.index_group_handle, mid.index_handle, 
  CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) AS improvement_measure, 
  'CREATE INDEX missing_index_' + CONVERT (varchar, mig.index_group_handle) + '_' + CONVERT (varchar, mid.index_handle) 
  + ' ON ' + mid.statement 
  + ' (' + ISNULL (mid.equality_columns,'') 
    + CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE '' END + ISNULL (mid.inequality_columns, '')
  + ')' 
  + ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS create_index_statement, 
  migs.*, mid.database_id, mid.[object_id]
FROM sys.dm_db_missing_index_groups mig
INNER JOIN sys.dm_db_missing_index_group_stats migs ON migs.group_handle = mig.index_group_handle
INNER JOIN sys.dm_db_missing_index_details mid ON mig.index_handle = mid.index_handle
WHERE CONVERT (decimal (28,1), migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans)) > 10
ORDER BY migs.avg_total_user_cost * migs.avg_user_impact * (migs.user_seeks + migs.user_scans) DESC
PRINT ''
GO

/* Find top 10 queries */

SELECT TOP 10 query_stats.query_hash AS "Query Hash", 
    SUM(query_stats.total_worker_time) / SUM(query_stats.execution_count) AS "Avg CPU Time",
    MIN(query_stats.statement_text) AS "Statement Text"
FROM 
    (SELECT QS.*, 
    SUBSTRING(ST.text, (QS.statement_start_offset/2) + 1,
    ((CASE statement_end_offset 
        WHEN -1 THEN DATALENGTH(st.text)
        ELSE QS.statement_end_offset END 
            - QS.statement_start_offset)/2) + 1) AS statement_text
     FROM sys.dm_exec_query_stats AS QS
     CROSS APPLY sys.dm_exec_sql_text(QS.sql_handle) as ST) as query_stats
GROUP BY query_stats.query_hash
ORDER BY 2 DESC;
GO

/* Monitor query plans */

SELECT
    highest_cpu_queries.plan_handle,  
    highest_cpu_queries.total_worker_time, 
    q.dbid, 
    q.objectid, 
    q.number, 
    q.encrypted, 
    q.[text] 
FROM 
    (SELECT TOP 50  
        qs.plan_handle,  
        qs.total_worker_time 
     FROM 
        sys.dm_exec_query_stats qs 
     ORDER BY qs.total_worker_time desc) AS highest_cpu_queries 
     CROSS APPLY sys.dm_exec_sql_text(plan_handle) AS q 
ORDER BY highest_cpu_queries.total_worker_time desc

/* CHECK SIZE OF DB OBJECTS */
SELECT TOP(10)
      o.[object_id]
    , obj = SCHEMA_NAME(o.[schema_id]) + '.' + o.name
    , o.[type]
    , i.total_rows
    , i.total_size
FROM sys.objects o
JOIN (
    SELECT
          i.[object_id]
        , total_size = CAST(SUM(a.total_pages) * 8. / 1024 AS DECIMAL(18,2))
        , total_rows = SUM(CASE WHEN i.index_id IN (0, 1) AND a.[type] = 1 THEN p.[rows] END)
    FROM sys.indexes i
    JOIN sys.partitions p ON i.[object_id] = p.[object_id] AND i.index_id = p.index_id
    JOIN sys.allocation_units a ON p.[partition_id] = a.container_id
    WHERE i.is_disabled = 0
        AND i.is_hypothetical = 0
    GROUP BY i.[object_id]
) i ON o.[object_id] = i.[object_id]
WHERE o.[type] IN ('V', 'U', 'S')
ORDER BY i.total_size DESC

-- to understand who is doing what, alternative view/representation
SELECT
	CAST((SELECT qt.text FROM sys.dm_exec_sql_text(qs.sql_handle) AS qt FOR XML PATH('')) as xml) as query_text,
	qs.blocking_session_id,
	qs.start_time, 
	datediff(ss, qs.start_time, getdate()) as ExecutionTime_Seconds,
	getdate() as  CurrentDate,
	datediff(MINUTE, qs.start_time, getdate()) as ExecutionTime_Minutes,
	qs.session_id,
	qs.command,
	qs.status,
	qs.cpu_time, 
	qs.reads, 
	qs.writes, 
	qs.plan_handle,
	qp.query_plan,
	s.host_name, s.login_name, s.program_name,
	qs.wait_type, qs.open_transaction_count, qs.open_resultset_count, qs.row_count, qs.granted_query_memory, qs.transaction_isolation_level
	--,qs.*
FROM sys.dm_exec_requests AS qs
left join sys.dm_exec_sessions s on s.session_id = qs.session_id ---OUTER APPLY sys.dm_exec_sql_text(qs.sql_handle) AS qt
OUTER APPLY sys.dm_exec_query_plan(qs.plan_handle) AS qp
WHERE 	qs.session_id <> @@SPID
	and qs.command not in ('RESOURCE MONITOR', 'XE TIMER', 'XE DISPATCHER', 'LOG WRITER', 'LOCK MONITOR', 'TASK MANAGER', 'TASK MANAGER', 'CHECKPOINT', 'BRKR TASK', 'LAZY WRITER', 'SIGNAL HANDLER', 'TRACE QUEUE TASK', 'BRKR EVENT HNDLR', 'GHOST CLEANUP', 'RECOVERY WRITER', 'SYSTEM_HEALTH_MONITOR', 'RECEIVE', 'UNKNOWN TOKEN', 'FT FULL PASS', 'FT CRAWL MON')
	and isnull(s.program_name, '') <> 'SQL diagnostic manager Collection Service'
ORDER BY ExecutionTime_Minutes DESC

-- all fragmented indexes on current db, % fragmentation > 30
SELECT a.index_id, OBJECT_NAME(a.object_id), name, avg_fragmentation_in_percent  
FROM sys.dm_db_index_physical_stats (DB_ID(DB_NAME()), 
      NULL, NULL, NULL, NULL) AS a  
     JOIN sys.indexes AS b 
     ON a.object_id = b.object_id AND a.index_id = b.index_id
where avg_fragmentation_in_percent > 30
order by avg_fragmentation_in_percent desc
GO 

-- rebuild all indexes online
ALTER INDEX ALL ON Table1
REBUILD WITH (ONLINE = ON);   
GO  
-- rebuild single index online
ALTER INDEX IX_IndexName ON Table1
REBUILD WITH (ONLINE = ON);   
GO  
