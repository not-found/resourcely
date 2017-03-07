package de.notfound.resourcely.dimension
{
	import de.notfound.resourcely.file.dimension.ImageFileDimensionExtractor;

	import org.flexunit.Assert;
	import org.flexunit.async.Async;

	import flash.events.Event;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;

	public class ImageFileDimensionExtractorTest
	{
		private static const PATH_TEST_GIF : String = "test/img.gif";
		private static const PATH_TEST_JPG : String = "test/img.jpg";
		private static const PATH_TEST_PNG : String = "test/img.png";
		private static const PATH_TEST_TXT : String = "test/img.txt";
		
		private static const GIF_DIMENSION : Rectangle = new Rectangle(0, 0, 36, 29);
		private static const JPG_DIMENSION : Rectangle = new Rectangle(0, 0, 19, 78);
		private static const PNG_DIMENSION : Rectangle = new Rectangle(0, 0, 55, 29);
		private static const UNKNOWN_DIMENSION : Rectangle = new Rectangle(0, 0, 0, 0);
		
		private static const EVENT_TIMEOUT : int = 1000;
		
		private var _imageFileDimensionExtractor : ImageFileDimensionExtractor;

		[Test(async)]
		public function testGIFFile() : void
		{
			var eventHandler : Function = function(event : Event, ... args) : void
			{
				asserDimensions(GIF_DIMENSION, _imageFileDimensionExtractor);
			};
			Async.handleEvent(this, _imageFileDimensionExtractor, Event.COMPLETE, eventHandler, EVENT_TIMEOUT);
			_imageFileDimensionExtractor.extractDimension(new URLRequest(PATH_TEST_GIF));
		}

		[Test(async)]
		public function testJPGFile() : void
		{
			var eventHandler : Function = function(event : Event, ... args) : void
			{
				asserDimensions(JPG_DIMENSION, _imageFileDimensionExtractor);
			};
			Async.handleEvent(this, _imageFileDimensionExtractor, Event.COMPLETE, eventHandler, EVENT_TIMEOUT);
			_imageFileDimensionExtractor.extractDimension(new URLRequest(PATH_TEST_JPG));
		}

		[Test(async)]
		public function testPNGFile() : void
		{
			var eventHandler : Function = function(event : Event, ... args) : void
			{
				asserDimensions(PNG_DIMENSION, _imageFileDimensionExtractor);
			};
			Async.handleEvent(this, _imageFileDimensionExtractor, Event.COMPLETE, eventHandler, EVENT_TIMEOUT);
			_imageFileDimensionExtractor.extractDimension(new URLRequest(PATH_TEST_PNG));
		}

		[Test(async)]
		public function testUnknownFile() : void
		{
			var eventHandler : Function = function(event : Event, ... args) : void
			{
				asserDimensions(UNKNOWN_DIMENSION, _imageFileDimensionExtractor);
			};
			Async.handleEvent(this, _imageFileDimensionExtractor, Event.COMPLETE, eventHandler, EVENT_TIMEOUT);
			_imageFileDimensionExtractor.extractDimension(new URLRequest(PATH_TEST_TXT));
		}

		[Before(async)]
		public function setup() : void
		{
			_imageFileDimensionExtractor = new ImageFileDimensionExtractor();
		}
		
		private function asserDimensions(dimensions : Rectangle, imageFileDimensionExtractor : ImageFileDimensionExtractor) : void
		{
			Assert.assertEquals(dimensions.width, imageFileDimensionExtractor.width);
			Assert.assertEquals(dimensions.height, imageFileDimensionExtractor.height);
		}
	}
}