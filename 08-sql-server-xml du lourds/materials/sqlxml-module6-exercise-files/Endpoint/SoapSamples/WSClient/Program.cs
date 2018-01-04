using System;
using System.Collections.Generic;
using System.Text;
using System.Data;

namespace WSClient
{
    class Program
    {
        static void Main(string[] args)
        {
            WSClient.localhost.pubs p = new WSClient.localhost.pubs();
            p.Credentials = System.Net.CredentialCache.DefaultCredentials;
            object[] objs = p.hello_world("bob");
            foreach (Object o in objs)
            {
                string s = o.GetType().ToString();
                Console.WriteLine(s);
                if (s == "System.Data.DataSet")
                {
                    DataSet ds = (DataSet)o;
                    Console.WriteLine("Answer is: " + ds.Tables[0].Rows[0][0]);
                }
            }
        }
    }
}
