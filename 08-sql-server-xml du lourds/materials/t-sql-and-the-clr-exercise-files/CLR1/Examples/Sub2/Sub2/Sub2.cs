using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static float Sub2(float minuend, float subtrahend)
    {
        // Put your code here
        return minuend-subtrahend;
    }

    public static float Add2(float addend1, float addend2)
    {
        return addend1 + addend2;
    }
};

