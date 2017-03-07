package de.notfound.resourcely.file.type
{
	import flash.utils.ByteArray;
	
	/**
	 * Defines a byte sequence for a GIF89a header.
	 */
	public class GIF89aSignature extends FileTypeSignature
	{
		public function GIF89aSignature()
		{
			var signature : ByteArray = new ByteArray();
			signature.writeByte(0x47);
			signature.writeByte(0x49);
			signature.writeByte(0x46);
			signature.writeByte(0x38);
			signature.writeByte(0x39);
			signature.writeByte(0x61);

			super(signature, FileType.TYPE_GIF);
		}
	}
}