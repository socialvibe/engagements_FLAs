/*

Twinkling Stars
ver. 0.1
- - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
 Author:  matt carpenter
          http://orangesplotch.com
 License: This code is released under the 
          Creative Commons Attribution-ShareAlike 2.5 License
          http://creativecommons.org/licenses/by-sa/2.5/

 Dynamically generated constellations with full screen option.

*/

package {

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.Sprite;
import flash.display.Stage;
import flash.display.StageDisplayState;
import flash.display.StageScaleMode;
import flash.events.*;
import flash.geom.Rectangle;
import flash.system.Capabilities;

[SWF(width="500", height="196", frameRate="24", backgroundColor="#FFFFFF")]
public class FullscreenStarryNight extends Sprite
{
private var follower:Sprite;
private var bg:Sprite;
private var sky:DisplayObjectContainer;

private var sh:Number;
private var sw:Number;

private var bigStars:Array;
private var smallStars:Array;

public function FullscreenStarryNight()
{
	stage.scaleMode = StageScaleMode.NO_SCALE;

	sh = stage.stageHeight;
	sw = stage.stageWidth;

	// set up the background (black)
	bg = new Sprite();
	bg.graphics.beginFill(0);
	bg.graphics.drawRect(0, 0, sw, sh);
	addChild(bg);

	// now make the sky
	sky = new Sprite();
	addChild(sky);

	// create and render the stars
	MakeBigStars(500);
	MakeSmallStars(1000);
	DrawStars();

	// add the needed event listeners
	stage.addEventListener(MouseEvent.CLICK, FullScreenSwitch);
	stage.addEventListener(Event.FULLSCREEN, FullScreenHandler);
}

// Create an array of big stars
private function MakeBigStars(numStars:Number):void {
	// create new stars
	bigStars = new Array(numStars);
	for (var i:Number = 0; i<numStars; ++i) {
		bigStars[i] = new Star();
	}
}

// Create an array of smaller stars
private function MakeSmallStars(numStars:Number):void {
	// create new stars
	smallStars = new Array(numStars);
	for (var i:Number = 0; i<numStars; ++i) {
		smallStars[i] = new Star();
		smallStars[i].isbig = false;
	}
}

// Render the stars
private function DrawStars():void {
	// first hide all stars being shown
	while(sky.numChildren) {
		sky.removeChildAt(0);
	}

	// redraw background
	sh = stage.stageHeight;
	sw = stage.stageWidth;
	bg.graphics.beginFill(0);
	bg.graphics.drawRect(0, 0, sw, sh);

	// Draw the stars
	var i:Number;
	var curStar:Star;
	if (StageDisplayState.FULL_SCREEN == stage.displayState) {
		// draw the big stars
		for (i=0; i<bigStars.length; ++i) {
			bigStars[i].x = bigStars[i].xval * sw;
			bigStars[i].y = bigStars[i].yval * sh;
			
			bigStars[i].graphics.clear();
			bigStars[i].graphics.beginFill(0xFFFFFF);
			bigStars[i].graphics.drawCircle(0, 0, (bigStars[i].size * 1.25 + 1.25) );
			
			sky.addChildAt(bigStars[i], i);
		}

		// draw the small stars
		for (i=0; i<smallStars.length; ++i) {
			smallStars[i].x = smallStars[i].xval * sw;
			smallStars[i].y = smallStars[i].yval * sh;
			
			smallStars[i].graphics.clear();
			smallStars[i].graphics.beginFill(0xFFFFFF);
			smallStars[i].graphics.drawCircle(0, 0, (smallStars[i].size * 1 + 0.25) );
			
			sky.addChildAt(smallStars[i], i);
		}

	}
	else {
		// draw only the big stars
		for (i=0; i<bigStars.length; ++i) {
			// curStar = bigStars[i];
			bigStars[i].x = bigStars[i].xval * sw;
			bigStars[i].y = bigStars[i].yval * sh;
			
			bigStars[i].graphics.clear();
			bigStars[i].graphics.beginFill(0xFFFFFF);
			bigStars[i].graphics.drawCircle(0, 0, (bigStars[i].size * 1 + 0.25) );
			
			sky.addChildAt(bigStars[i], i);
		}
	}
}

// Switch to and from full screen mode
private function FullScreenSwitch(event:Event):void {
	// if you are in normal mode, switch to fullscreen
	// if you are in fullscreen, switch back to normal
	if (StageDisplayState.FULL_SCREEN == stage.displayState) {
		stage.displayState = StageDisplayState.NORMAL
	}
	else {
		var screenRectangle:Rectangle = new Rectangle(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		stage.fullScreenSourceRect = screenRectangle;
		stage.displayState = StageDisplayState.FULL_SCREEN;
	}
}

// rerender the stars when entering and exiting full screen mode
private function FullScreenHandler(event:FullScreenEvent):void {
	DrawStars();
}

} // end Constellation class

} // end package
