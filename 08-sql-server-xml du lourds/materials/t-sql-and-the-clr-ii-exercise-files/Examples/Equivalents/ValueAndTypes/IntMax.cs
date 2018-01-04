using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]

    static public SqlInt32 IntMax(SqlInt32 si1, SqlInt32 si2)
    {
        var max = Math.Max(si1.Value, (long)si2);
        return max;
    }


};

