package de.notfound.resourcely.file.type
{
	import flash.utils.ByteArray;

	/**
	 * Defines a byte sequence for a PNG header.
	 */
	public class PNGSignature extends FileTypeSignature
	{
		public function PNGSignature()
		{
			var signature : ByteArray = new ByteArray();
			signature.writeByte(0x89);
			signature.writeByte(0x50);
			signature.writeByte(0x4E);
			signature.writeByte(0x47);
			signature.writeByte(0x0D);
			signature.writeByte(0x0A);
			signature.writeByte(0x1A);
			signature.writeByte(0x0A);

			super(signature, FileType.TYPE_PNG);
		}
	}
}