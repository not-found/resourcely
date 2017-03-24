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
		
		public function CacheEntry()
		{
			_refs = new Dictionary(true);
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
			for (var key : Object in _refs)
			{
				var image : Image = Image(key);
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
			
			for (var key : Object in _refs)
			{
				var ref : Image = Image(key);
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

			for (var key : Object in _refs)
			{
				var ref : Image = Image(key);
				ref.fileDimensions = fileDimensions;
			}
		}

		public function get estimatedSize() : Number
		{
			return _estimatedSize;
		}
	}
}