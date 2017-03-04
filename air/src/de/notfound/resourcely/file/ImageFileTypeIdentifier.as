package de.notfound.resourcely.file
{
	import de.notfound.resourcely.file.type.FileType;
	import de.notfound.resourcely.file.type.FileTypeSignature;
	import de.notfound.resourcely.file.type.GIF87aSignature;
	import de.notfound.resourcely.file.type.GIF89aSignature;
	import de.notfound.resourcely.file.type.JPGSignature;
	import de.notfound.resourcely.file.type.PNGSignature;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.net.URLStream;

	/**
	 * This class checks whether a given file is of type GIF, PNG or JPG.
	 * It's based on the magic numbers mentioned in: https://en.wikipedia.org/wiki/Magic_number_%28programming%29.
	 */
	public class ImageFileTypeIdentifier extends EventDispatcher
	{
		private var _type : uint = FileType.TYPE_UNKNOWN;
		private var _signatures : Vector.<FileTypeSignature>;

		public function ImageFileTypeIdentifier()
		{
			_signatures = new Vector.<FileTypeSignature>();
			_signatures.push(new GIF87aSignature());
			_signatures.push(new GIF89aSignature());
			_signatures.push(new JPGSignature());
			_signatures.push(new PNGSignature());
		}

		/**
		 * Identifies the image filetype.
		 * 
		 * @param urlRequest A reference to the file.
		 * @return Returns either ImageFileType.JPG, ImageFileType.GIF, ImageFileType.PNG or ImageFileType.UNKNOWN
		 */
		public function identifiy(urlRequest : URLRequest) : void
		{
			var urlStream : URLStream = new URLStream();
			urlStream.addEventListener(ProgressEvent.PROGRESS, handleFileProgress);
			urlStream.addEventListener(Event.COMPLETE, handleFileComplete);
			urlStream.load(urlRequest);
		}

		private function handleFileProgress(event : ProgressEvent) : void
		{
			var urlStream : URLStream = URLStream(event.target);
			
			outer:
			while (urlStream.bytesAvailable)
			{
				var byte : int = urlStream.readByte();
				for (var i : int = 0; i < _signatures.length; i++)
				{
					if(_signatures[i].match(byte))
					{
						urlStream.close();
						_type = _signatures[i].fileType;
						dispatchEvent(new Event(Event.COMPLETE));
						break outer;
					}
				}
			}
		}

		private function handleFileComplete(event : Event) : void
		{
			var urlStream : URLStream = URLStream(event.target);
			urlStream.close();
			
			dispatchEvent(new Event(Event.COMPLETE));
		}

		public function get type() : uint
		{
			return _type;
		}
	}
}