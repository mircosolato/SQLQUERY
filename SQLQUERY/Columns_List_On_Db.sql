SELECT s.name AS schema_name
      ,t.name AS table_Name
      ,c.name AS column_Name
    --,c.max_length
FROM [SERVER].[DB].sys.tables t
JOIN [SERVER].[DB].sys.schemas s ON t.schema_id = s.schema_id
JOIN [SERVER].[DB].sys.columns c ON t.object_id = c.object_id
--WHERE s.name = 'dbo'
ORDER BY s.name, t.name, c.name
