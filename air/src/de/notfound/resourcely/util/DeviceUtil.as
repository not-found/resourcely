package de.notfound.resourcely.util
{
	import flash.system.Capabilities;

	public class DeviceUtil
	{
		public static function isWindows() : Boolean
		{
			return Capabilities.version.indexOf("WIN") != -1;
		}

		public static function isMac() : Boolean
		{
			return Capabilities.version.indexOf("MAC") != -1;
		}

		public static function isLinux() : Boolean
		{
			return Capabilities.version.indexOf("LNX") != -1;
		}

		public static function isIOs() : Boolean
		{
			return Capabilities.version.indexOf("IOS") != -1;
		}

		public static function isAndroid() : Boolean
		{
			return Capabilities.version.indexOf("AND") != -1;
		}

		public static function isMobile() : Boolean
		{
			return isAndroid() || isIOs();
		}

		public static function isDesktop() : Boolean
		{
			return isLinux() || isWindows() || isLinux();
		}
	}
}