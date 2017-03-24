package de.notfound.resourcely.demo
{
	import de.notfound.resourcely.config.ResourcelyConfigBuilder;
	import de.notfound.resourcely.config.ResourcelyConfig;
	import flash.text.TextFormat;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextField;
	import flash.net.URLRequest;
	import de.notfound.resourcely.Resourcely;
	import de.notfound.resourcely.image.Image;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class Demo extends Sprite
	{
		private var _time : int;
		private var _queue : Vector.<int>;
		private var _resourcely : Resourcely;
		private var _extension : String;
		private var _img : Image;
		private var _fileName : String;
		private var _loader : Loader;
		private var _textField : TextField;
		private var _format : TextFormat;

		public function Demo()
		{
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		private function handleEnterFrame(event : Event) : void
		{
			removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			
			init();
		}

		private function init() : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_resourcely = Resourcely.getInstance();
			var config : ResourcelyConfig = ResourcelyConfigBuilder.getDefault().setDeviceDpi(240).build();
			_resourcely.init(stage, config);
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
			
			_format  = new TextFormat();
			_format.color = 0x000000;
			_format.size = 40;
			
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.multiline = true;
			_textField.defaultTextFormat = _format;
			addChild(_textField);
			
			_queue = new Vector.<int>();
			for (var i : int = 1; i < 21; i++) {
				_queue.push(i);
			}
//			for (var i : int = 1; i < 21; i++) {
//				_queue.push(i);
//			}
			
			test();
//			test2();
		}

		private function test2() : void
		{
			var config : ResourcelyConfig = ResourcelyConfigBuilder.getDefault().setDeviceDpi(240).build();
			
			Resourcely.getInstance().init(stage, config);
			var image : Image = Resourcely.getInstance().getImage("test.jpg");
			addChild(image);
		}

		private function test() : void
		{
			_extension = ".jpg";
//			Resourcely.getInstance().init(stage);

			next();
		}

		private function next() : void
		{
//			loadNative();
			loadResourcely();
		}

		private function loadResourcely() : void
		{
			if(_queue.length <= 0)
				return;
			
			var index : int = _queue.shift();
			_fileName = index + _extension;
			
			_time = getTimer();
			var img : Image = Resourcely.getInstance().getImage(_fileName);
			img.addEventListener(Event.COMPLETE, handleLoadComplete);
			addChild(img);
		}
		
		private function loadNative() : void
		{
			if(_queue.length <= 0)
				return;

			var index : int = _queue.shift();
			_fileName = "res/ldpi/" + index + _extension;
			var urlRequest : URLRequest = new URLRequest(_fileName);
			
			_time = getTimer();
			_loader.load(urlRequest);
		}
		
		private function handleLoadComplete(event : Event) : void
		{
			_textField.text += ("\nfileName: "  + _fileName + " - " + (getTimer() - _time));
			next();
		}
	}
}