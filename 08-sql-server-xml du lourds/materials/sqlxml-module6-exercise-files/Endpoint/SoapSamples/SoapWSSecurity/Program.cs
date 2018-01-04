#region Using directives

using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using System.Web.Services.Protocols;
using SoapWSSecurity.zmv92;
//using SoapWSSecurity.zmv921;

#endregion

namespace SoapWSSecurity
{
    class Program
    {
		[STAThread]
		static void Main(string[] args)
		{
			// 1. Add web reference to http://localhost/pubs?wsdl to the project

			// 2. Add a "using" statement for the proxy class namespace. 
			//    This is [projectname].[host-you-found-the-wsdl]

			// 3. Add a reference to System.Web.Services.dll (for SoapException)
			//    And a using statement for System.Web.Services

			//DoPubsAdHoc();
            DoPubsAdHoc2();
        }

		public static void DoPubsAdHoc()
		{
			object[] o = null;
			try
			{
				// instanciate web service
				pubs_ssl_endpoint e = new pubs_ssl_endpoint();

                e.Url = "https://zmv92/pubs_ssl";
                //e.sqlSession = new SqlSoapHeader.sqlSession();
				//e.sqlSession.MustUnderstand = true;
				//e.sqlSession.initiate = true;
				//e.sqlSession.timeout = 12;

				e.sqlSecurityValue = new SqlSoapHeader.Security();
				e.sqlSecurityValue.Username = "sa";
				e.sqlSecurityValue.Password = "Hyak0144!";
                //e.sqlSecurityValue.MustUnderstand = true;

                //SqlTransaction t = new SqlTransaction();
				//t.Type = SqlTransactionType.Begin;

				// use security of current client principal
				//e.Credentials = System.Net.CredentialCache.DefaultCredentials;

                // this works
                //e.Credentials = new System.Net.NetworkCredential("fred","fred","zmv92");
                e.Credentials = new System.Net.NetworkCredential("fred", "fred", "zmv92");

                // set up the parameter(s)
                /*
				SqlParameter[] p = new SqlParameter[1];
				p[0] = new SqlParameter();
				p[0].name = "state";
				p[0].Value = "OR";

				// invoke parameterized query and return result(s)
				o = e.sqlbatch("select * from authors where state = 'OR'", ref p);
                */

                SqlParameter[] n = null;
                o = e.sqlbatch("select suser_name()", ref n);


                // process array of results
				ProcessWSResults(o);

				//Console.WriteLine(e.sqlSession.sessionId);
			}
			catch (SoapException se)
			{
				Console.WriteLine("SoapException:");
				// nothing in here
				//Console.WriteLine("Message = {0}", se.Message);
				Console.WriteLine("Code = {0}", se.Code);
				Console.WriteLine("Detail message = {0}", se.Detail.OuterXml);
			}
			catch (Exception e)
			{
				// other exceptions
                Console.WriteLine(e.Message);
                if (e.InnerException != null)
                    Console.WriteLine(e.InnerException.Message);
                Console.WriteLine(e.GetType().ToString());
			}
		}

        public static void DoPubsAdHoc2()
        {
            object[] o = null;
            try
            {
                // instanciate web service
                SoapWSSecurity.zmv921.pubs_sslint_endpoint e = new SoapWSSecurity.zmv921.pubs_sslint_endpoint();

                e.Url = "https://zmv92/pubs_sslint";
                //e.sqlSession = new SqlSoapHeader.sqlSession();
                //e.sqlSession.MustUnderstand = true;
                //e.sqlSession.initiate = true;
                //e.sqlSession.timeout = 12;

                e.sqlSecurityValue = new SqlSoapHeader.Security();
                e.sqlSecurityValue.Username = "fredsql";
                e.sqlSecurityValue.Password = "fredsql";
                //e.sqlSecurityValue.MustUnderstand = true;

                //SqlTransaction t = new SqlTransaction();
                //t.Type = SqlTransactionType.Begin;

                // use security of current client principal
                e.Credentials = System.Net.CredentialCache.DefaultCredentials;

                // set up the parameter(s)
                /*
				SqlParameter[] p = new SqlParameter[1];
				p[0] = new SqlParameter();
				p[0].name = "state";
				p[0].Value = "OR";

				// invoke parameterized query and return result(s)
				o = e.sqlbatch("select * from authors where state = 'OR'", ref p);
                */

                SoapWSSecurity.zmv921.SqlParameter[] n = null;
                o = e.sqlbatch("select suser_name()", ref n);


                // process array of results
                ProcessWSResults(o);

                //Console.WriteLine(e.sqlSession.sessionId);
            }
            catch (SoapException se)
            {
                Console.WriteLine("SoapException:");
                // nothing in here
                //Console.WriteLine("Message = {0}", se.Message);
                Console.WriteLine("Code = {0}", se.Code);
                Console.WriteLine("Detail message = {0}", se.Detail.OuterXml);
            }
            catch (Exception e)
            {
                // other exceptions
                Console.WriteLine(e.Message);
                if (e.InnerException != null)
                    Console.WriteLine(e.InnerException.Message);
                Console.WriteLine(e.GetType().ToString());
            }
        }

        public static void ProcessWSResults(object[] o)
		{
			try
			{
				for (int i = 0; i < o.Length; i++)
				{
					Type t = o[i].GetType();
					string ts = GetNormalizedType(t);

					switch (ts)
					{
						case "SqlMessage":
							Console.WriteLine(((SqlMessage)o[i]).Message);
							break;

						case "SqlRowCount":
							Console.WriteLine("{0} rows affected", ((SqlRowCount)o[i]).Count);
							break;

						case "DataSet":
							DataSet ds = (DataSet)o[i];
							Console.WriteLine("DataSet contains {0} tables", ds.Tables.Count);
							if (ds.Tables.Count > 0)
                                for (int j = 0; j < ds.Tables.Count; j++)
                                {
                                    Console.WriteLine("Table {0} contains {1} rows", j, ds.Tables[j].Rows.Count);
                                    Console.WriteLine("First value is {0}", ds.Tables[0].Rows[0][0]);
                                }
                            break;

						//stored procedure returncode
						case "Returncode":
							Console.WriteLine("Integer value {0}", ((int)o[i]));
							break;

						default:
							Console.WriteLine("unknown or unexpected type");
							Console.WriteLine("type = {0}", t.ToString());
							break;
					}
				}
			}
			catch (Exception e)
			{
				Console.WriteLine(e.Message);
			}
		}

		//enum SoapSqlReturnTypes = { SqlMessage, SqlRowCount, XmlElement, DataSet, Returncode, Unknown };

		public static string GetNormalizedType(Type t)
		{
			string ts = t.ToString();

			// fix this to use LastIndexOf
			if (ts.Contains("SqlMessage"))
				return "SqlMessage";
			if (ts.Contains("SqlRowCount"))
				return "SqlRowCount";

			switch (ts)
			{
				case "System.Data.XmlElement":
					return "XmlElement";
				case "System.Data.DataSet":
					return "DataSet";
				case "System.Int32":
					return "Returncode";
				default:
					return "Unknown";
			}
		}
    }
}
