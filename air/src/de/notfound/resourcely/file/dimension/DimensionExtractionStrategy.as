package de.notfound.resourcely.file.dimension
{
	
	public class DimensionExtractionStrategy
	{
		protected var _width : int;
		protected var _height : int;
		
		public function process(byte : int) : Boolean
		{
			throw new Error("This method has to be implemented.");
		}

		public function get width() : int
		{
			return _width;
		}

		public function get height() : int
		{
			return _height;
		}
	}
}