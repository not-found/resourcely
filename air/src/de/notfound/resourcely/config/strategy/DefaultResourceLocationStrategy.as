package de.notfound.resourcely.config.strategy
{
	import de.notfound.resourcely.model.Density;

	public class DefaultResourceLocationStrategy extends ResourceLocationStrategy
	{
		override public function getOrder(densities : Vector.<Density>) : Vector.<Density>
		{
			var nextBestDensity : Density = getNextBestDensity(densities);
			var nextBestDensityIndex : uint;
			var order : Vector.<Density> = new Vector.<Density>();
			
			for (var i : int = 0; i < densities.length; i++)
			{
				if(densities[i].dpi == nextBestDensity.dpi)
				{
					nextBestDensityIndex = i;
					break;
				}
			}
			
			order.concat(densities.slice(0, nextBestDensityIndex).reverse());
			if(nextBestDensityIndex < densities.length - 1)
				order.concat(densities.slice(nextBestDensityIndex + 1, densities.length - 1));
			
			return densities;
		}
	}
}