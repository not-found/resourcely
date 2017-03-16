package de.notfound.resourcely.config
{
	import de.notfound.resourcely.config.strategy.ResourceScalingStrategy;
	import de.notfound.resourcely.config.strategy.ResourceLocationStrategy;
	import org.flexunit.Assert;
	import flash.filesystem.File;

	public class ResourcelyConfigBuilderTest
	{
		private var _resourcelyConfigBuilder : ResourcelyConfigBuilder;
		
		[Before]
		public function startUp() : void
		{
			_resourcelyConfigBuilder = new ResourcelyConfigBuilder();
		}
		
		[Test]
		public function testDefaultConfig() : void
		{
			var config : ResourcelyConfig = ResourcelyConfigBuilder.getDefault().build();
			
			Assert.assertEquals(ResourcelyConfigBuilder.DEVICE_DPI_DEFAULT, config.deviceDpi);
			Assert.assertEquals(ResourcelyConfigBuilder.RESOURCE_PATH_DEFAULT, config.resourceDirectory);
			Assert.assertEquals(ResourcelyConfigBuilder.RESOURCE_LOCATION_STRATEGY_DEFAULT, config.resourceLocationStrategy);
			Assert.assertEquals(ResourcelyConfigBuilder.RESOURCE_SCALING_STRATEGY_DEFAULT, config.resourceScalingStrategy);
		}

		[Test]
		public function testOverWriteDefaultConfig() : void
		{
			var dpi : Number = 150;
			var file : File = File.applicationDirectory;
			var resourceLocationStrategy : ResourceLocationStrategy = new ResourceLocationStrategy();
			var resourceScalingStrategy : ResourceScalingStrategy = new ResourceScalingStrategy();
			
			var config : ResourcelyConfig = ResourcelyConfigBuilder.getDefault()
			.setDeviceDpi(dpi)
			.setResourceLocationStrategy(resourceLocationStrategy)
			.setResourcePath(file)
			.setResourceScalingStrategy(resourceScalingStrategy)
			.build();

			Assert.assertEquals(dpi, config.deviceDpi);
			Assert.assertEquals(file, config.resourceDirectory);
			Assert.assertEquals(resourceLocationStrategy, config.resourceLocationStrategy);
			Assert.assertEquals(resourceScalingStrategy, config.resourceScalingStrategy);
		}

		[Test]
		public function testEmptyConfig() : void
		{
			var config : ResourcelyConfig = _resourcelyConfigBuilder.build();

			Assert.assertEquals(true, isNaN(config.deviceDpi));
			Assert.assertEquals(null, config.resourceDirectory);
			Assert.assertEquals(null, config.resourceLocationStrategy);
			Assert.assertEquals(null, config.resourceScalingStrategy);
		}
	}
}