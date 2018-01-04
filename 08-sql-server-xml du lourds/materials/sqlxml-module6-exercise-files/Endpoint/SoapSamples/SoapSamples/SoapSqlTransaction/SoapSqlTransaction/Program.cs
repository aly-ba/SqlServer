#region Using directives

using System;
using System.Data;
using System.Web.Services.Protocols;
using SoapSqlTransaction.localhost;

#endregion

namespace SoapSqlTransaction
{
    class Program
    {
        static void Main(string[] args)
        {
            DoSession();
            DoTransaction();
        }

        public static void DoSession()
        {
            object[] o = null;
            try
            {
                // instantiate web service
                pubs_endpoint e = new pubs_endpoint();

                e.Url = "http://localhost/pubs";
                e.sqlSession = new SqlSoapHeader.sqlSession();
                e.sqlSession.initiate = true;
                //e.sqlSession.MustUnderstand = true;
                //e.sqlSession.timeout = 5;

                // use security of current client principal
                e.Credentials = System.Net.CredentialCache.DefaultCredentials;

                // set up the parameter(s)
                SqlParameter[] p = null;

                // invoke parameterized query and return result(s)
                o = e.sqlbatch("INSERT jobs VALUES('Row1', 10, 10)", ref p);

                // process array of results
                ProcessWSResults(o);

                Console.WriteLine(e.sqlSession.sessionId);

                // use the current session
                e.sqlSession.initiate = false;
                e.sqlSession.timeoutSpecified = false;

                /* or this
                System.Byte[] b;
                b = e.sqlSession.sessionId;
                e.sqlSession = new SqlSoapHeader.sqlSession();
                e.sqlSession.sessionId = b;
                */

                // invoke parameterized query and return result(s)
                o = e.sqlbatch("INSERT jobs VALUES('Row2', 10, 10)", ref p);

                // process array of results
                ProcessWSResults(o);

                // invoke parameterized query and return result(s)
                e.sqlSession.terminate = true;
                e.sqlSession.timeoutSpecified = false;
                o = e.sqlbatch("", ref p);

                // process array of results
                ProcessWSResults(o);
            }
            catch (SoapException se)
            {
                Console.WriteLine("SoapException:");
                Console.WriteLine("Message = {0}", se.Message);
                Console.WriteLine("Code = {0}", se.Code);
                Console.WriteLine("Detail message = {0}", se.Detail.OuterXml);
            }
            catch (Exception e)
            {
                // other exceptions
                Console.WriteLine(e.GetType().ToString());
            }
        }

        // fixme
        static SqlTransaction g_tx = null;

        public static void DoTransaction()
        {
            object[] o = null;
            try
            {
                // instantiate web service
                pubs_endpoint e = new pubs_endpoint();

                e.Url = "http://localhost/pubs";
                e.sqlSession = new SqlSoapHeader.sqlSession();
                e.sqlSession.initiate = true;
                //e.sqlSession.MustUnderstand = true;
                //e.sqlSession.timeout = 5;

                e.sqlChangeNotif = new SqlSoapHeader.environmentChangeNotifications();
                e.sqlChangeNotif.transactionBoundary = true;

                // use security of current client principal
                e.Credentials = System.Net.CredentialCache.DefaultCredentials;

                // set up the parameter(s)
                SqlParameter[] p = null;

                // invoke parameterized query and return result(s)
                o = e.sqlbatch("BEGIN TRAN;INSERT jobs VALUES('Row1', 10, 10)", ref p);

                // process array of results
                ProcessWSResults(o);

                Console.WriteLine(e.sqlSession.sessionId);

                // use the current session
                e.sqlSession.initiate = false;
                e.sqlSession.timeoutSpecified = false;
                e.sqlSession.transactionDescriptor = g_tx.Descriptor;

                e.sqlChangeNotif = null;

                /* or this
                System.Byte[] b;
                b = e.sqlSession.sessionId;
                e.sqlSession = new SqlSoapHeader.sqlSession();
                e.sqlSession.sessionId = b;
                */

                // invoke parameterized query and return result(s)
                o = e.sqlbatch("INSERT jobs VALUES('Row2', 10, 10)", ref p);

                // process array of results
                ProcessWSResults(o);

                // use the current session
                e.sqlSession.initiate = false;
                e.sqlSession.timeoutSpecified = false;
                e.sqlSession.transactionDescriptor = g_tx.Descriptor;

                // you don't need this here, it will cause an error
                // but still get notified, ...strange
                //e.sqlChangeNotif = new SqlSoapHeader.environmentChangeNotifications();
                //e.sqlChangeNotif.transactionBoundary = true;

                // invoke parameterized query and return result(s)
                // ROLLBACK TRAN also works as expected
                o = e.sqlbatch("COMMIT TRAN", ref p);

                // process array of results
                ProcessWSResults(o);

                // invoke parameterized query and return result(s)
                e.sqlSession.terminate = true;
                e.sqlSession.timeoutSpecified = false;

                // Not needed, will cause error
                //e.sqlSession.transactionDescriptor = g_tx.Descriptor;
                //e.sqlChangeNotif.transactionBoundary = false;
                o = e.sqlbatch("", ref p);

                // process array of results
                ProcessWSResults(o);
            }
            catch (SoapException se)
            {
                Console.WriteLine("SoapException:");
                Console.WriteLine("Message = {0}", se.Message);
                Console.WriteLine("Code = {0}", se.Code);
                Console.WriteLine("Detail message = {0}", se.Detail.OuterXml);
            }
            catch (Exception e)
            {
                // other exceptions
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

                        case "SqlTransaction":
                            SqlTransaction tx = (SqlTransaction)o[i];
                            Console.WriteLine("Transaction Type {0}", tx.Type);
                            if (tx.Type == SqlTransactionType.Begin)
                                g_tx = tx;
                            else
                                g_tx = null;

                            break;

                        case "DataSet":
                            DataSet ds = (DataSet)o[i];
                            Console.WriteLine("DataSet contains {0} tables", ds.Tables.Count);
                            if (ds.Tables.Count > 0)
                                for (int j = 0; j < ds.Tables.Count; j++)
                                    Console.WriteLine("Table {0} contains {1} rows", j, ds.Tables[j].Rows.Count);
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

        // this should likely be an enum
        public static string GetNormalizedType(Type t)
        {
            string ts = t.ToString();

            // fix this to use LastIndexOf
            if (ts.Contains("SqlMessage"))
                return "SqlMessage";
            if (ts.Contains("SqlRowCount"))
                return "SqlRowCount";
            if (ts.Contains("SqlTransaction"))
                return "SqlTransaction";

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
