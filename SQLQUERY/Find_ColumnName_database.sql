SELECT      s.name AS 'SchemaName',
	t.name AS 'TableName',
	c.name AS 'ColumnName'
FROM        sys.columns c
INNER JOIN  sys.tables  t   ON c.object_id = t.object_id
INNER JOIN  sys.schemas s   ON t.schema_id = s.schema_id
WHERE       c.name LIKE '%[Column name]%'
            --and t.name like '%[Table name]%'
            --and s.name like '%[Schema name]%'
ORDER BY    SchemaName
	,TableName
            ,ColumnName;
