package de.notfound.resourcely.config
{
	import de.notfound.resourcely.config.strategy.ResourceLocationStrategy;

	import flash.filesystem.File;

	public class ResourcelyConfig
	{
		public var resourceDirectory : File;
		public var resourceLocationStrategy : ResourceLocationStrategy;
	}
}