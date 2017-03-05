package de.notfound.resourcely.file.dimension
{
	import flash.utils.ByteArray;
	import de.notfound.resourcely.file.type.GIF87aSignature;
	import de.notfound.resourcely.file.type.GIF89aSignature;

	public class GIFDimensionExtractionStrategy extends DimensionExtractionStrategy
	{
		private var _gif89aSignature : GIF89aSignature;
		private var _gif87aSignature : GIF87aSignature;
		private var _matched : Boolean;
		private var _dataOfInterest : ByteArray;

		public function GIFDimensionExtractionStrategy()
		{
			_gif89aSignature = new GIF89aSignature();	
			_gif87aSignature = new GIF87aSignature();
			
			_matched = false;
			_dataOfInterest = new ByteArray();	
		}

		override public function process(byte : int) : Boolean
		{
			if(_matched)
			{
				if(_dataOfInterest.length < 4)
				{
					_dataOfInterest.writeByte(byte);
				}
				else
				{
					_dataOfInterest.position = 0;
					_width = _dataOfInterest.readUnsignedByte() | (_dataOfInterest.readUnsignedByte() << 8);
					_height = _dataOfInterest.readUnsignedByte() | (_dataOfInterest.readUnsignedByte() << 8);
					return true;
				}
			}
			else
			{
				_matched = _gif87aSignature.match(byte) || _gif89aSignature.match(byte);
			}
			return false;
		}
	}
}