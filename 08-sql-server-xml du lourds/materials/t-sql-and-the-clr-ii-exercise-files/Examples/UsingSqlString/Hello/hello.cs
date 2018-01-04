using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction]
    public static SqlString Hello(SqlString name)
    {
        return new SqlString("Hello ") + name;
    }

    [SqlFunction]
    [return: SqlFacet(MaxSize = -1)]
    public static SqlString LongHello(
    [SqlFacet(MaxSize = -1)] SqlString name)
    {
        return new SqlString("Hello ") + name;
    }


};

