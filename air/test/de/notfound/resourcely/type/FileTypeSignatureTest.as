package de.notfound.resourcely.type
{
	import de.notfound.resourcely.file.type.FileType;
	import de.notfound.resourcely.file.type.FileTypeSignature;

	import org.flexunit.Assert;

	import flash.utils.ByteArray;
	public class FileTypeSignatureTest
	{
		private static const BYTE_1 : int = 0x0a;
		private static const BYTE_2 : int = 0x0b;
		private static const BYTE_3 : int = 0x0c;
		private static const FILE_TYPE : int = FileType.TYPE_PNG;
		
		private var _signature : FileTypeSignature;

		[Test]
		public function testMatchingSequence() : void
		{
			_signature.match(BYTE_1);
			_signature.match(BYTE_2);
			Assert.assertEquals(true, _signature.match(BYTE_3));
		}

		[Test]
		public function testNotMatchingSequence() : void
		{
			_signature.match(BYTE_1);
			_signature.match(BYTE_2);
			Assert.assertEquals(false, _signature.match(BYTE_1));
		}

		[Test]
		public function testFileTypeLinkage() : void
		{
			Assert.assertEquals(FILE_TYPE, _signature.fileType); 
		}
		
		[Before]
		public function setup() : void
		{
			var bytes : ByteArray = new ByteArray();
			bytes.writeByte(BYTE_1);
			bytes.writeByte(BYTE_2);
			bytes.writeByte(BYTE_3);
			
			_signature = new FileTypeSignature(bytes, FILE_TYPE);
		}
	}
}