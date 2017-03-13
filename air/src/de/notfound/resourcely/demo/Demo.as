package de.notfound.resourcely.demo
{
	import flash.net.URLRequest;
	import de.notfound.resourcely.Resourcely;
	import de.notfound.resourcely.image.Image;

	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class Demo extends Sprite
	{
		private var _time : int;

		public function Demo()
		{
			test1();
		}

		private function test2() : void
		{
			_time = getTimer();
			var loader : Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleLoadComplete);
			loader.load(new URLRequest("/res/ldpi/img.png"));
		}

		private function test1() : void
		{
			Resourcely.getInstance().init();

			_time = getTimer();
			var img1 : Image = Resourcely.getInstance().getImage("img.png");
			img1.addEventListener(Event.COMPLETE, handleLoadComplete);
			addChild(img1);
		}

		private function handleLoadComplete(event : Event) : void
		{
			trace(getTimer() - _time);
		}
	}
}