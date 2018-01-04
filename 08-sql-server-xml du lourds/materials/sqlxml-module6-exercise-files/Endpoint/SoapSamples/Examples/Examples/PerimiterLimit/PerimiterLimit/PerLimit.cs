using System;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using Microsoft.SqlServer.Server;

public partial class UserDefinedFunctions
{
    [Microsoft.SqlServer.Server.SqlFunction(DataAccess=DataAccessKind.Read)
    ]
    public static int GetBigPerims(int minSize)
    {
        using (SqlConnection conn = new SqlConnection("context connection=true"))
        using (SqlCommand cmd = new SqlCommand(
        "select count(*) from Rectangles where [half perimiter] > @limit;", conn))
        {
            cmd.Parameters.AddWithValue("@limit", minSize);
            conn.Open();
            var count = (int)cmd.ExecuteScalar();
            return count;
        }
    }


};

