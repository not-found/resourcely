package de.notfound.resourcely.config.strategy
{
	import de.notfound.resourcely.model.Density;
	
	public class ResourceScalingStrategy
	{
		public function getScale(deviceDpi : Number, imageDensity : Density) : Number
		{
			throw new Error("This method has to be implemented.");
		}
	}
}