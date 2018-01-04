#region Using directives

using System;
using System.Data;
using System.Web.Services.Protocols;
using SoapNotifRequest.localhost;

#endregion

namespace SoapNotifRequest
{
    class Program
    {
        static void Main(string[] args)
        {
            DoSession();
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

                // must define MySoapBroker SERVICE and associated QUEUE in SQL Server
                e.sqlNotif = new SqlSoapHeader.notificationRequest();
                e.sqlNotif.deliveryService = "MySoapBroker";
                e.sqlNotif.notificationId = Guid.NewGuid().ToString();
                e.sqlNotif.timeout = "10000";

                // set up the parameter(s)
                SqlParameter[] p = null;

                // invoke parameterized query and return result(s)
                o = e.sqlbatch("SELECT job_id, job_desc FROM dbo.jobs", ref p);

                // process array of results
                ProcessWSResults(o);

                // invoke parameterized query and return result(s)
                e.sqlSession.terminate = true;
                e.sqlSession.timeoutSpecified = false;
                e.sqlNotif = null;
                o = e.sqlbatch("", ref p);

                // process array of results
                ProcessWSResults(o);

                // now change a row on SQL Server with a different client
                // and note a notification is inserted in the queue...
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
                            // only support local tx for now
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
