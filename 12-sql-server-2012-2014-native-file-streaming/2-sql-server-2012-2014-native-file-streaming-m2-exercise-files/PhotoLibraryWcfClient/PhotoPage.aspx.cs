using System;
using System.Web.UI;

namespace PhotoLibraryWcfClient
{
	public partial class PhotoPage : Page
	{
		protected void loadLinkButton_Click(object sender, EventArgs e)
		{
			var photoId = int.Parse(loadPhotoIdTextBox.Text);
			photoImage.ImageUrl = string.Format("/PhotoHandler.ashx?photoId={0}", photoId);
		}
	}
}
