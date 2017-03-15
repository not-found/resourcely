package de.notfound.resourcely.config
{
	import flash.system.Capabilities;
	import de.notfound.resourcely.config.strategy.DefaultResourceScalingStrategy;
	import de.notfound.resourcely.config.strategy.ResourceScalingStrategy;
	import de.notfound.resourcely.config.strategy.DefaultResourceLocationStrategy;
	import de.notfound.resourcely.config.strategy.ResourceLocationStrategy;
	import flash.filesystem.File;

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

		public function setResourcePath(resourceDirectory : File) : ResourcelyConfigBuilder
		{
			_config.resourceDirectory = resourceDirectory;
			return this;
		}

		public function setResourceLocationStrategy(resourceLocationStrategy : ResourceLocationStrategy) : ResourcelyConfigBuilder
		{
			_config.resourceLocationStrategy = resourceLocationStrategy;
			return this;
		}
		
		public function setResourceScalingStrategy(resourceScalingStrategy : ResourceScalingStrategy) : ResourcelyConfigBuilder
		{
			_config.resourceScalingStrategy = resourceScalingStrategy;
			return this;
		}
		
		public function setDeviceDpi(dpi : Number) : ResourcelyConfigBuilder
		{
			_config.deviceDpi = dpi;
			return this;
		}
		
		public function build() : ResourcelyConfig
		{
			return _config;
		}

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