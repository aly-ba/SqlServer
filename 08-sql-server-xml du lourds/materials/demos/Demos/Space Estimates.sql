EXEC sp_estimate_data_compression_savings 
	'dbo','ints',NULL,NULL,'ROW';
EXEC sp_estimate_data_compression_savings 
	'dbo','ints',NULL,NULL,'PAGE';

--2088	1456
--2088	1432

EXEC sp_spaceused 'ints';

ALTER TABLE [dbo].[ints] REBUILD WITH(DATA_COMPRESSION = ROW);

EXEC sp_spaceused 'ints';

ALTER TABLE [dbo].[ints] REBUILD WITH(DATA_COMPRESSION = PAGE);

EXEC sp_spaceused 'ints';

SELECT TOP(10) * FROM [dbo].[uniqid];

EXEC sp_estimate_data_compression_savings 
	'dbo','uniqid',NULL,NULL,'ROW';
EXEC sp_estimate_data_compression_savings 
	'dbo','uniqid',NULL,NULL,'PAGE';


SELECT TOP(10) * FROM [dbo].[xmls];

EXEC sp_estimate_data_compression_savings 
	'dbo','xmls',NULL,NULL,'ROW';
EXEC sp_estimate_data_compression_savings 
	'dbo','xmls',NULL,NULL,'PAGE';


SELECT * 
FROM [sys].[dm_db_index_operational_stats]
	(db_id(),object_id('xmls'),NULL,NULL);