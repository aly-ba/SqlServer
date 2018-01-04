using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static float Subtract(float minuend, float subtrahend)
    {
        // Put your code here
        return minuend-subtrahend;
    }
};

