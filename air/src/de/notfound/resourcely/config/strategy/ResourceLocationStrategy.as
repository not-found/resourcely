package de.notfound.resourcely.config.strategy
{
	import de.notfound.resourcely.model.Density;

	import flash.system.Capabilities;

	public class ResourceLocationStrategy
	{
		public function getOrder(densities : Vector.<Density>) : Vector.<Density>
		{
			throw new Error("This method has to be implemented.");
		}
		
		protected function getNextBestDensity(densities : Vector.<Density>) : Density
		{
			var currentDpi : Number = Capabilities.screenDPI;
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