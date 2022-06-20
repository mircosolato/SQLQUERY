SELECT
	SCHEMA_NAME(o.schema_id) schema_name
   ,OBJECT_NAME(p.object_id) table_name
   ,i.type_desc index_type
   ,i.name index_name
   ,bd.page_type
   ,COUNT(*) page_count
FROM sys.dm_os_buffer_descriptors bd
JOIN sys.allocation_units au
	ON bd.allocation_unit_id = au.allocation_unit_id
JOIN sys.partitions p
	ON (p.hobt_id = au.container_id
			AND au.type IN (1, 3))
		OR (p.partition_id = au.container_id
			AND au.type = 2)
JOIN sys.indexes i
	ON p.index_id = i.index_id
		AND p.object_id = i.object_id
JOIN sys.objects o
	ON o.object_id = i.object_id
WHERE database_id = DB_ID()
--and is_modified = 1
GROUP BY o.schema_id
		,p.object_id
		,i.name
		,i.type_desc
		,bd.page_type
ORDER BY page_count DESC
