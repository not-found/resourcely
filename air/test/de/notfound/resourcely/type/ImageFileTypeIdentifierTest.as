package de.notfound.resourcely.type
{
	import de.notfound.resourcely.file.type.FileType;
	import de.notfound.resourcely.file.type.ImageFileTypeIdentifier;
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class ImageFileTypeIdentifierTest
	{
		private static const PATH_TEST_GIF : String = "test/img.gif";
		private static const PATH_TEST_JPG : String = "test/img.jpg";
		private static const PATH_TEST_PNG : String = "test/img.png";
		private static const PATH_TEST_TXT : String = "test/img.txt";
		
		private static const EVENT_TIMEOUT : int = 1000;
		
		private var _imageFileTypeIdentifier : ImageFileTypeIdentifier;

		[Test(async)]
		public function testGIFFile() : void
		{
			var eventHandler : Function = function(event : Event, ... args) : void
			{
				Assert.assertEquals(FileType.TYPE_GIF, _imageFileTypeIdentifier.type);
			};
			Async.handleEvent(this, _imageFileTypeIdentifier, Event.COMPLETE, eventHandler, EVENT_TIMEOUT);
			_imageFileTypeIdentifier.identifiy(new URLRequest(PATH_TEST_GIF));
		}

		[Test(async)]
		public function testJPGFile() : void
		{
			var eventHandler : Function = function(event : Event, ... args) : void
			{
				Assert.assertEquals(FileType.TYPE_JPG, _imageFileTypeIdentifier.type);
			};
			Async.handleEvent(this, _imageFileTypeIdentifier, Event.COMPLETE, eventHandler, EVENT_TIMEOUT);
			_imageFileTypeIdentifier.identifiy(new URLRequest(PATH_TEST_JPG));
		}

		[Test(async)]
		public function testPNGFile() : void
		{
			var eventHandler : Function = function(event : Event, ... args) : void
			{
				Assert.assertEquals(FileType.TYPE_PNG, _imageFileTypeIdentifier.type);
			};
			Async.handleEvent(this, _imageFileTypeIdentifier, Event.COMPLETE, eventHandler, EVENT_TIMEOUT);
			_imageFileTypeIdentifier.identifiy(new URLRequest(PATH_TEST_PNG));
		}

		[Test(async)]
		public function testUnknownFile() : void
		{
			var eventHandler : Function = function(event : Event, ... args) : void
			{
				Assert.assertEquals(FileType.TYPE_UNKNOWN, _imageFileTypeIdentifier.type);
			};
			Async.handleEvent(this, _imageFileTypeIdentifier, Event.COMPLETE, eventHandler, EVENT_TIMEOUT);
			_imageFileTypeIdentifier.identifiy(new URLRequest(PATH_TEST_TXT));
		}

		[Before(async)]
		public function setup() : void
		{
			_imageFileTypeIdentifier = new ImageFileTypeIdentifier();
		}
	}
}