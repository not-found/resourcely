package de.notfound.resourcely
{
	import flash.display.BitmapData;
	import de.notfound.resourcely.config.ResourcelyConfig;
	import de.notfound.resourcely.config.ResourcelyConfigBuilder;
	import de.notfound.resourcely.file.dimension.ImageFileDimensionExtractor;
	import de.notfound.resourcely.image.Image;
	import de.notfound.resourcely.model.CacheEntry;
	import de.notfound.resourcely.model.Density;
	import de.notfound.resourcely.util.FileUtil;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.utils.Dictionary;

	public class Resourcely
	{
		private static var _instance : Resourcely;
		private static var _allowInstance : Boolean = false;
		
		private var _config : ResourcelyConfig;
		private var _densities : Vector.<Density>;
		private var _cache : Dictionary;
		private var _imageFileMapping : Dictionary;
		private var _files : Dictionary;
		private var _imageDimensionExtractor : ImageFileDimensionExtractor;
		private var _imageDimensionExtractorQueue : Array;
		private var _loader : Loader;
		private var _loaderQueue : Array;
		private var _loaderWorking : Boolean;

		public function Resourcely()
		{
			if (!_allowInstance)
				throw new Error("Singleton class. Can't create new instance. Use getInstance() instead.");

			_densities = new Vector.<Density>();
			_cache = new Dictionary();
			_imageFileMapping = new Dictionary(true);
			_files = new Dictionary();

			_imageDimensionExtractor = new ImageFileDimensionExtractor();
			_imageDimensionExtractor.addEventListener(Event.COMPLETE, handleDimensionExtractionComplete);
			_imageDimensionExtractorQueue = new Array();

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadDataComplete);
			_loaderQueue = new Array();
			_loaderWorking = false;
		}

		private function handleLoadDataComplete(event : Event) : void
		{
			var loaderInfo : LoaderInfo = LoaderInfo(event.target);

			var file : File = _loaderQueue.shift();
			var cacheEntry : CacheEntry = _cache[file];
			
			cacheEntry.data = Bitmap(loaderInfo.content).bitmapData;
			extractDimensions();
		}

		private function handleDimensionExtractionComplete(event : Event) : void
		{
			var file : File = _imageDimensionExtractorQueue.shift();
			var cacheEntry : CacheEntry = _cache[file];
			var dimensions : Rectangle = new Rectangle(0, 0, _imageDimensionExtractor.width, _imageDimensionExtractor.height);

			cacheEntry.fileDimensions = dimensions;
			extractDimensions();
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
		}

		public function getImage(fileName : String) : Image
		{
			var resDir : File = _config.resourceDirectory;
			if (resDir.exists)
			{
				for (var i : int = 0; i < _densities.length; i++)
				{
					var imageDir : File = resDir.resolvePath(_densities[i].qualifier);
					if (imageDir.exists)
					{
						var file : File = _files[fileName] != null ? _files[fileName] : imageDir.resolvePath(fileName);

						if (file.exists)
						{
							if (FileUtil.isImageFile(file.extension) == false)
								throw new Error("Couldn't load " + file.nativePath + " because it isn't an image file.");

							var image : Image = new Image(this, _densities[i]);
							image.addEventListener(Event.ADDED_TO_STAGE, handleImageAddedToStage, false, 0, true);
							image.addEventListener(Event.REMOVED_FROM_STAGE, handleImageRemovedFromStage, false, 0, true);

							_imageFileMapping[image] = file;
							_files[fileName] = file;

							registerReference(image);

							return image;
						}
					}
				}
				throw new Error("Couldn't find " + fileName + " in " + resDir.nativePath);
			}
			else
			{
				throw new Error("Resource directory " + resDir.nativePath + " doesn't exist.");
			}
		}

		public function load(image : Image) : void
		{
			registerReference(image);

			var file : File = _imageFileMapping[image];
			var cacheEntry : CacheEntry = _cache[file];

			if (cacheEntry.fileDimensions == null)
			{
				addToQueue(file, _imageDimensionExtractorQueue);
				addToQueue(file, _loaderQueue);
				extractDimensions();
			}
			else if (cacheEntry.data == null)
			{
				addToQueue(file, _loaderQueue);
				loadData();
			}
			else
			{
				image.bitmapData = cacheEntry.data;
			}
		}

		private function addToQueue(object : Object, queue : Array) : void
		{
			var containsObject : Boolean = false;
			for each (var element : Object in queue)
			{
				containsObject = element == object;
				if (containsObject)
					break;
			}

			if (!containsObject)
				queue.push(object);
		}

		private function extractDimensions() : void
		{
			if (_imageDimensionExtractorQueue.length > 0 && !_imageDimensionExtractor.working)
			{
				var file : File = _imageDimensionExtractorQueue[0];
				_imageDimensionExtractor.extractDimension(new URLRequest(file.nativePath));
			}
			else if (_imageDimensionExtractorQueue.length == 0)
			{
				loadData();
			}
		}

		private function loadData() : void
		{
			if (_loaderQueue.length > 0 && !_loaderWorking)
			{
				var file : File = _loaderQueue[0];
				_loader.load(new URLRequest(file.nativePath));
			}
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

		private function registerReference(image : Image) : void
		{
			var file : File = _imageFileMapping[image];
			if (_cache[file] == null)
				_cache[file] = new CacheEntry(file);

			var cacheEntry : CacheEntry = _cache[file];
			cacheEntry.addReference(image);
		}

		private function removeReference(image : Image) : void
		{
			var file : File = _imageFileMapping[image];
			var cacheEntry : CacheEntry = _cache[file];
			cacheEntry.removeReference(image);
		}

		private function handleImageAddedToStage(event : Event) : void
		{
			var image : Image = Image(event.target);
			load(image);
		}

		private function handleImageRemovedFromStage(event : Event) : void
		{
			var image : Image = Image(event.target);

			removeReference(image);
			image.clear();
		}
	}
}