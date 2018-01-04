using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.IO;


public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static int GortAdd(int a1, int a2)
    {
        return a1 + a2;
    }

    [SqlFunction]
    public static string GortFileAttributes(string filePath)
    {
        return File.GetAttributes(filePath).ToString();
    }


};

