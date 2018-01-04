/* Use with care - this will remove all tests from your database, with the test framework*/

USE CustomerManagement
GO
IF OBJECT_ID('tSQLt.TestClasses') IS NOT NULL
BEGIN
DECLARE @testclass NVARCHAR(MAX)
DECLARE testclasses CURSOR LOCAL FAST_FORWARD FOR
SELECT Name FROM tSQLt.TestClasses
OPEN testclasses
FETCH NEXT FROM testclasses INTO @testclass
WHILE @@FETCH_STATUS = 0
BEGIN
	EXEC tSQLt.DropClass @ClassName = @testclass
	FETCH NEXT FROM testclasses INTO @testclass
END
CLOSE testclasses
DEALLOCATE testclasses
END

SELECT * FROM tSQLt.TestClasses

IF OBJECT_ID('tSQLt.Uninstall') IS NOT NULL
    BEGIN
        EXEC tSQLt.Uninstall
    END
ELSE
    BEGIN
        PRINT 'Unable to uninstall - does tSQLt framework exist?'
    END
