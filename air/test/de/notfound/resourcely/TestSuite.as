package de.notfound.resourcely
{
	import de.notfound.resourcely.demo.DemoTest;
	import de.notfound.resourcely.dimension.ImageFileDimensionExtractorTest;
	import de.notfound.resourcely.type.FileTypeSignatureTest;
	import de.notfound.resourcely.type.ImageFileTypeIdentifierTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class TestSuite
	{
		public var demoTest : DemoTest;
		public var fileTypeSignatureTest : FileTypeSignatureTest;
		public var imageFileTypeIdentifierTest : ImageFileTypeIdentifierTest;
		public var imageFileDimensionExtractorTest : ImageFileDimensionExtractorTest;
	}
}