USE CustomerManagement
EXEC tSQLt.NewTestClass 
	@ClassName = N'TestClassNotConformingToNamingStandards' -- nvarchar(max)

GO

IF OBJECT_ID('dbo.LogNamingConvention') IS NULL
CREATE TABLE dbo.LogNamingConvention
    (
      NAME SYSNAME ,
      SchemaID INT ,
      dt DATETIME NOT NULL
                  DEFAULT GETDATE()
    )
GO

EXEC tSQLt.NewTestClass @ClassName = N'DevelopmentStandards' -- nvarchar(max)
GO
CREATE PROC DevelopmentStandards.[test Naming Convention - test classes correspond to object in database] AS
--Assemble
--Act
SELECT  Name,
		SchemaID,
		OBJECT_ID('dbo.' + name) AS ObjectID
INTO DevelopmentStandards.Actual
FROM    tSQLt.TestClasses
WHERE OBJECT_ID('dbo.' + name) IS NULL
AND NAME != OBJECT_SCHEMA_NAME(@@ProcID)
ORDER BY NAME

--Assert

--Log any found to the LogNamingConvention table:
DECLARE @Code varchar(MAX)
SET @Code = 'INSERT dbo.LogNamingConvention (Name,SchemaID)
	SELECT  Name,
			SchemaID
	FROM    tSQLt.TestClasses (nolock)
	WHERE OBJECT_ID(''dbo.'' + name) IS NULL
	AND NAME != '''+OBJECT_SCHEMA_NAME(@@ProcID)+'''
'
EXEC tSQLt.NewConnection @Code

EXEC tSQLt.AssertEmptyTable 'DevelopmentStandards.Actual'

GO

EXEC tSQLt.Run 'DevelopmentStandards'

SELECT * FROM dbo.LogNamingConvention