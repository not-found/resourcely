package de.notfound.resourcely.util
{
	public class FileUtil
	{
		/**
		 * Checks if the extension belongs to a supported image type or not.
		 * @param extension The extension to be checked.
		 */
		public static function isImageFile(extension : String) : Boolean
		{
			if(extension == null)
				return false;
			
			var extensionLowerCase : String = extension.toLocaleLowerCase();
			return extensionLowerCase == "jpg" || extensionLowerCase == "jpeg" || extensionLowerCase == "png" || extensionLowerCase == "gif";
		}
	}
}