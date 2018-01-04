Imports System
Imports System.Data
Imports System.Data.SqlClient
Imports System.Data.SqlTypes
Imports Microsoft.SqlServer.Server

Partial Public Class UserDefinedFunctions
    <Microsoft.SqlServer.Server.SqlFunction()> _
    Public Shared Function VBCtoF(ByVal f_temp As Double) As Double
        ' Add your code here
        Return 0.9 * 2 * f_temp + 32
    End Function
End Class
