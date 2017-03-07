package de.notfound.resourcely.file.dimension
{
	import flash.events.ProgressEvent;
	import flash.net.URLStream;
	import flash.events.EventDispatcher;
	import de.notfound.resourcely.file.type.FileType;
	import de.notfound.resourcely.file.type.ImageFileTypeIdentifier;

	import flash.events.Event;
	import flash.net.URLRequest;
	
	/**
	 * Extracts the image dimensions for GIF, PNG and JPG files by choosing a appropriate DimensionExtractionStrategy.
	 * 
	 * @see DimensionExtractionStrategy
	 */
	public class ImageFileDimensionExtractor extends EventDispatcher
	{
		private var _imageTypeIdentifier : ImageFileTypeIdentifier;
		private var _urlRequest : URLRequest;
		private var _extractionStrategy : DimensionExtractionStrategy;
		
		public function ImageFileDimensionExtractor()
		{
			_imageTypeIdentifier = new ImageFileTypeIdentifier();
			_imageTypeIdentifier.addEventListener(Event.COMPLETE, handleFileIdentificationComplete);
		}
		
		/**
		 * Extracts dimension for a given image file.
		 * @param urlRequest A reference to an image file.
		 * @throws flash.events.Event Thows Event.COMPLETE after dimension extraction.
		 */
		public function extractDimension(urlRequest : URLRequest) : void
		{
			_urlRequest = urlRequest;
			_imageTypeIdentifier.identifiy(_urlRequest);
		}
		
		private function handleFileIdentificationComplete(event : Event) : void
		{
			if(_imageTypeIdentifier.type == FileType.TYPE_UNKNOWN)
				throw new Error("Image file type unknown. Couldn't detect image type based on file header information.");
			
			switch (_imageTypeIdentifier.type)
			{
				case FileType.TYPE_GIF:
					_extractionStrategy = new GIFDimensionExtractionStrategy();
					break;
				case FileType.TYPE_JPG:
					_extractionStrategy = new JPGDimensionExtractionStrategy();
					break;
				case FileType.TYPE_PNG:
					_extractionStrategy = new PNGDimensionExtractionStrategy();
					break;
			}

			var urlStream : URLStream = new URLStream();
			urlStream.addEventListener(ProgressEvent.PROGRESS, handleStreamProgress);
			urlStream.addEventListener(Event.COMPLETE, handleStreamComplete);
			urlStream.load(_urlRequest);
		}

		private function handleStreamProgress(event : ProgressEvent) : void
		{
			var urlStream : URLStream = URLStream(event.target);
			
			outer:
			while(urlStream.bytesAvailable > 0)
			{
				if(_extractionStrategy.process(urlStream.readByte()))
				{
					complete(urlStream);
					break outer;
				}
			}
		}

		private function handleStreamComplete(event : Event) : void
		{
			var urlStream : URLStream = URLStream(event.target);
			complete(urlStream); 
		}
		
		private function complete(urlStream : URLStream) : void
		{
			urlStream.close();
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * Provides access to the image width after extraction.
		 */
		public function get width() : int
		{
			return _extractionStrategy.width;
		}
		
		/**
		 * Provides access to the image height after extraction.
		 */
		public function get height() : int
		{
			return _extractionStrategy.height;
		}
	}
}