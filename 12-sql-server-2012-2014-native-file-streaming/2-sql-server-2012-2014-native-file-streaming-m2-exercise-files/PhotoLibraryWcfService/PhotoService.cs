using System.IO;

namespace PhotoLibraryWcfService
{
	public class PhotoService : IPhotoService
	{
		public MemoryStream GetPhoto(int photoId)
		{
			var ms = PhotoData.SelectPhoto(photoId);
			return ms;
		}
	}
}
