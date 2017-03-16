package de.notfound.resourcely.demo
{
	import flash.display.StageScaleMode;
	import flash.display.StageAlign;
	import de.notfound.resourcely.Resourcely;
	import de.notfound.resourcely.image.Image;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;

	public class Demo extends Sprite
	{
		private var _time : int;

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
			
			test1();
		}

		private function test1() : void
		{
			Resourcely.getInstance().init(stage);

			_time = getTimer();
			var img1 : Image = Resourcely.getInstance().getImage("img.jpg");
			img1.addEventListener(Event.COMPLETE, handleLoadComplete);
			addChild(img1);
		}

		private function handleLoadComplete(event : Event) : void
		{
			trace(getTimer() - _time);
		}
	}
}