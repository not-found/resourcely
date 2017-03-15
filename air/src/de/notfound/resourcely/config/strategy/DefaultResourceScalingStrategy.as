package de.notfound.resourcely.config.strategy
{
	import de.notfound.resourcely.model.Density;

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