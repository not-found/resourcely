package de.notfound.resourcely.config.strategy
{
	import de.notfound.resourcely.model.Density;

	/**
	 * Implements the abstract class ResourceLocationStrategy.
	 * Resourcely will use the density folder which is the next best guess for the current Capabilities.screenDPI value.
	 * If it doesn't exist, it'll take the next lower one.
	 */
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