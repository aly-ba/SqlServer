
use tempdb
go

-- check schema information
SELECT * FROM sys.xml_schema_collections
SELECT * FROM sys.xml_schema_namespaces
SELECT * FROM sys.xml_schema_elements 
SELECT * FROM sys.xml_schema_attributes 
SELECT * FROM sys.xml_schema_types
SELECT * FROM sys.column_xml_schema_collection_usages
SELECT * FROM sys.parameter_xml_schema_collection_usages

DECLARE @s xml
SELECT @s = xml_schema_namespace(
   N'dbo', N'geocoll')
SELECT @s
go

-- or return schema for single namespace
DECLARE @s xml
SELECT @s = xml_schema_namespace(
   N'dbo', N'geocoll', 'urn:geo') 
SELECT @s
GO
