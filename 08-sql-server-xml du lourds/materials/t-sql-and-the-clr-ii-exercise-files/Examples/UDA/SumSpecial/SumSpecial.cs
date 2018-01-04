using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;


[Serializable]
[Microsoft.SqlServer.Server.SqlUserDefinedAggregate(Format.Native)]
public struct SumSpecial
{
    public void Init()
    {
        var1 = new SqlInt32(0);


    }

    public void Accumulate(SqlInt32 Value)
    {
        var1 += Value;


    }

    public void Merge(SumSpecial Group)
    {
        var1 += Group.var1;


    }

    public SqlInt32 Terminate()
    {
        return var1;


    }

    // This is a place-holder member field
    private SqlInt32 var1;

}
