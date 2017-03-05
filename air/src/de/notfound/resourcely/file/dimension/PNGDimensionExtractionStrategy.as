package de.notfound.resourcely.file.dimension
{
	import de.notfound.resourcely.file.type.PNGSignature;

	import flash.utils.ByteArray;

	public class PNGDimensionExtractionStrategy extends DimensionExtractionStrategy
	{
		private var _pngSignature : PNGSignature;
		private var _matched : Boolean;
		private var _dataOfInterest : ByteArray;

		public function PNGDimensionExtractionStrategy()
		{
			_pngSignature = new PNGSignature();	
			
			_matched = false;
			_dataOfInterest = new ByteArray();	
		}

		override public function process(byte : int) : Boolean
		{
			if(_matched)
			{
				if(_dataOfInterest.length < 16)
				{
					_dataOfInterest.writeByte(byte);
				}
				else
				{
					_dataOfInterest.position = 8;
					_width = (_dataOfInterest.readUnsignedByte() << 24) | (_dataOfInterest.readUnsignedByte() << 16) | (_dataOfInterest.readUnsignedByte() << 8) | _dataOfInterest.readUnsignedByte();
					_height = (_dataOfInterest.readUnsignedByte() << 24) | (_dataOfInterest.readUnsignedByte() << 16) | (_dataOfInterest.readUnsignedByte() << 8) | _dataOfInterest.readUnsignedByte();
					return true;
				}
			}
			else
			{
				_matched = _pngSignature.match(byte);
			}
			return false;
		}
	}
}