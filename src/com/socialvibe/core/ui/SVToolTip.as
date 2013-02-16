package com.socialvibe.core.ui
{
	import flash.display.*;
	import flash.filters.GlowFilter;
	import flash.geom.*;

	public class SVToolTip extends Sprite
	{
		private var _width:Number;
		private var _height:Number;
		
		private var _caretHeight:Number = 8;
		private var _caretWidth:Number = 16;
		
		private var _mainPanel:Sprite;
		
		public function SVToolTip( contents:Sprite, caretPositionInPercent:Number = 0.25)
		{

			_width = contents.width + 16*2;
			_height = contents.height + 15*2;
			
			_mainPanel = new Sprite();
			_mainPanel.x = -_width * caretPositionInPercent;
			_mainPanel.y = -_height + -_caretHeight;
			addChild(_mainPanel);
			
			if (contents != null){
				contents.x = 16;
				contents.y = 15;
				_mainPanel.addChild(contents);	
			}

			var g:Graphics = _mainPanel.graphics;
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(_width, _height + _caretHeight, Math.PI/2);
			g.beginGradientFill(GradientType.LINEAR, [0x414141, 0x212121], [1,1], [0, 255], gradientMatrix, SpreadMethod.PAD, InterpolationMethod.RGB);
			g.drawRoundRect(0,0, _width, _height, 15);
			
			g.lineStyle(1, 0x212121, 1, true );
			g.moveTo( _width * caretPositionInPercent - _caretWidth / 2, _height);
			g.lineTo( _width * caretPositionInPercent, _height + _caretHeight);
			g.lineTo( _width * caretPositionInPercent + _caretWidth / 2, _height);
//			g.lineTo( _width * caretPositionInPercent - _caretWidth / 2, _height);
									
			this.filters = [ new GlowFilter(0x454545, .35, 12, 12)];
		}
		
		
	}
}