using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Collections.Generic;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static int SimpleAdd(int a1, int a2)
    {
        return a1 + a2;
    }

    [SqlFunction]
    public static SqlInt32 SqlAdd(SqlInt32 a1, SqlInt32 a2)
    {
        return a1 / a2;
    }
    [SqlFunction]
    public static SqlInt32 StrangeAdd(SqlInt32 a1, SqlInt32 a2)
    {
        if (a1 == 100)
        {
            return SqlInt32.Null;
        }
        if (a2.IsNull)
        {
            a2 = 100;
        }
        return a1 + a2;
    }

    internal static int AddHelper(int a1, int a2)
    {
        return a1 + a2;
    }

    [SqlFunction]
    public static SqlInt32 SqlAddWHelper(SqlInt32 a1, SqlInt32 a2)
    {
        if (a1.IsNull || a2.IsNull)
        {
            return SqlInt32.Null;
        }

        var a3 = a1 | a2;
        return AddHelper(a1.Value, a2.Value);
    }





    [SqlFunction]
    public static SqlInt32 Mask(SqlInt32 value, SqlInt32 mask)
    {
        return value | SqlInt32.OnesComplement(mask);
    }




    [SqlFunction]
    public static SqlBoolean BComp(SqlBoolean b1, SqlBoolean b2)
    {
        return ;
    }

    [SqlFunction]
    // if a1 is null treat it as zero
    public static SqlInt16 SqlAddSpecial(SqlInt16 a1, SqlInt16 a2)
    {
        if (a1.IsNull)
        {
            a1 = 0;
        }
        return a1 + a2;
    }






};

