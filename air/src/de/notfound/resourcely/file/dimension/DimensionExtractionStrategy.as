package de.notfound.resourcely.file.dimension
{
	/**
	 * Abstract class for extracting dimension information out of a binary file.
	 * Implementations of this class should define a logic how to interpret bytes provided to it.
	 */
	public class DimensionExtractionStrategy
	{
		protected var _width : int;
		
		protected var _height : int;
		
		/**
		 * Has to be overwritten by extending class. 
		 * @param byte A byte read from a byte stream.
		 * @return Should return <code>true</code> if extraction completed, <code>false</code> otherwise.
		 */
		public function process(byte : int) : Boolean
		{
			throw new Error("This method has to be implemented.");
		}

		/**
		 * Contains the image width after extraction finished.
		 */
		public function get width() : int
		{
			return _width;
		}

		/**
		 * Contains the image height after extraction finished.
		 */
		public function get height() : int
		{
			return _height;
		}
	}
}