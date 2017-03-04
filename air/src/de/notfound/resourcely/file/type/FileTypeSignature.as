package de.notfound.resourcely.file.type
{
	import flash.utils.ByteArray;
	
	public class FileTypeSignature
	{
		private var _signature : ByteArray;
		private var _fileType : int;

		public function FileTypeSignature(signature : ByteArray, fileType : int)
		{
			_fileType = fileType;
			_signature = signature;
			_signature.position = 0;
		}
		
		public function match(byte : int) : Boolean
		{
			var signatureByte : int = _signature.readByte();
			if(signatureByte == byte)
			{
				return _signature.bytesAvailable == 0;
			}else
			{
				_signature.position = 0;
				return false;
			}
		}

		public function get fileType() : int
		{
			return _fileType;
		}
	}
}