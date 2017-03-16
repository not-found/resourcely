package de.notfound.resourcely
{
	import de.notfound.resourcely.config.ResourcelyConfig;
	import de.notfound.resourcely.config.ResourcelyConfigBuilder;
	import de.notfound.resourcely.file.dimension.ImageFileDimensionExtractor;
	import de.notfound.resourcely.image.Image;
	import de.notfound.resourcely.model.CacheEntry;
	import de.notfound.resourcely.model.Density;
	import de.notfound.resourcely.model.Orientation;
	import de.notfound.resourcely.model.Path;
	import de.notfound.resourcely.util.DeviceUtil;
	import de.notfound.resourcely.util.FileUtil;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
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
		private var _paths : Dictionary;
		private var _imageFileMapping : Dictionary;
		private var _imageDimensionExtractor : ImageFileDimensionExtractor;
		private var _imageDimensionExtractorQueue : Array;
		private var _loader : Loader;
		private var _loaderQueue : Array;
		private var _loaderWorking : Boolean;
		private var _orientation : int;
		private var _stage : Stage;
		
		/**
		 * Used to load image resources. Resourcely is meant to be used as signleton, 
		 * so you can't create instances from it and should use getInstance() instead.
		 */
		public function Resourcely()
		{
			if (!_allowInstance)
				throw new Error("Singleton class. Can't create new instance. Use getInstance() instead.");

			_densities = new Vector.<Density>();
			_cache = new Dictionary();
			_paths = new Dictionary();
			_imageFileMapping = new Dictionary(true);

			_imageDimensionExtractor = new ImageFileDimensionExtractor();
			_imageDimensionExtractor.addEventListener(Event.COMPLETE, handleDimensionExtractionComplete);
			_imageDimensionExtractorQueue = new Array();
			_orientation = Orientation.PORTRAIT;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadDataComplete);
			_loaderQueue = new Array();
			_loaderWorking = false;
		}
		
		/**
		 * Returns a resourcely instance.
		 */
		public static function getInstance() : Resourcely
		{
			if (_instance == null)
			{
				_allowInstance = true;
				_instance = new Resourcely();
			}

			return _instance;
		}
		
		/**
		 * Use this to initialize resourcely. This is needed to it'll be able to detect device orientation changes.
		 * @param stage The stage object belonging to the display list.
		 * @param config The config to control resourcelys behavior. It'll use a standard config by default.
		 */
		public function init(stage : Stage, config : ResourcelyConfig = null) : void
		{
			_config = config != null ? config : ResourcelyConfigBuilder.getDefault().build();

			initStage(stage);
			initDensities();
		}
		
		/**
		 * Locates and returns an image matching the fileName supplied depending on the devices dpi and orientation.
		 * @param fileName The file name of the image file including extension. For example: <code>img.jpg</code>
		 * @return An Image instance which is linked to the image file identified by the fileName parameter.
		 */
		public function getImage(fileName : String) : Image
		{
			var path : Path = resolveOrientation(fileName);
			var image : Image = new Image(this);

			image.scaleX = image.scaleY = _config.resourceScalingStrategy.getScale(_config.deviceDpi, path.density);
			image.addEventListener(Event.ADDED_TO_STAGE, handleImageAddedToStage, false, 0, true);
			image.addEventListener(Event.REMOVED_FROM_STAGE, handleImageRemovedFromStage, false, 0, true);

			_imageFileMapping[image] = path.file;
			registerReference(image);

			return image;
		}

		private function resolveOrientation(fileName : String) : Path
		{
			var resDir : File = _config.resourceDirectory;
			var path : Path = resolvePath(fileName, _orientation);
			if (path == null)
				path = resolvePath(fileName, _orientation * -1);
			if (path == null)
				throw new Error("Couldn't find " + fileName + " in " + resDir.nativePath);

			return path;
		}

		private function resolvePath(fileName : String, orientation : int) : Path
		{
			if(_paths[fileName + orientation] != null)
				return _paths[fileName + orientation];
				
			var resDir : File = _config.resourceDirectory;
			var postFix : String = orientation == Orientation.LANDSCAPE ? Orientation.POSTIFX_LANDSCAPE : Orientation.POSTIFX_PORTRAIT;

			if (resDir.exists)
			{
				for (var i : int = 0; i < _densities.length; i++)
				{
					var imageDir : File = resDir.resolvePath(_densities[i].qualifier + postFix);
					if (imageDir.exists)
					{
						var file : File = imageDir.resolvePath(fileName);

						if (file.exists)
						{
							if (FileUtil.isImageFile(file.extension) == false)
								throw new Error("Couldn't load " + file.nativePath + " because it isn't an image file.");
						}
						
						var path : Path = new Path(file, _densities[i]);
						_paths[fileName + orientation] = path;
						return path;
					}
				}
			}
			else
			{
				throw new Error("Resource directory " + resDir.nativePath + " doesn't exist.");
			}

			return null;
		}
		
		/**
		 * Calling this method will cause resourcely to load the image file linked to the image instance.
		 * @param image The image which should its image data get loaded.
		 */		
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
				_imageDimensionExtractor.extractDimension(new URLRequest(file.url));
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
				_loader.load(new URLRequest(file.url));
			}
		}

		private function initStage(stage : Stage) : void
		{
			_stage = stage;
			_stage.addEventListener(Event.RESIZE, handleStageOrientationChange)
			setOrientation();
		}

		private function handleStageOrientationChange(event : Event) : void
		{
			setOrientation();
			refresh();
		}

		private function setOrientation() : void
		{
			if(DeviceUtil.isDesktop())
				_orientation = Orientation.PORTRAIT;
			else
				_orientation = _stage.fullScreenWidth > _stage.fullScreenHeight ? Orientation.LANDSCAPE : Orientation.PORTRAIT;
				
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

		private function refresh() : void
		{
			for (var image : Image in _imageFileMapping)
			{
				var oldFile : File = _imageFileMapping[image];
				var newFile : File = resolveOrientation(oldFile.name).file;
				var cacheEntry : CacheEntry = _cache[oldFile];
				
				_imageFileMapping[image] = newFile;
				
				cacheEntry.clear();
				load(image);
			}
		}

		private function registerReference(image : Image) : void
		{
			var file : File = _imageFileMapping[image];
			if (_cache[file] == null)
				_cache[file] = new CacheEntry();

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
	}
}