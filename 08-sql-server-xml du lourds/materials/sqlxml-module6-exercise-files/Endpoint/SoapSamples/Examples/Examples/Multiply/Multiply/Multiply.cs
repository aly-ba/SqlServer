using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(Name="mymul", 
        // tells SQL Server that same in produces same out
        IsDeterministic=true,
        // tells SQL Server that floating point is used
        IsPrecise=false
        
        
        )]
    public static float Multiply(float mul1, float mul2)
    {
        // Put your code here
        return mul1*mul2;
    }
};

