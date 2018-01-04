using PhotoLibraryWcfService;
using System.Net.Mime;
using System.ServiceModel;
using System.Web;

namespace PhotoLibraryWcfClient
{
	public class PhotoHandler : IHttpHandler
	{
		public void ProcessRequest(HttpContext context)
		{
			var photoId = 0;
			if (!int.TryParse(context.Request.QueryString["photoId"], out photoId))
			{
				return;
			}

			context.Response.ContentType = MediaTypeNames.Image.Jpeg;
			context.Response.BufferOutput = false;

			var address = new EndpointAddress("net.tcp://localhost:4133/PhotoService");
			var binding = new NetTcpBinding() { MaxReceivedMessageSize = 10000000 };
			var proxy = ChannelFactory<IPhotoService>.CreateChannel(binding, address);

			using (var ms = proxy.GetPhoto(photoId))
			{
				context.Response.AddHeader("content-length", ms.Length.ToString());	// not necessary, but nice to let the client know
				ms.CopyTo(context.Response.OutputStream);
			}
		}

		public bool IsReusable
		{
			get { return false; }
		}

	}
}
