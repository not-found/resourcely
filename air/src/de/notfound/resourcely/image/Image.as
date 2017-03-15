package de.notfound.resourcely.image
{
	import de.notfound.resourcely.Resourcely;
	import de.notfound.resourcely.model.Density;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public class Image extends Sprite
	{
		private var _context : Resourcely;
		private var _fileDimensions : Rectangle;
		
		private var _bitmap : Bitmap;
		private var _bitmapData : BitmapData;
		private var _filler : Sprite;

		public function Image(context : Resourcely)
		{
			_context = context;
			
			_bitmap = new Bitmap();
			_filler = createFiller();
			
			addChild(_filler);
		}
		
		public function load() : void
		{
			_context.load(this);
		}
		
		public function clear() : void
		{
			_bitmapData = null;
			_bitmap.bitmapData = null;
			
			if(contains(_bitmap))
				removeChild(_bitmap);
			if(!contains(_filler))
				addChild(_filler);
		}

		public function set fileDimensions(dimensions : Rectangle) : void
		{
			_fileDimensions = dimensions;
			_filler.width = _fileDimensions.width;
			_filler.height = _fileDimensions.height;
			
			dispatchEvent(new Event(Event.RESIZE));
		}

		private function createFiller() : Sprite
		{
			var filler : Sprite = new Sprite();
			filler.graphics.beginFill(0xff0000, 1.0);
			filler.graphics.drawRect(0, 0, 100, 100);
			filler.graphics.endFill();
			
			return filler;
		}

		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}

		public function set bitmapData(bitmapData : BitmapData) : void
		{
			_bitmapData = bitmapData;
			_bitmap.bitmapData = _bitmapData;
			if(contains(_filler))
				removeChild(_filler);
			if(!contains(_bitmap))
				addChild(_bitmap);
				
			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}