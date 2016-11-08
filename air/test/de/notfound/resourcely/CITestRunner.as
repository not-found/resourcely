package de.notfound.resourcely
{
	import org.flexunit.internals.TraceListener;
	import org.flexunit.listeners.AirCIListener;
	import org.flexunit.runner.FlexUnitCore;
	import org.flexunit.runner.Request;

	import flash.display.Sprite;

	public class CITestRunner extends Sprite
	{
		public function CITestRunner() : void
		{
			var core : FlexUnitCore = new FlexUnitCore();
			core.addListener(new AirCIListener());
			core.addListener(new TraceListener());
			
			var request : Request = Request.classes(TestSuite);
			core.run(request);
		}
	}
}