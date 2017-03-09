package de.notfound.resourcely.config
{
	import de.notfound.resourcely.config.strategy.DefaultResourceLocationStrategy;
	import de.notfound.resourcely.config.strategy.ResourceLocationStrategy;
	import flash.filesystem.File;

	public class ResourcelyConfigBuilder
	{
		private static const RESOURCE_PATH_DEFAULT : File = File.applicationDirectory.resolvePath("res");
		private static const RESOURCE_LOCATION_STRATEGY_DEFAULT : ResourceLocationStrategy = new DefaultResourceLocationStrategy();
		
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

		public function build() : ResourcelyConfig
		{
			return _config;
		}

		public static function getDefault() : ResourcelyConfig
		{
			var builder : ResourcelyConfigBuilder = new ResourcelyConfigBuilder();
			builder.setResourcePath(RESOURCE_PATH_DEFAULT);
			builder.setResourceLocationStrategy(RESOURCE_LOCATION_STRATEGY_DEFAULT);

			return builder.build();
		}
	}
}