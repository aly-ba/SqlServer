/***********************************************************
** This script is from Module 1 of the Pluralsight course **
** Unit testing T-SQL code with tSQLt by Dave Green       **
***********************************************************/

EXEC sp_configure 'clr enabled', 1;
RECONFIGURE;

/* Now run Example.sql from tSQLt web site */


USE tSQLt_Example
GO

/* Show test Schemae */
SELECT * FROM tSQLt.TestClasses

/* We can run tests either by running all tests in the database: */
EXEC tSQLt.RunAll

/* or by running only the tests in a specific test class: */
EXEC tSQLt.Run 'AcceleratorTests'



/* Note result of test execution is stored in a table */
SELECT * FROM tSQLt.TestResult



/* We can see the version of tSQLt in this database by running: */
SELECT * FROM tSQLt.info()