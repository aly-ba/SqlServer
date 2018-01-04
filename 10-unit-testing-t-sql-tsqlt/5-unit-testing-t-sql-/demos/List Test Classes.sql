/*******************************************************************************
*                                                                              * 
* This script lists the tSQLt test classes in the CustomerManagement database. *
*                                                                              * 
*******************************************************************************/

use CustomerManagement
GO
SELECT * FROM tSQLt.TestClasses ORDER BY Name


--If Test Classes are named after the object under test, you can see the definition of the object:

SELECT *,OBJECT_DEFINITION(OBJECT_ID('dbo.'+name)) [Definition of object] FROM tSQLt.TestClasses ORDER BY Name