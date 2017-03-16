package de.notfound.resourcely.model
{
	/**
	 * Contains some default values for dpi classification based on the categories 
	 * introduced by Google in the Android framework. Every qualifier corresponds to a possible
	 * folder within the resource folder containing images in this dpi class.
	 */
	public class Density
	{
		public static const LDPI : uint = 120;
		public static const MDPI : uint = 160;
		public static const HDPI : uint = 240;
		public static const XHDPI : uint = 320;
		public static const XXHDPI : uint = 480;
		public static const XXXHDPI : uint = 640;

		public static const LDPI_QUALIFIER : String = "ldpi";
		public static const MDPI_QUALIFIER : String = "mdpi";
		public static const HDPI_QUALIFIER : String = "hdpi";
		public static const XHDPI_QUALIFIER : String = "xhdpi";
		public static const XXHDPI_QUALIFIER : String = "xxhdpi";
		public static const XXXHDPI_QUALIFIER : String = "xxxhdpi";
	
		private var _dpi : uint;
		private var _qualifier : String;

		public function Density(dpi : uint, qualifier : String)
		{
			_dpi = dpi;
			_qualifier = qualifier;
		}

		public function get dpi() : uint
		{
			return _dpi;
		}

		public function get qualifier() : String
		{
			return _qualifier;
		}
	}
}