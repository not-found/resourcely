package de.notfound.resourcely.model
{
	import de.notfound.resourcely.image.Image;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;

	/**
	 * This class is meant for internal use only and contains cached data.
	 * @private
	 */
	public class CacheEntry
	{
		private var _fileDimensions : Rectangle;
		private var _data : BitmapData;
		private var _estimatedSize : Number;
		private var _refs : Dictionary;
		
		public static var num : uint = 0;
		
		public function CacheEntry()
		{
			_refs = new Dictionary(true);
			
			trace(++num);
		}
		
		public function addReference(image : Image) : void
		{
			_refs[image] = true;
		}

		public function removeReference(image : Image) : void
		{
			_refs[image] = null;
			delete _refs[image];
		}
		
		//Removes the bitmap data it contains and frees the memory used by the bitmap data
		public function clear() : void
		{
			unlink();
			_data.dispose();
			_data = null;
		}
		
		//Removes all references linked to this entry
		public function unlink() : void
		{
			for (var image : Image in _refs)
			{
				image.clear();
				removeReference(image);
			}
		}
		
		public function get data() : BitmapData
		{
			return _data;
		}

		public function set data(bitmapData : BitmapData) : void
		{
			_data = bitmapData;

			for (var ref : Image in _refs)
			{
				ref.bitmapData = bitmapData;
			}
		}

		public function get fileDimensions() : Rectangle
		{
			return _fileDimensions;
		}

		public function set fileDimensions(fileDimensions : Rectangle) : void
		{
			_fileDimensions = fileDimensions;
			_estimatedSize = fileDimensions.width * fileDimensions.height * 4;

			for (var ref : Image in _refs)
			{
				ref.fileDimensions = fileDimensions;
			}
		}

		public function get estimatedSize() : Number
		{
			return _estimatedSize;
		}
	}
}