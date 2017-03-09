package de.notfound.resourcely
{
	import de.notfound.resourcely.util.FileUtil;
	import de.notfound.resourcely.image.Image;
	import de.notfound.resourcely.config.ResourcelyConfig;
	import de.notfound.resourcely.config.ResourcelyConfigBuilder;
	import de.notfound.resourcely.model.Density;

	import flash.filesystem.File;
	import flash.utils.Dictionary;

	public class Resourcely
	{
		private static var _instance : Resourcely;
		private static var _allowInstance : Boolean = false;
		
		private var _config : ResourcelyConfig;
		private var _densities : Vector.<Density>;
		private var _images : Dictionary;

		public function Resourcely()
		{
			if (!_allowInstance)
				throw new Error("Singleton class. Can't create new instance. Use getInstance() instead.");

			_images = new Dictionary();
			_densities = new Vector.<Density>();
		}

		public static function getInstance() : Resourcely
		{
			if (_instance == null)
			{
				_allowInstance = true;
				_instance = new Resourcely();
			}

			return _instance;
		}

		public function init(config : ResourcelyConfig = null) : void
		{
			_config = config != null ? config : ResourcelyConfigBuilder.getDefault();

			initDensities();
			initImages();
		}

		private function initDensities() : void
		{
			_densities.push(new Density(Density.LDPI, Density.LDPI_QUALIFIER));
			_densities.push(new Density(Density.MDPI, Density.MDPI_QUALIFIER));
			_densities.push(new Density(Density.HDPI, Density.HDPI_QUALIFIER));
			_densities.push(new Density(Density.XHDPI, Density.XHDPI_QUALIFIER));
			_densities.push(new Density(Density.XXHDPI, Density.XXHDPI_QUALIFIER));
			_densities.push(new Density(Density.XXXHDPI, Density.XXXHDPI_QUALIFIER));

			_densities = _config.resourceLocationStrategy.getOrder(_densities);
		}

		private function initImages() : void
		{
			var resDir : File = _config.resourceDirectory;
			if (resDir.exists)
			{
				for (var i : int = 0; i < _densities.length; i++)
				{
					var imageDir : File = resDir.resolvePath(_densities[i].qualifier);
					if (imageDir.exists)
					{
						var imageDirContent : Array = imageDir.getDirectoryListing();
						for each (var imageDirFile : File in imageDirContent)
						{
							if(FileUtil.isImageFile(imageDirFile.extension) && _images[imageDirFile.name] == null)
							{
								_images[imageDirFile.name] = new Image(this, imageDirFile);
							}
						}
					}
				}
			}
			else
			{
				throw new Error("Resource directory " + resDir.nativePath + " doesn't exist.");
			}
		}
	}
}