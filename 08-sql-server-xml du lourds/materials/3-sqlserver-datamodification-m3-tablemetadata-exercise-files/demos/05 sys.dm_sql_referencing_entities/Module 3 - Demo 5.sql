-- Module 3, Demo 5
-- sys.dm_sql_referencing_entities

-- Remove "count of number of rows" messages
SET NOCOUNT ON;
GO

-- What references the Person.Person table?
SELECT  [referencing_schema_name] ,
        [referencing_entity_name] ,
        [referencing_class_desc]
FROM    sys.[dm_sql_referencing_entities]('Person.Person', 'OBJECT') AS dsre
ORDER BY [referencing_entity_name];
GO