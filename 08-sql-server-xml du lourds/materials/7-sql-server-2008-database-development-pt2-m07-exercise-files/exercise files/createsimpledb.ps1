
#createsimpledb.ps1
#Creates a new database using defaults
[System.Reflection.Assembly]::LoadWithPartialName('Microsoft.SqlServer.SMO')  | out-null
$s = new-object ('Microsoft.SqlServer.Management.Smo.Server') 'win08-sql08'
$dbname = 'SMOSimple_DB'
$db = new-object ('Microsoft.SqlServer.Management.Smo.Database') ($s, $dbname)
$db.Create()