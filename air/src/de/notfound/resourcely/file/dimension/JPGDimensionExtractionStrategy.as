package de.notfound.resourcely.file.dimension
{
	import flash.utils.ByteArray;

	public class JPGDimensionExtractionStrategy extends DimensionExtractionStrategy
	{
		private static const MODE_MARKER_SEARCH : uint = 0;
		private static const MODE_SKIP_LENGTH_SEARCH : uint = 1;
		private static const MODE_SKIP : uint = 2;
		private static const MODE_PAYLOAD_LENGTH_SEARCH : uint = 3;
		private static const MODE_DIMENSION_EXTRACTION : uint = 4;
		
		private var _bufferSize : uint;
		private var _dataOfInterest : ByteArray;
		private var _marker : int;
		private var _mode : uint;

		public function JPGDimensionExtractionStrategy()
		{
			_dataOfInterest = new ByteArray();
			_mode = MODE_MARKER_SEARCH;
			_bufferSize = 2;
		}

		override public function process(byte : int) : Boolean
		{
			_dataOfInterest.writeByte(byte);
			if (_dataOfInterest.length < _bufferSize)
				return false;

			_dataOfInterest.position = 0;

			if (_mode == MODE_MARKER_SEARCH)
			{
				_marker = _dataOfInterest.readUnsignedShort();
				switch (_marker)
				{
					case 0xffd8: // SOI
					case 0xffd0: // RST0
					case 0xffd1: // RST1
					case 0xffd2: // RST2
					case 0xffd3: // RST3
					case 0xffd4: // RST4
					case 0xffd5: // RST5
					case 0xffd6: // RST6
					case 0xffd7: // RST7
					case 0xffd9: // EOI
						break;
					case 0xffc4: // DHT
					case 0xffdb: // DQT
					case 0xffda: // SOS
					case 0xffe0: // APP0
					case 0xffe1: // APP1
					case 0xffe2: // APP2
					case 0xffe3: // APP3
					case 0xffe4: // APP4
					case 0xffe5: // APP5
					case 0xffe6: // APP6
					case 0xffe7: // APP7
					case 0xffe8: // APP8
					case 0xffe9: // APP9
					case 0xffea: // APPa
					case 0xffeb: // APPb
					case 0xffec: // APPc
					case 0xffed: // APPd
					case 0xffee: // APPe
					case 0xffef: // APPf
					case 0xfffe: // COM
						_mode = MODE_SKIP_LENGTH_SEARCH;
						break;
					case 0xffc0: // SOF0
					case 0xffc2: // SOF2
						_mode = MODE_PAYLOAD_LENGTH_SEARCH;
				}

				_dataOfInterest.clear();
			}
			else if (_mode == MODE_SKIP_LENGTH_SEARCH)
			{
				_bufferSize = _dataOfInterest.readUnsignedShort();
				_mode = MODE_SKIP;
			}
			else if (_mode == MODE_SKIP)
			{
				_bufferSize = 2;
				_mode = MODE_MARKER_SEARCH;
				_dataOfInterest.clear();
			}else if(_mode == MODE_PAYLOAD_LENGTH_SEARCH)
			{
				_bufferSize = _dataOfInterest.readUnsignedShort();
				_mode = MODE_DIMENSION_EXTRACTION;
				_dataOfInterest.clear();
			}
			else if(_mode == MODE_DIMENSION_EXTRACTION)
			{
                _dataOfInterest.readByte();
                _height = _dataOfInterest.readUnsignedShort();
				_width = _dataOfInterest.readUnsignedShort();
				return true;
			}
			return false;
		}
	}
}