package com.socialvibe.core.ui
{
	import com.socialvibe.core.config.*;
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class SVColorPicker extends Sprite
	{
		public static const COLOR_UPDATE:String = 'colorUpdated';
		
		protected const defaults:Array = [	{'data':0xFFFFFF,	'label':'Cloud'}, 
			{'data':0x191919,	'label':'Knight'}, 
			{'data':Style.pink,	'label':'Pinkerton'}, 
			{'data':0xa100d0, 	'label':'Reign'}, 
			{'data':0x0096ff,	'label':'Ocean'}, 
			{'data':0x1200ff, 	'label':'Electro'},  
			{'data':0xefd600, 	'label':'Sunflower'}, 
			{'data':0x00ef11, 	'label':'Froggy'}, 
			{'data':0xff4800, 	'label':'Crush'},
			{'data':0xc80000,	'label':'Crimson'}
		];
		
		protected const DEFAULT_COLOR:uint = 100;
		protected var _colorBarOffset:Number = 75;
		
		protected var _preSelectedBar:Sprite;
		protected var _colorBar:Sprite;
		protected var _selectCircle:Shape;
		protected var _colorSwatch:Shape;
		protected var _currColor:uint;
		
		public function SVColorPicker()
		{
			this.graphics.beginFill(0xFFFFFF, 0.1);
			this.graphics.drawRoundRect(-3, -3, 275+6, 30+6, 8);
			this.graphics.beginFill(0xFFFFFF, 0.8);
			this.graphics.drawRoundRect(275+18, -3, 36, 36, 8);			
			
			createPreSelectedBar();
			createColorBar();
			
			_selectCircle = new Shape();
			_selectCircle.graphics.beginFill(0xFFFFFF);
			_selectCircle.graphics.drawCircle(3, 3, 3);
			_selectCircle.graphics.drawCircle(3, 3, 2);
			
			_colorSwatch = new Shape();
			_colorSwatch.x = 275+21;
			addChild(_colorSwatch);
			
			_colorBar.x = _colorBarOffset;
			
			colorValue = 0x454545;//SVUtilities.hsb_to_rgb([100,100,100]);
		}
		
		protected function createPreSelectedBar():void
		{
			_preSelectedBar = new Sprite();
			_preSelectedBar.addEventListener(MouseEvent.CLICK, onPreSelectClick, false, 0, true);
			_preSelectedBar.buttonMode = true;
			_preSelectedBar.useHandCursor = true;
			
			var g:Graphics = _preSelectedBar.graphics;
			for (var i:int=0; i<defaults.length; i++)
			{
				if (defaults[i].data == 0x454545)
					g.beginFill(0x191919);
				else
					g.beginFill(defaults[i].data);
				g.drawRect(Math.floor(i/2)*15, (i%2)*15, 15, 15);
			}
			
			addChild(_preSelectedBar);
		}
		
		protected function createColorBar():void
		{
			_colorBar = new Sprite();
			_colorBar.buttonMode = true;
			_colorBar.useHandCursor = true;
			
			var barHSB:Array = [-1, 100, 100];
			var color:uint;
			
			var g:Graphics = _colorBar.graphics;
			
			for (var i:int=0; i<200; i++)
			{
				barHSB[0] = Math.ceil(i*1.8);
				color = SVUtilities.hsb_to_rgb(barHSB);
				g.lineStyle(1, color, 1);
				g.lineTo(i, 30);
				g.moveTo(i+1, 0);
			}
			
			g.lineStyle();
			
			var gradientMatrix:Matrix = new Matrix();
			gradientMatrix.createGradientBox(200, 17, Math.PI/2, 0, -2);
			g.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], [1, 0], [0, 255], gradientMatrix, SpreadMethod.PAD, InterpolationMethod.RGB);
			g.drawRect(0, 0, 200, 15);
			
			gradientMatrix = new Matrix();
			gradientMatrix.createGradientBox(200, 17, Math.PI/2, 0, 15);
			g.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, 1], [0, 255], gradientMatrix, SpreadMethod.PAD, InterpolationMethod.RGB);
			g.drawRect(0, 15, 200, 15);
			
			_colorBar.addEventListener(MouseEvent.MOUSE_DOWN, onColorBarDown, false, 0, true);
			
			addChild(_colorBar);
		}
		
		protected function onPreSelectClick(e:MouseEvent):void
		{
			if (!contains(_selectCircle))
				addChild(_selectCircle);
			
			_selectCircle.x = (Math.floor(e.localX/15)*15) + 4.5;
			_selectCircle.y = (e.localY > 15 ? 19.5 : 4.5);
			
			colorValue = defaults[(Math.floor(e.localX/15)*2) + (e.localY > 15 ? 1 : 0)].data;
		}
		
		protected function onColorBarDown(e:MouseEvent):void
		{
			_colorBar.addEventListener(MouseEvent.MOUSE_MOVE, onColorBarMove, false, 0, true);
			_colorBar.addEventListener(MouseEvent.MOUSE_UP, onColorBarUp, false, 0, true);
			
			if (!contains(_selectCircle))
				addChild(_selectCircle);
			
			onMouseSet(e);
		}
		protected function onColorBarUp(e:MouseEvent):void
		{
			_colorBar.removeEventListener(MouseEvent.MOUSE_MOVE, onColorBarMove);
			_colorBar.removeEventListener(MouseEvent.MOUSE_UP, onColorBarUp);
			
			onMouseSet(e);
		}
		protected function onColorBarMove(e:MouseEvent):void
		{
			onMouseSet(e);
		}
		protected function onMouseSet(e:MouseEvent):void
		{
			var position:Number = Math.max(Math.min(e.localX+_colorBarOffset, e.currentTarget.width+_colorBarOffset), 4);
			
			_selectCircle.x = position-4;
			_selectCircle.y = Math.max(Math.min(e.localY, 29), 4)-4;
			
			var currentBrightness:Number = (e.localY > 15 ? (30-Math.min(e.localY, 26)) * 6.67 : 100);
			var currentSat:Number = (e.localY > 15 ? 100 : Math.max(2, e.localY) * 6.67);
			
			colorValue = SVUtilities.hsb_to_rgb([currentHue, currentSat, currentBrightness]);
		}
		
		protected function get currentHue():uint { return Math.floor((_selectCircle.x-_colorBarOffset+4)*1.8); }
		
		public function clear():void
		{
			if (contains(_selectCircle))
				removeChild(_selectCircle);
		}
		
		public function set colorValue(value:Number):void
		{
			_currColor = value;
			
			var g:Graphics = _colorSwatch.graphics;
			g.clear();
			
			g.beginFill(value == 0x454545 ? 0x191919 : value);
			g.drawRoundRect(0, 0, 30, 30, 4);
			
			dispatchEvent(new SVEvent( COLOR_UPDATE, value ));
		}
		
		public function get colorValue():Number { return _currColor; }
	}
}
