package de.notfound.resourcely.file.type
{
	import flash.utils.ByteArray;
	
	public class FileTypeSignature
	{
		private var _signature : ByteArray;
		private var _fileType : int;
		
		/**
		 * Matches a byte stream against a given sequence of bytes.
		 * @param signature The byte sequence used for comparing bytes.
		 * @param fileType If the signature matches the given bytes, the underlying file is deemed to be of this type.
		 */
		public function FileTypeSignature(signature : ByteArray, fileType : int)
		{
			_fileType = fileType;
			_signature = signature;
			_signature.position = 0;
		}
		
		/**
		 * Matches a byte against the signature.
		 * @param byte The byte to compare.
		 * @return Returns <code>true</code> if a match was found, <code>false</code> otherwise.
		 */
		public function match(byte : int) : Boolean
		{
			var signatureByte : int = _signature.readByte();
			if(signatureByte == byte)
			{
				var matched : Boolean =_signature.bytesAvailable == 0;
				if(matched)
					_signature.position = 0;
				return matched;
			}else
			{
				_signature.position = 0;
				return false;
			}
		}
		
		/**
		 * Provides access to the FileType linked to this signature.
		 */
		public function get fileType() : int
		{
			return _fileType;
		}
	}
}