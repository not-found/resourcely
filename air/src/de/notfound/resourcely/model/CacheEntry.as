package de.notfound.resourcely.model
{
	import de.notfound.resourcely.image.Image;

	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**
	 * This class is meant for internal use only and contains cached data.
	 * @private
	 */
	public class CacheEntry
	{
		private var _fileDimensions : Rectangle;
		private var _data : BitmapData;
		private var _estimatedSize : Number;
		private var _timestamp : int;
		private var _refs : Dictionary;
		
		public static var num : uint = 0;
		
		public function CacheEntry()
		{
			_timestamp = getTimer();
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
		
		//Removes all references linked to this entry, the bitmap data it contains and frees the memory used by the bitmap data
		public function clear() : void
		{
			_fileDimensions = null;
			for (var image : Image in _refs)
			{
				image.clear();
				removeReference(image);
			}
			_data.dispose();
			_data = null;
		}

		public function get data() : BitmapData
		{
			_timestamp = getTimer();
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

		public function get timestamp() : int
		{
			return _timestamp;
		}

		public function get numRefs() : uint
		{
			var numRefs : uint = 0;
			for (var key : Image in _refs)
			{
				numRefs++;
			}
			return numRefs;
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
	}
}