package de.notfound.resourcely.config
{
	import flash.system.Capabilities;
	import de.notfound.resourcely.config.strategy.DefaultResourceScalingStrategy;
	import de.notfound.resourcely.config.strategy.ResourceScalingStrategy;
	import de.notfound.resourcely.config.strategy.DefaultResourceLocationStrategy;
	import de.notfound.resourcely.config.strategy.ResourceLocationStrategy;
	import flash.filesystem.File;
	
	/**
	 * This class can be used to build an ResourcelyConfig.
	 */
	public class ResourcelyConfigBuilder
	{
		private static const RESOURCE_PATH_DEFAULT : File = File.applicationDirectory.resolvePath("res");
		private static const RESOURCE_LOCATION_STRATEGY_DEFAULT : ResourceLocationStrategy = new DefaultResourceLocationStrategy();
		private static const RESOURCE_SCALING_STRATEGY_DEFAULT : ResourceScalingStrategy = new DefaultResourceScalingStrategy();
		
		private var _config : ResourcelyConfig;

		public function ResourcelyConfigBuilder()
		{
			_config = new ResourcelyConfig();
		}
		
		/**
		 * Sets the resourcePath value.
		 * @param resourceDirectory The resourceDirectory to be used.
		 */
		public function setResourcePath(resourceDirectory : File) : ResourcelyConfigBuilder
		{
			_config.resourceDirectory = resourceDirectory;
			return this;
		}
		
		/**
		 * Sets the ResourceLocationStrategy.
		 * @param resourceLocationStrategy The ResourceLocationStrategy to be used.
		 */
		public function setResourceLocationStrategy(resourceLocationStrategy : ResourceLocationStrategy) : ResourcelyConfigBuilder
		{
			_config.resourceLocationStrategy = resourceLocationStrategy;
			return this;
		}
		
		/**
		 * Sets the ResourceScalingStrategy.
		 * @param resourceScalingStrategy The ResourceScalingStrategy to be used.
		 */
		public function setResourceScalingStrategy(resourceScalingStrategy : ResourceScalingStrategy) : ResourcelyConfigBuilder
		{
			_config.resourceScalingStrategy = resourceScalingStrategy;
			return this;
		}
		
		/**
		 * Sets the deviceDPI used to calculate everything depending on the current devices dpi.
		 * @param dpi The dpi value to be used.
		 */
		public function setDeviceDpi(dpi : Number) : ResourcelyConfigBuilder
		{
			_config.deviceDpi = dpi;
			return this;
		}
		
		/**
		 * Builds the config.
		 * @return A config file for the use with resourcely.
		 */
		public function build() : ResourcelyConfig
		{
			return _config;
		}
		
		/**
		 * Creates a config with default configuration.
		 * @return ResourcelyConfig with default configuration.
		 */
		public static function getDefault() : ResourcelyConfig
		{
			var builder : ResourcelyConfigBuilder = new ResourcelyConfigBuilder();
			return builder.setResourcePath(RESOURCE_PATH_DEFAULT)
			.setResourceLocationStrategy(RESOURCE_LOCATION_STRATEGY_DEFAULT)
			.setResourceScalingStrategy(RESOURCE_SCALING_STRATEGY_DEFAULT)
			.setDeviceDpi(Capabilities.screenDPI)
			.build();
		}
	}
}