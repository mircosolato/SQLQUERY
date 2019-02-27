
SET DEADLOCK_PRIORITY LOW;
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;


SELECT TOP 50 * FROM(SELECT COALESCE(OBJECT_NAME(s2.objectid),'Ad-Hoc') AS ProcName,
  execution_count,s2.objectid,
    (SELECT TOP 1 SUBSTRING(s2.TEXT,statement_start_offset / 2+1 ,
      ( (CASE WHEN statement_end_offset = -1
  THEN (LEN(CONVERT(NVARCHAR(MAX),s2.TEXT)) * 2)
ELSE statement_end_offset END)- statement_start_offset) / 2+1)) AS sql_statement,
       last_execution_time
FROM sys.dm_exec_query_stats AS s1
CROSS APPLY sys.dm_exec_sql_text(sql_handle) AS s2 ) x
WHERE sql_statement NOT like 'SELECT TOP 50 * FROM(SELECT %'
--and OBJECTPROPERTYEX(x.objectid,'IsProcedure') = 1
ORDER BY last_execution_time DESC

SELECT distinct 
        s.session_id,
        s.login_name,
        c.client_net_address,
        w.wait_duration_ms,
        w.wait_duration_ms/1000/60 as [min],
        w.wait_type,
        w.resource_address,
        w.blocking_session_id,
        w.resource_description,
        CAST (st.text as nvarchar(max)) AS [SQL Text],
        s.is_user_process
FROM sys.dm_exec_sessions S
LEFT JOIN sys.dm_exec_connections AS c ON S.session_id = c.session_id
LEFT JOIN sys.dm_exec_query_stats qs on c.most_recent_sql_handle = qs.sql_handle
INNER JOIN sys.dm_os_waiting_tasks AS w ON w.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(qs.sql_handle) AS st
ORDER BY s.is_user_process DESC, w.wait_duration_ms DESC