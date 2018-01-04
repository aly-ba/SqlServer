//c#
using System;
using System.Data.SqlTypes;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

namespace SQLDev.Clr
{
	public class Demo
	{
		static public void CustomerGetProcedure(SqlInt32 customerId)
		{
			using (SqlConnection conn = new SqlConnection("context connection=true"))
			{
				SqlCommand cmd = conn.CreateCommand();
				cmd.CommandText = @"SELECT * FROM Sales.Customers
				                             WHERE CustomerID = @CustomerID";
				cmd.Parameters.AddWithValue("@CustomerID", customerId);
				conn.Open();
				//Execute the command and send the results to the caller.
				SqlContext.Pipe.ExecuteAndSend(cmd);
			}
		}
	}
}