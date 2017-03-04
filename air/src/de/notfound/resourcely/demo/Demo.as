package de.notfound.resourcely.demo
{
	import flash.net.URLRequest;
	import de.notfound.resourcely.file.ImageFileTypeIdentifier;

	import flash.display.Sprite;
	import flash.events.Event;

	public class Demo extends Sprite
	{
		public function Demo()
		{
			var imageFileTypeIdentifier : ImageFileTypeIdentifier = new ImageFileTypeIdentifier();
			imageFileTypeIdentifier.addEventListener(Event.COMPLETE, handleComplete);
			
			imageFileTypeIdentifier.identifiy(new URLRequest("img.png"));
		}

		private function handleComplete(event : Event) : void
		{
			var target : ImageFileTypeIdentifier = ImageFileTypeIdentifier(event.target);
			trace(target.type);
		}
	}
}