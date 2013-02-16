/*

Star
ver. 0.1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 Author:  matt carpenter
          http://orangesplotch.com
 License: This code is released under the 
          Creative Commons Attribution-ShareAlike 2.5 License
          http://creativecommons.org/licenses/by-sa/2.5/

 A twinkly star.

*/

package {

import flash.display.Sprite;
import flash.events.Event;

public class Star extends Sprite {
	public var xval:Number;
	public var yval:Number;
	public var size:Number;
	public var isbig:Boolean;

	private var maxalpha:Number;
	private var minalpha:Number;

	public function Star():void {
		// initialize the size and position variables
		xval  = Math.random();
		yval  = Math.random();
		size  = Math.random();
		isbig = true;

		// initialize the alpha settings
		this.alpha = Math.random() * 0.25 + 0.75;
		minalpha = this.alpha - 0.4;
		maxalpha = this.alpha + 0.4;

		// have the scale correlate with the alpha
		if (minalpha < 0) minalpha = 0;
		if (maxalpha > 1) maxalpha = 1;
		this.scaleX = this.alpha * 0.5 + 0.5;
		this.scaleY = this.alpha * 0.5 + 0.5;

		// add the enter frame handler so our star will twinkle
		this.addEventListener(Event.ENTER_FRAME, Twinkle);
	}

	// twinkle, twinkle little star
	public function Twinkle(event:Event):void {
		var _self:Star = Star(event.currentTarget);
		
		// sporadically change the alpha and size of the star
		if (Math.random() > 0.2) {
			_self.alpha += Math.random() * 0.02 - 0.01;
			_self.scaleX = _self.alpha * 0.5 + 0.5;
			_self.scaleY = _self.alpha * 0.5 + 0.5;
			
			// do some bounds checking so it doesn't get too crazy
			if (_self.alpha < _self.minalpha) _self.alpha = _self.minalpha;
			if (_self.alpha > _self.maxalpha) _self.alpha = _self.maxalpha;
		}
	}

} // end Star class

}