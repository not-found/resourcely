package de.notfound.resourcely.config.strategy
{
	import de.notfound.resourcely.model.Density;
	
	/**
	 * Abstract class that defines methods resourcely uses to scale images.
	 */
	public class ResourceScalingStrategy
	{
		/**
		 * Classes extending ResourceScalingStrategy should overwrite this method. It should return the scaling factor used
		 * for scaling an image.
		 * 
		 * @param deviceDpi The current devices dpi value.
		 * @param imageDensity The density folder the image in question was located in.
		 */
		public function getScale(deviceDpi : Number, imageDensity : Density) : Number
		{
			throw new Error("This method has to be implemented.");
		}
	}
}