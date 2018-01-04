using System.IO;
using System.ServiceModel;

namespace PhotoLibraryWcfService
{
	[ServiceContract]
	public interface IPhotoService
	{
		[OperationContract]
		MemoryStream GetPhoto(int photoId);
	}

}
