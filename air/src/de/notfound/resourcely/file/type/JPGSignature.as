package de.notfound.resourcely.file.type
{
	import flash.utils.ByteArray;
	public class JPGSignature extends FileTypeSignature
	{
		public function JPGSignature() {
			
			var signature : ByteArray = new ByteArray();
			signature.writeByte(0xFF);
			signature.writeByte(0xD8);
			
			super(signature, FileType.TYPE_JPG);
		}
	}
}