package de.notfound.resourcely.file.type
{
	import flash.utils.ByteArray;
	public class GIF87aSignature extends FileTypeSignature
	{
		public function GIF87aSignature() {
			
			var signature : ByteArray = new ByteArray();
			signature.writeByte(0x47);
			signature.writeByte(0x49);
			signature.writeByte(0x46);
			signature.writeByte(0x38);
			signature.writeByte(0x37);
			signature.writeByte(0x61);
			
			super(signature, FileType.TYPE_GIF);
		}
	}
}