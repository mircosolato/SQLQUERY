declare @SSQL nvarchar(max),
@waiting_sql nvarchar(max),
@errMessage as nvarchar(max);

WHILE (1=1)
BEGIN

SELECT --p.spid,
--s.host_name,
--s.program_name,
--s.original_login_name,
@SSQL = q.text, -- as sql,
--wp.spid as waiting_sess,
--ws.host_name as waiting_host_name,
--ws.program_name as waiting_program_name,
--wr.wait_time as waiting_time,
@waiting_sql = wq.text --as waiting_sql,
FROM sys.sysprocesses p
join sys.dm_exec_sessions s on s.session_id=p.spid
join sys.dm_exec_connections c on c.session_id=p.spid
CROSS APPLY sys.dm_exec_sql_text(c.most_recent_sql_handle) AS q
join sys.sysprocesses wp on wp.blocked=p.spid
join sys.dm_exec_sessions ws on ws.session_id=wp.spid
join sys.dm_exec_requests wr on wr.session_id=wp.spid
CROSS APPLY sys.dm_exec_sql_text(wr.sql_handle) AS wq
--WHERE p.spid in (select distinct blocked FROM sys.sysprocesses where blocked>0)
--and p.blocked<=0
--and wr.wait_time>0 --5min
-- uncomment the next line to really kill process
-- if @ProcessId is not null EXEC('KILL ' + @ProcessId);
if (@@ROWCOUNT > 1)
begin
SELECT @errMessage = 'Error: ' + CHAR(13) + ' @SSQL:' + SUBSTRING(@SSQL,0,50) + CHAR(13) + CHAR(13) + ' @waiting_sql:' + SUBSTRING(@waiting_sql,0,100) + CHAR(13) + CHAR(13);
RAISERROR (@errMessage , 10, 1) WITH NOWAIT
end

WAITFOR DELAY '00:00:03';

END