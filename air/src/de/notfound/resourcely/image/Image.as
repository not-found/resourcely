package de.notfound.resourcely.image
{
	import de.notfound.resourcely.Resourcely;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	/**
	 * Contains the image data and is used to display it by attaching the class to the
	 * display list. 
	 */
	public class Image extends Sprite
	{
		private var _context : Resourcely;
		private var _fileDimensions : Rectangle;
		
		private var _bitmap : Bitmap;
		private var _bitmapData : BitmapData;
		private var _filler : Sprite;
		
		/**
		 * This class is meant to be created by resourcely only. Refrain from creating an instance on your own.
		 */
		public function Image(context : Resourcely)
		{
			_context = context;
			
			_bitmap = new Bitmap();
			_filler = createFiller();
			
			addChild(_filler);
		}
		
		/**
		 * Resourcely will load the resource linked to an Image instance by default after it has been added to the display list.
		 * You can force-start the loading process by calling this method.
		 */
		public function load() : void
		{
			_context.load(this);
		}
		
		/**
		 * This will remove the image data associated to this instance and will
		 * possibly allow it to be garbage collected.
		 */
		public function clear() : void
		{
			_bitmapData = null;
			_bitmap.bitmapData = null;
			
			if(contains(_bitmap))
				removeChild(_bitmap);
			if(!contains(_filler))
				addChild(_filler);
		}
		
		/**
		 * @private
		 */
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
			filler.graphics.beginFill(0xff0000, 0.0);
			filler.graphics.drawRect(0, 0, 100, 100);
			filler.graphics.endFill();
			
			return filler;
		}
		
		/**
		 * @private
		 */
		public function get bitmapData() : BitmapData
		{
			return _bitmapData;
		}
		
		/**
		 * @private
		 */
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