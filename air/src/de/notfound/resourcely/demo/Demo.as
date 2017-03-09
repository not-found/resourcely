package de.notfound.resourcely.demo
{
	import flash.utils.getTimer;
	import de.notfound.resourcely.Resourcely;

	import flash.display.Sprite;

	public class Demo extends Sprite
	{
		public function Demo()
		{
			var time : Number = getTimer();
			Resourcely.getInstance().init();
			trace("t: " + (getTimer() - time));
		}
	}
}