package de.notfound.resourcely.demo
{
	import flash.utils.getTimer;
	import de.notfound.resourcely.file.dimension.ImageFileDimensionExtractor;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;

	public class Demo extends Sprite
	{
		private var _time : int;

		public function Demo()
		{
			var imageDimensionExtractor : ImageFileDimensionExtractor = new ImageFileDimensionExtractor();
			imageDimensionExtractor.addEventListener(Event.COMPLETE, handleComplete);
			_time = getTimer();
			imageDimensionExtractor.extractDimension(new URLRequest("img.jpg"));
		}

		private function handleComplete(event : Event) : void
		{
			var target : ImageFileDimensionExtractor = ImageFileDimensionExtractor(event.target);
			trace(getTimer() - _time);
			trace(target.width);
			trace(target.height);
		}
	}
}