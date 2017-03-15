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
	import de.notfound.resourcely.util.FileUtil;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.StageOrientationEvent;
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
		private var _imageDimensionExtractor : ImageFileDimensionExtractor;
		private var _imageDimensionExtractorQueue : Array;
		private var _loader : Loader;
		private var _loaderQueue : Array;
		private var _loaderWorking : Boolean;
		private var _orientation : uint;
		private var _stage : Stage;

		public function Resourcely()
		{
			if (!_allowInstance)
				throw new Error("Singleton class. Can't create new instance. Use getInstance() instead.");

			_densities = new Vector.<Density>();
			_cache = new Dictionary();
			_imageFileMapping = new Dictionary(true);

			_imageDimensionExtractor = new ImageFileDimensionExtractor();
			_imageDimensionExtractor.addEventListener(Event.COMPLETE, handleDimensionExtractionComplete);
			_imageDimensionExtractorQueue = new Array();

			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadDataComplete);
			_loaderQueue = new Array();
			_loaderWorking = false;
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

		public function init(stage : Stage, config : ResourcelyConfig = null) : void
		{
			_config = config != null ? config : ResourcelyConfigBuilder.getDefault();

			initStage(stage);
			initDensities();
		}

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
						return new Path(file, _densities[i]);
					}
				}
			}
			else
			{
				throw new Error("Resource directory " + resDir.nativePath + " doesn't exist.");
			}

			return null;
		}

		public function load(image : Image) : void
		{
			registerReference(image);

			var file : File = _imageFileMapping[image];
			var cacheEntry : CacheEntry = _cache[file.name];

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

		private function initStage(stage : Stage) : void
		{
			_stage = stage;
			if (Stage.supportsOrientationChange)
				_stage.addEventListener(StageOrientationEvent.ORIENTATION_CHANGE, handleStageOrientationChange);
			setOrientation();
		}

		private function handleStageOrientationChange(event : StageOrientationEvent) : void
		{
			setOrientation();
			refresh();
		}

		private function setOrientation() : void
		{
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
			var files : Dictionary = new Dictionary();
			for (var image : Image in _imageFileMapping)
			{
				var oldFile : File = _imageFileMapping[image];

				if (files[oldFile.name] == null)
					files[oldFile.name] = resolveOrientation(oldFile.name).file;
				var newFile : File = files[oldFile.name];

				_imageFileMapping[image] = newFile;

				image.clear();
				load(image);
			}
		}

		private function registerReference(image : Image) : void
		{
			var file : File = _imageFileMapping[image];
			if (_cache[file.name] == null)
				_cache[file.name] = new CacheEntry();

			var cacheEntry : CacheEntry = _cache[file.name];
			cacheEntry.addReference(image);
		}

		private function removeReference(image : Image) : void
		{
			var file : File = _imageFileMapping[image];
			var cacheEntry : CacheEntry = _cache[file.name];
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
			var cacheEntry : CacheEntry = _cache[file.name];

			if (cacheEntry.data != null)
				cacheEntry.data.dispose();

			cacheEntry.data = Bitmap(loaderInfo.content).bitmapData;
			extractDimensions();
		}

		private function handleDimensionExtractionComplete(event : Event) : void
		{
			var file : File = _imageDimensionExtractorQueue.shift();
			var cacheEntry : CacheEntry = _cache[file.name];
			var dimensions : Rectangle = new Rectangle(0, 0, _imageDimensionExtractor.width, _imageDimensionExtractor.height);

			cacheEntry.fileDimensions = dimensions;
			extractDimensions();
		}
	}
}