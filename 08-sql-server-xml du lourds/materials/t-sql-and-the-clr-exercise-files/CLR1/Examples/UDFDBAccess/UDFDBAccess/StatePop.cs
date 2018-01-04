using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;
using System.Configuration;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(DataAccess = DataAccessKind.Read)]
    public static int StatePop(string state)
    {
        int pop = 0;
        var connstring = "context connection=true";
        if (SqlContext.IsAvailable == false)
        {
            connstring = ConfigurationManager.AppSettings["mydb"];

        }


        using (var conn = new SqlConnection(connstring))
        using (var command = new SqlCommand(
        "Select count(*) from People where state = @state", conn))
        {
            command.Parameters.Add("@state", SqlDbType.NChar, 2);
            command.Parameters["@state"].Value = state;
            conn.Open();
            pop = (int)command.ExecuteScalar();
        }
        return pop;
    }



};

