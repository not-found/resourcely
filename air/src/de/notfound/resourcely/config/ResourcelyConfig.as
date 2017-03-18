package de.notfound.resourcely.config
{
	import de.notfound.resourcely.config.strategy.ResourceLocationStrategy;
	import de.notfound.resourcely.config.strategy.ResourceScalingStrategy;

	import flash.filesystem.File;
	
	/**
	 * This class controls resourcelys behavior.
	 */
	public class ResourcelyConfig
	{
		/**
		 * The resource directory where all the image files are located. By default resourcely will look for a 'res' folder.
		 */
		public var resourceDirectory : File;
		
		/**
		 * The location strategy used to search for resources.
		 * @default DefaultResourceLocationStrategy
		 */
		public var resourceLocationStrategy : ResourceLocationStrategy;
		
		/**
		 * The scaling strategy used to scale the images.
		 * @default DefaultResourceScalingStrategy
		 */
		public var resourceScalingStrategy : ResourceScalingStrategy;
		
		/**
		 * The value used for calculations depending on the currents device dpi value. By default it's set to Capabilities.screenDPI, but it
		 * can be overwritten.
		 * @default Capabilities.screenDPI
		 */
		public var deviceDpi : Number;
		
		/**
		 * The maximum value in byte resourcely is allowed to use for its cache size.
		 * @default By default resourcely will use every space available.
		 */
		public var maxCacheSize : Number;
	}
}