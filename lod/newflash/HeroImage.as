﻿package  {
	// Flash stuff
	import flash.display.MovieClip;

	// Used to make nice buttons / doto themed stuff
    import flash.utils.getDefinitionByName;

	public class HeroImage extends MovieClip {
		// Container for the hero image
		public var con:MovieClip;

		// The ability container
		//public var ability:MovieClip;

		public function HeroImage() {
		}

		// Change the image
		public function setHeroImage(newImage:String):void {
			// Load the hero image
			lod.Globals.LoadImageWithCallback('images/heroes/selection/' + newImage + '.png', con, false, function(bitmap) {
				// Rescale the bitmap
				var newScale = 100/bitmap.width;

				con.scaleX = 71/128;
				con.scaleY = 71/128;

				bitmap.scaleX = newScale;
				bitmap.scaleY = newScale;
			});
		}
	}
}
