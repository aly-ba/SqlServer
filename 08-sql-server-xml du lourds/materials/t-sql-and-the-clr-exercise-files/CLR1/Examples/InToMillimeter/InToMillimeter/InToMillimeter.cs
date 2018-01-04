using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static float InToMillimeter(float inches)
    {
        return GetConversion() * inches;
    }
    [SqlFunction]
    public static float MillimeterToIn(float millimeter)
    {
        return millimeter / GetConversion();
    }

    public static float GetConversion()
    {
        var cf = 25.4f;
        return cf;
    }



};

