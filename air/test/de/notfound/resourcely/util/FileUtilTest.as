package de.notfound.resourcely.util
{
	import org.flexunit.Assert;

	public class FileUtilTest
	{
		[Test]
		public function testJpgExtension() : void
		{
			Assert.assertEquals(true, FileUtil.isImageFile("jpg"));
		}

		[Test]
		public function testJpegExtension() : void
		{
			Assert.assertEquals(true, FileUtil.isImageFile("jpeg"));
		}

		[Test]
		public function testGifExtension() : void
		{
			Assert.assertEquals(true, FileUtil.isImageFile("gif"));
		}

		[Test]
		public function testPngExtension() : void
		{
			Assert.assertEquals(true, FileUtil.isImageFile("png"));
		}

		[Test]
		public function testUnknownExtension() : void
		{
			Assert.assertEquals(false, FileUtil.isImageFile("doc"));
		}

		[Test]
		public function testEmptyExtension() : void
		{
			Assert.assertEquals(false, FileUtil.isImageFile(""));
		}

		[Test]
		public function testNullExtension() : void
		{
			Assert.assertEquals(false, FileUtil.isImageFile(null));
		}
	}
}