package de.notfound.resourcely.config.strategy
{
	import de.notfound.resourcely.model.Density;

	/**
	 * Abstract class that defines methods resourcely uses to locate image resources.
	 */
	public class ResourceLocationStrategy
	{
		/**
		 * Classes extending ResourceLocationStrategy should implement this. Resourcely will scan the resource folder in order
		 * of the Vector this method returns. It'll use the qualifier to locate the corresponding folders. For example:
		 * 'res/ldpi/img.jph' for the the Density with the lowest dpi value. 
		 * 
		 * @param densities A list of Densities, ordered ascending by dpi value.
		 * @return Should return the list in the order resourcely should look through the resource folders.
		 */
		public function getOrder(deviceDpi : Number, densities : Vector.<Density>) : Vector.<Density>
		{
			throw new Error("This method has to be implemented.");
		}
		
		//Find the density which is the next best guess compared to the current screenDPI value.
		protected function getNextBestDensity(deviceDpi : Number, densities : Vector.<Density>) : Density
		{
			var currentDpi : Number = deviceDpi;
			var dpiDif : Number = Number.MAX_VALUE;
			var tempDif : Number = dpiDif;
			var nextBestDensity : Density;
			
			nextBestDensity = densities[0];
			for (var i : int = 1; i < densities.length; i++)
			{
				tempDif = (currentDpi - densities[i].dpi) * (currentDpi - densities[i].dpi);
				if(tempDif <= dpiDif)
				{
					nextBestDensity = densities[i];
					dpiDif = tempDif;				
				}
			}
			
			return nextBestDensity;
		}
	}
}