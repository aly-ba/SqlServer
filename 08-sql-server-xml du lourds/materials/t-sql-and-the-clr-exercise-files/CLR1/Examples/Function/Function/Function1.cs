using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(DataAccess=DataAccessKind.Read)]
    public static SqlInt32 Function1()
    {
        var cs = new SqlConnectionStringBuilder
                     {
                         ContextConnection = true
                         //   IntegratedSecurity=true,
                           // InitialCatalog="CLR1",
                          //  DataSource="Darkmatter5",
                          //  ApplicationName="reconnect test"
                            
                     };
        using (var conn = new SqlConnection(cs.ToString()))
        {
            using (var cmd = new SqlCommand("select count(*) from People", conn))
            {
                conn.Open();
                var i = (int)cmd.ExecuteScalar();
                System.Threading.Thread.Sleep(10000);
                return i;
            }
        }
    }
};

