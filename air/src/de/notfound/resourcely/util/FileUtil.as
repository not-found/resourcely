package de.notfound.resourcely.util
{
	public class FileUtil
	{
		public static function isImageFile(extension : String) : Boolean
		{
			if(extension == null)
				return false;
			
			var extensionLowerCase : String = extension.toLocaleLowerCase();
			return extensionLowerCase == "jpg" || extensionLowerCase == "jpeg" || extensionLowerCase == "png" || extensionLowerCase == "gif";
		}
	}
}