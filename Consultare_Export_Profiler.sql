DROP TABLE #EventClass;

CREATE TABLE #EventClass (EventClass INT NOT NULL, EventName VARCHAR(255) NOT NULL);

INSERT INTO #EventClass (EventClass, EventName) VALUES
(10, 'RPC:Completed'),
(11, 'RPC:Starting'),
(12, 'SQL:BatchCompleted'),
(13, 'SQL:BatchStarting'),
(14, 'Audit Login'),
(15, 'Audit Logout'),
(16, 'Attention'),
(17, 'ExistingConnection'),
(18, 'Audit Server Starts And Stops'),
(19, 'DTCTransaction'),
(20, 'Audit Login Failed'),
(21, 'EventLog'),
(22, 'ErrorLog'),
(23, 'Lock:Released'),
(24, 'Lock:Acquired'),
(25, 'LockBigGrineadlock'),
(26, 'Lock:Cancel'),
(27, 'Lock:Timeout'),
(28, 'Degree of Parallelism (7.0 Insert)'),
(33, 'Exception'),
(34, 'SP:CacheMiss'),
(35, 'SP:CacheInsert'),
(36, 'SP:CacheRemove'),
(37, 'SP:Recompile'),
(38, 'SP:CacheHit'),
(39, 'Deprecated'),
(40, 'SQL:StmtStarting'),
(41, 'SQL:StmtCompleted'),
(42, 'SP:Starting'),
(43, 'SP:Completed'),
(44, 'SP:StmtStarting'),
(45, 'SP:StmtCompleted'),
(46, 'Object:Created'),
(47, 'ObjectBigGrineleted'),
(50, 'SQLTransaction'),
(51, 'Scan:Started'),
(52, 'Scan:Stopped'),
(53, 'CursorOpen'),
(54, 'TransactionLog'),
(55, 'Hash Warning'),
(58, 'Auto Stats'),
(59, 'LockBigGrineadlock Chain'),
(60, 'Lock:Escalation'),
(61, 'OLEDB Errors'),
(67, 'Execution Warnings'),
(68, 'Showplan Text (Unencoded)'),
(69, 'Sort Warnings'),
(70, 'CursorPrepare'),
(71, 'Prepare SQL'),
(72, 'Exec Prepared SQL'),
(73, 'Unprepare SQL'),
(74, 'CursorExecute'),
(75, 'CursorRecompile'),
(76, 'CursorImplicitConversion'),
(77, 'CursorUnprepare'),
(78, 'CursorClose'),
(79, 'Missing Column Statistics'),
(80, 'Missing Join Predicate'),
(81, 'Server Memory Change'),
(82, 'UserConfigurable:0'),
(83, 'UserConfigurable:1'),
(84, 'UserConfigurable:2'),
(85, 'UserConfigurable:3'),
(86, 'UserConfigurable:4'),
(87, 'UserConfigurable:5'),
(88, 'UserConfigurable:6'),
(89, 'UserConfigurable:7'),
(90, 'UserConfigurable:8'),
(91, 'UserConfigurable:9'),
(92, 'Data File Auto Grow'),
(93, 'Log File Auto Grow'),
(94, 'Data File Auto Shrink'),
(95, 'Log File Auto Shrink'),
(96, 'Showplan Text'),
(97, 'Showplan All'),
(98, 'Showplan Statistics Profile'),
(100, 'RPC Output Parameter'),
(102, 'Audit Database Scope GDR Event'),
(103, 'Audit Schema Object GDR Event'),
(104, 'Audit Addlogin Event'),
(105, 'Audit Login GDR Event'),
(106, 'Audit Login Change Property Event'),
(107, 'Audit Login Change Password Event'),
(108, 'Audit Add Login to Server Role Event'),
(109, 'Audit Add DB User Event'),
(110, 'Audit Add Member to DB Role Event'),
(111, 'Audit Add Role Event'),
(112, 'Audit App Role Change Password Event'),
(113, 'Audit Statement Permission Event'),
(114, 'Audit Schema Object Access Event'),
(115, 'Audit Backup/Restore Event'),
(116, 'Audit DBCC Event'),
(117, 'Audit Change Audit Event'),
(118, 'Audit Object Derived Permission Event'),
(119, 'OLEDB Call Event'),
(120, 'OLEDB QueryInterface Event'),
(121, 'OLEDB DataRead Event'),
(122, 'Showplan XML'),
(123, 'SQL:FullTextQuery'),
(124, 'Broker:Conversation'),
(125, 'Deprecation Announcement'),
(126, 'Deprecation Final Support'),
(127, 'Exchange Spill Event'),
(128, 'Audit Database Management Event'),
(129, 'Audit Database Object Management Event'),
(130, 'Audit Database Principal Management Event'),
(131, 'Audit Schema Object Management Event'),
(132, 'Audit Server Principal Impersonation Event'),
(133, 'Audit Database Principal Impersonation Event'),
(134, 'Audit Server Object Take Ownership Event'),
(135, 'Audit Database Object Take Ownership Event'),
(136, 'Broker:Conversation Group'),
(137, 'Blocked process report'),
(138, 'Broker:Connection'),
(139, 'Broker:Forwarded Message Sent'),
(140, 'Broker:Forwarded Message Dropped'),
(141, 'Broker:Message Classify'),
(142, 'Broker:Transmission'),
(143, 'Broker:Queue Disabled'),
(144, 'Broker:Mirrored Route State Changed'),
(146, 'Showplan XML Statistics Profile'),
(148, 'Deadlock graph'),
(149, 'Broker:Remote Message Acknowledgement'),
(150, 'Trace File Close'),
(152, 'Audit Change Database Owner'),
(153, 'Audit Schema Object Take Ownership Event'),
(155, 'FT:Crawl Started'),
(156, 'FT:Crawl Stopped'),
(157, 'FT:Crawl Aborted'),
(158, 'Audit Broker Conversation'),
(159, 'Audit Broker Login'),
(160, 'Broker:Message Undeliverable'),
(161, 'Broker:Corrupted Message'),
(162, 'User Error Message'),
(163, 'Broker:Activation'),
(164, 'Object:Altered'),
(165, 'Performance statistics'),
(166, 'SQL:StmtRecompile'),
(167, 'Database Mirroring State Change'),
(168, 'Showplan XML For Query Compile'),
(169, 'Showplan All For Query Compile'),
(170, 'Audit Server Scope GDR Event'),
(171, 'Audit Server Object GDR Event'),
(172, 'Audit Database Object GDR Event'),
(173, 'Audit Server Operation Event'),
(175, 'Audit Server Alter Trace Event'),
(176, 'Audit Server Object Management Event'),
(177, 'Audit Server Principal Management Event'),
(178, 'Audit Database Operation Event'),
(180, 'Audit Database Object Access Event'),
(181, 'TM: Begin Tran starting'),
(182, 'TM: Begin Tran completed'),
(183, 'TM: Promote Tran starting'),
(184, 'TM: Promote Tran completed'),
(185, 'TM: Commit Tran starting'),
(186, 'TM: Commit Tran completed'),
(187, 'TM: Rollback Tran starting'),
(188, 'TM: Rollback Tran completed'),
(189, 'Lock:Timeout (timeout > 0)'),
(190, 'Progress Report: Online Index Operation'),
(191, 'TM: Save Tran starting'),
(192, 'TM: Save Tran completed'),
(193, 'Background Job Error'),
(194, 'OLEDB Provider Information'),
(195, 'Mount Tape'),
(196, 'Assembly Load'),
(198, 'XQuery Static Type'),
(199, 'QN: Subscription'),
(200, 'QN: Parameter table'),
(201, 'QN: Template'),
(202, 'QN: Dynamics');

SELECT [RowNumber] As "Row"
,[EventSequence] as EvSeq
,e.EventName
,[StartTime]
,[TextData]
,SUBSTRING([TextData] , 0 , 40 ) [TextDataSMALL]
,CAST([Duration] / 1000.0 AS decimal(18,3)) AS "DurInMs"
,[CPU]
,[Reads]
,[Writes]
,[ObjectName]
--,[ApplicationName]
,[TransactionID]

```
  ,[SPID]
  ,[DatabaseID]
  ,[DatabaseName]
  ,[ClientProcessID]
  ,[GroupID]
  ,[HostName]
  ,[IsSystem]
  ,[LoginSid]
  ,[NTDomainName]
  ,[NTUserName]
  ,[RequestID]
  ,[ServerName]
  ,[SessionLoginName]
  ,[BigintData1]
  ,[BinaryData]
  ,[EndTime]
  ,[IntegerData]
  ,[IntegerData2]
  ,[Mode]
  ,[ObjectID]
  ,[ObjectID2]
  ,[OwnerID]
  ,[Type]
  ,[EventSubClass]
```
FROM [MTA].[dbo].[ExportSqlProfiler] ex
left join #EventClass as e on ex.EventClass = e.EventClass
where 1 = 1
--AND TextData like '%mircoso%'
--AND RowNumber >= 1289 AND RowNumber <= 1878
--AND ApplicationName = 'Microsoft SQL Server Management Studio - Query'
AND TextData like 'DELETE FROM pippo%'
AND ObjectName = 'trigger_pippo'
order by "Row",
"DurInMs" desc
--Reads desc

```
/*
SELECT *
```
FROM [MTA].[dbo].[ExportSqlProfiler] ex
where ObjectName = 'XYZ'
and (rownumber = 1289 OR rownumber = 1878)
*/
--27369