package de.notfound.resourcely.model
{
	import flash.filesystem.File;

	public class Path
	{
		private var _file : File;
		private var _density : Density;

		public function Path(file : File, density : Density)
		{
			_density = density;
			_file = file;
		}

		public function get file() : File
		{
			return _file;
		}

		public function get density() : Density
		{
			return _density;
		}
	}
}