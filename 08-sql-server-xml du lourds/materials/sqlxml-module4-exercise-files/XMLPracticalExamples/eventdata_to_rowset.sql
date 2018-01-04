
CREATE TABLE ddl_log (
 id int primary key identity,
 data XML
);

CREATE TRIGGER mytrig
ON DATABASE
FOR CREATE_TABLE 
AS
INSERT ddl_log VALUES(EventData());

create table t7 (id int)

select * from ddl_log


-- This makes your table into a rowset. You could also use a variation of it in your event notification handler, DDL trigger itself. Just leave out the cross apply. I thought I'd seen this before, but can never seem to ever have found it. Now that I've done this, ....learn XML why don't 'ya... There can only be more of it in future. Cheers.

SELECT id, 
 Tab.Col.value('./EventType[1]','nvarchar(50)') AS 'EventType',
 Tab.Col.value('./PostTime[1]','datetime') AS  'PostTime',
 Tab.Col.value('./SPID[1]','nvarchar(50)') AS  'SPID',
 Tab.Col.value('./ServerName[1]','nvarchar(50)') AS  'ServerName',
 Tab.Col.value('./LoginName[1]','nvarchar(50)') AS 'LoginName',
 Tab.Col.value('./UserName[1]','nvarchar(50)') AS 'UserName',
 Tab.Col.value('./DatabaseName[1]','nvarchar(128)') AS 'DatabaseName',
 Tab.Col.value('./SchemaName[1]','nvarchar(128)') AS 'SchemaName',
 Tab.Col.value('./ObjectName[1]','nvarchar(128)') AS 'ObjectName',
 Tab.Col.value('./ObjectType[1]','nvarchar(50)') AS 'ObjectType',
 Tab.Col.value('./TSQLCommand[1]/CommandText[1]','nvarchar(4000)') AS 'CommandText',
 Tab.Col.value('./TSQLCommand[1]/SetOptions[1]/@ANSI_NULLS','nvarchar(3)') AS 'ANSI_NULLS_OPTION',
 Tab.Col.value('./TSQLCommand[1]/SetOptions[1]/@ANSI_NULL_DEFAULT','nvarchar(3)') AS 'ANSI_NULL_DEFAULT_OPTION',
 Tab.Col.value('./TSQLCommand[1]/SetOptions[1]/@ANSI_PADDING','nvarchar(3)') AS 'ANSI_PADDING_OPTION',
 Tab.Col.value('./TSQLCommand[1]/SetOptions[1]/@QUOTED_IDENTIFIER','nvarchar(3)') AS 'QUOTED_IDENTIFIER_OPTION',
 Tab.Col.value('./TSQLCommand[1]/SetOptions[1]/@ENCRYPTED_OPTION','nvarchar(4)') AS 'ENCRYPTED_OPTION'
FROM ddl_log
CROSS APPLY
 data.nodes('/EVENT_INSTANCE') AS Tab(Col)
GO

-- standalone trigger

ALTER TRIGGER mytrig
ON DATABASE
FOR CREATE_TABLE 
AS
DECLARE @x XML
SET @x = Eventdata()
SELECT 
 Tab.Col.value('./EventType[1]','nvarchar(50)') AS 'EventType',
 Tab.Col.value('./PostTime[1]','datetime') AS  'PostTime'
 -- rest of columns deleted for brevity
FROM @x.nodes('/EVENT_INSTANCE') AS Tab(Col)
GO

CREATE TABLE t8 (id int)


-- cleanup
drop table t8
drop table t7
drop table ddl_log
drop trigger mytrig on database
