package com.socialvibe.core.ui
{
	import flash.display.Sprite;

	public class SVVideoPlayerControlsBase extends Sprite
	{
		public static const PLAY:String = new String("PLAY");
		public static const PAUSE:String = new String("PAUSE");
		public static const SOUND_ON:String = new String("SOUND_ON");
		public static const SOUND_OFF:String = new String("SOUND_OFF");
		public static const START_OVER:String = new String("START_OVER");
		public static const DRAG_START:String = new String("DRAG_START");
		public static const DRAGGED:String = new String("DRAGGED");
		
		public function SVVideoPlayerControlsBase() { }
		
		public function set headPosition(position:Number):void { }
		
		public function pause():void { }
		
		public function play():void { }
		
		public function isPlaying():Boolean
		{
			return false;
		}
	}
}