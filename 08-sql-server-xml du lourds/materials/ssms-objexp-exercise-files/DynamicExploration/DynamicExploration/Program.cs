using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Smo.Wmi;
using Microsoft.SqlServer.Management.Common;
using r=System.Reflection;
using Microsoft.SqlServer.Management.Sdk.Sfc;
namespace DynamicExploration
{
	class Program
	{
		static void Main(string[] args)
		{			
			Server server = new Server();
			Urn tableUrn= new Urn(
				"Server[@Name='DARKMATTER5']/Database[@Name='CTERankingPartitioning']/Table[@Name='employees']");
			Table table = (Table)server.GetSmoObject(tableUrn);
			
			foreach (r.PropertyInfo pi in typeof(Table).GetProperties())
			{
				if (pi.PropertyType.IsSubclassOf(typeof(SmoCollectionBase)))
				{
					Console.WriteLine(pi.Name);
				}
			}
            ScriptingOptions so = new ScriptingOptions();
            so.ScriptOwner = true;
            Console.WriteLine("=========");
            foreach(string str in table.Script(so))
            {
                Console.WriteLine(str);
            }
        }
	}
}
