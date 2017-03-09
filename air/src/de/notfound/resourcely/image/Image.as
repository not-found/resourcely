package de.notfound.resourcely.image
{
	import de.notfound.resourcely.Resourcely;

	import flash.display.Sprite;
	import flash.filesystem.File;

	public class Image extends Sprite
	{
		private var _context : Resourcely;
		private var _path : File;

		public function Image(context : Resourcely, path : File)
		{
			_path = path;
			_context = context;
		}
	}
}