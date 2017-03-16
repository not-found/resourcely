package de.notfound.resourcely.config.strategy
{
	import de.notfound.resourcely.model.Density;
	
	/**
	 * Implements the abstract class ResourceScalingStrategy.
	 * Resourcely will try to scale every image in a way that it'll look the same size on every screen, regardless of its dpi value.
	 */
	public class DefaultResourceScalingStrategy extends ResourceScalingStrategy
	{
		public function DefaultResourceScalingStrategy()
		{
		}

		override public function getScale(deviceDpi : Number, imageDensity : Density) : Number
		{
			return deviceDpi / imageDensity.dpi;
		}
	}
}