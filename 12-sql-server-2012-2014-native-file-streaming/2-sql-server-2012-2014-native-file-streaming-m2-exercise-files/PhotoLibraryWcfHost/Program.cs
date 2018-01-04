using PhotoLibraryWcfService;
using System;
using System.ServiceModel;

namespace PhotoLibraryWcfHost
{
	public class Program
	{
		public static void Main(string[] args)
		{
			const string ServiceUrl = "net.tcp://localhost:4133/PhotoService";
			using (var host = new ServiceHost(typeof(PhotoService), new Uri(ServiceUrl)))
			{
				host.AddServiceEndpoint(typeof(IPhotoService), new NetTcpBinding(), string.Empty);
				host.Open();
				Console.WriteLine("PhotoLibrary WCF Host is running.");
				Console.WriteLine("Press any key to stop...");
				Console.ReadKey();
				host.Close();
			}
		}
	}
}
