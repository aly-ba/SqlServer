using System;
using System.Collections.Generic;
using System.Text;
using Microsoft.SqlServer.Management.Smo;
using Microsoft.SqlServer.Management.Smo.Wmi;
using Microsoft.SqlServer.Management.Common;
using r=System.Reflection;
namespace DynamicExploration
{
	class Program
	{
		static void Main(string[] args)
		{			
			Server server = new Server();
			Urn tableUrn= new Urn(
				"Server[@Name='PARSEC5']/Database[@Name='SqlLabs']/Table[@Name='Places']");
			Table table = (Table)server.GetSmoObject(tableUrn);
			
			foreach (r.PropertyInfo pi in typeof(Table).GetProperties())
			{
				if (pi.PropertyType.IsSubclassOf(typeof(SmoCollectionBase)))
				{
					Console.WriteLine(pi.Name);
				}
			}
		}
	}
}
