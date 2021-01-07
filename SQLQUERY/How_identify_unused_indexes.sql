

SELECT
	schemas.name as [Schema_name],
    objects.name AS Table_name,
    indexes.name AS Index_name,
    dm_db_index_usage_stats.user_seeks,
    dm_db_index_usage_stats.user_scans,
    dm_db_index_usage_stats.user_updates,
	'DROP INDEX ' + indexes.name + ' ON ' + schemas.name + '.' + objects.name as sql_text
FROM
    sys.dm_db_index_usage_stats
    INNER JOIN sys.objects ON dm_db_index_usage_stats.OBJECT_ID = objects.OBJECT_ID
    INNER JOIN sys.indexes ON indexes.index_id = dm_db_index_usage_stats.index_id AND dm_db_index_usage_stats.OBJECT_ID = indexes.OBJECT_ID
	INNER JOIN sys.schemas ON schemas.schema_id = objects.schema_id
WHERE
    indexes.is_primary_key = 0 --This line excludes primary key constarint
    AND indexes. is_unique = 0 --This line excludes unique key constarint
    AND dm_db_index_usage_stats.user_updates <> 0 -- This line excludes indexes SQL Server hasn’t done any work with
    AND dm_db_index_usage_stats. user_lookups = 0
    AND dm_db_index_usage_stats.user_seeks = 0
    AND dm_db_index_usage_stats.user_scans = 0
	AND indexes.name is not null
ORDER BY
    --dm_db_index_usage_stats.user_updates DESC
	objects.name, indexes.name
OPTION (RECOMPILE);

