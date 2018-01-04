using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Data.SqlTypes;
using System.IO;
using System.Transactions;

namespace PhotoLibraryWcfService
{
	public static class PhotoData
	{
		public static MemoryStream SelectPhoto(int photoId)
		{
			var ms = default(MemoryStream);

			var connStr = ConfigurationManager.ConnectionStrings["PhotoLibraryDb"].ConnectionString;
			using (var conn = new SqlConnection(connStr))
			{
				using (var cmd = new SqlCommand("SelectPhotoImageInfo", conn))
				{
					using (var ts = new TransactionScope())
					{
						cmd.CommandType = CommandType.StoredProcedure;
						cmd.Parameters.AddWithValue("@PhotoId", photoId);

						var serverPathName = default(string);
						var serverTxnContext = default(byte[]);

						conn.Open();
						using (var rdr = cmd.ExecuteReader(CommandBehavior.SingleRow))
						{
							rdr.Read();
							serverPathName = rdr.GetSqlString(0).Value;
							serverTxnContext = rdr.GetSqlBinary(1).Value;
							rdr.Close();
						}
						conn.Close();

						using (var source = new SqlFileStream(serverPathName, serverTxnContext, FileAccess.Read))
						{
							using (var dest = new MemoryStream())
							{
								source.CopyTo(dest, 4096);
								dest.Close();
								ms = new MemoryStream(dest.ToArray());
							}
							source.Close();
						}

						ts.Complete();
					}
				}
			}

			return ms;
		}
	}

}
