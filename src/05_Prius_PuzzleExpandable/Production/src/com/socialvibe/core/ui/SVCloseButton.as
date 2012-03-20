package com.socialvibe.core.ui
{
	import com.socialvibe.core.config.*;
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;

	public class SVCloseButton extends Sprite
	{
		[Embed(source="assets/images/close_x.png")]
		public static var closeXImg:Class;
		
		protected var _light:Boolean;
		
		public function SVCloseButton(light:Boolean = false)
		{
			_light = light;
			
			var g:Graphics = this.graphics;
			g.beginFill(_light ? 0xf1f2f2 : Style.blueLink , _light ? 0.25 : 1);
			g.drawCircle(10.5, 10.5, 11);
			
			var closeX:Bitmap = new closeXImg() as Bitmap;
			closeX.x = (20 - 9)/2;
			closeX.y = (20 - 9)/2;
			addChild(closeX);
			
			var tf:ColorTransform = closeX.transform.colorTransform;
			tf.color = 0xFFFFFF;
			closeX.transform.colorTransform = tf;
			
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
			this.buttonMode = this.useHandCursor = Services.ALLOW_CURSOR_CHANGE;
		}
		
		protected function onRollOver(e:Event):void
		{
			var g:Graphics = this.graphics;
			g.clear();
			
			g.beginFill(Style.blueHover);
			g.drawCircle(10.5, 10.5, 11);
		}
		
		protected function onRollOut(e:Event):void
		{
			var g:Graphics = this.graphics;
			g.clear();
			
			g.beginFill(_light ? 0xf1f2f2 : Style.blueLink , _light ? 0.25 : 1);
			g.drawCircle(10.5, 10.5, 11);
		}
	}
}