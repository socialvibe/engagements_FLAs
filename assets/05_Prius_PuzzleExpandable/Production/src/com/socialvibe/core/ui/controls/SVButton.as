package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.ui.SVSquareLoader;
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.text.*;
	
	public class SVButton extends Sprite implements IConfigurableControl
	{
		[Embed(source="assets/images/next_arrow.png")]
		public static var nextArrowImg:Class;
		
		protected var _buttonColor:Number 		= 0x009adf;
		protected var _rollColor:Number;
		
		protected var _width:Number;
		protected var _height:Number;
		protected var _curveSize:Number;
		protected var _fontSize:Number;
		protected var _fontColor:Number;
		
		protected var _actions:Array;
		protected var _effects:Array;
		
		protected var _text:String;
		protected var _label:SVText;
		protected var _arrow:Bitmap;
		protected var _disabler:Sprite;
		protected var _underline:Boolean;
		
		protected var _rollover:Bitmap;
		protected var _gradientLayer:Sprite;
		
		protected var _loading:SVSquareLoader;
		protected var _loadingMsg:SVText;
		
		public function SVButton(text:String = 'Button', width:Number = 100, height:Number = 32, fontSize:Number = 17, curveSize:Number = 16, color:uint = 0x009adf)
		{
			_text = text;
			_width = width;
			_height = height;
			_fontSize = fontSize;
			_fontColor = 0xFFFFFF;
			_curveSize = curveSize;
			_buttonColor = color;
			_underline = true;
			
			init();
		}
		
		protected function init():void
		{
			this.buttonMode = this.useHandCursor = true;
			this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
			this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
			this.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			
			addText();
			
			positionLabel();
			
			drawBackground(_buttonColor);
		}
		
		protected function drawBackground(color:uint):void
		{			
			var g:Graphics = this.graphics;
			g.clear();
			
			g.beginFill(color);
			g.drawRoundRect(0,0,_width,_height,_curveSize);
			
			if (_underline && _label)
			{
				g.beginFill(0xFFFFFF, 0.35);
				g.drawRect(_label.x+2, _label.y + _label.textHeight + 3, _label.textWidth, 2);
			}
			
			if (_gradientLayer == null)
			{
				_gradientLayer = new Sprite(); 
				g = _gradientLayer.graphics;
				var gradientMatrix:Matrix = new Matrix();
				gradientMatrix.createGradientBox(_width, _height, Math.PI/2);
				g.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000], [0, 0.285], [50, 255], gradientMatrix);
				g.drawRoundRect(0, 0, _width, _height, _curveSize);
				addChildAt(_gradientLayer, 0);
			}
			
			if (_rollover == null)
			{
				var bData:BitmapData = new BitmapData(_width, _height);
				if (SVUtilities.getBrightness(_buttonColor) < 70)
				{
					var colorT:ColorTransform = new ColorTransform(2, 2, 2);
					colorT.color = 0xffffff;
					bData.draw(this, new Matrix(), colorT);
				}
				else
				{
					bData.draw(this, new Matrix());
				}
				
				_rollover = new Bitmap(bData.clone());
				_rollover.alpha = 0.35;
				_rollover.blendMode = BlendMode.MULTIPLY;
				_rollover.visible = false;
				addChild(_rollover);
				
				if (SVUtilities.getBrightness(_buttonColor) < 70)
				{
					_rollover.alpha = 0.2;
					_rollover.blendMode = BlendMode.NORMAL;
				}
			}
		}
		
		protected function positionLabel():void
		{
			_label.x = Math.floor((_width - _label.width)/2);
			_label.y = Math.floor(_height/2 - _label.height/2);
		}
		
		public function enable():void
		{
			if (_disabler && contains(_disabler))
				removeChild(_disabler);
			
			buttonMode = mouseEnabled = mouseChildren = true;
			
			_label.alpha = 1;
			drawBackground(_buttonColor);
		}
		
		public function disable():void
		{
			if (_disabler == null)
			{
				_disabler = new Sprite();
				_disabler.graphics.beginFill(1, 0);
				_disabler.graphics.drawRect(-1, 0, _width+2, _height+2);
			}
			addChild(_disabler);
			buttonMode = mouseEnabled = mouseChildren = false;
			
			_label.alpha = 0.5;
			drawBackground(0xcccccc);
		}
		
		protected function addText():void 
		{
			_label = new SVText(_text, 0, 0, _fontSize, true, _fontColor);
			addChild(_label);
		}
		
		protected function onRollOut(e:MouseEvent):void
		{
			if (!mouseEnabled) return;
			
			if (isNaN(_rollColor))
				_rollover.visible = false;
			else
				drawBackground(_buttonColor);
		}
		
		protected function onRollOver(e:MouseEvent):void
		{
			if (isNaN(_rollColor))
				_rollover.visible = true;
			else
				drawBackground(_rollColor);
		}
		
		protected function onClick(e:MouseEvent):void
		{
			dispatchEvent(new SVEvent(ConfigurableObjectUtils.TRIGGER_ACTION, _actions, true, true));
		}
		
		public function startSubmit(text:String = null):void
		{
			if (_loading == null)
			{
				_loading = new SVSquareLoader();
				_loading.scaleX = _loading.scaleY = (_height/1.25)/_loading.height;
				_loading.x = (_width - _loading.width)/2;
				_loading.y = (_height - _loading.height)/2;
				
				if (text)
				{
					_loadingMsg = new SVText(text, 0, 0, _fontSize);
					_loading.x = (_width - (_loading.width+_loadingMsg.width))/2
					_loadingMsg.x = _loading.x + _loading.width + 4;
					_loadingMsg.y = ( _label ? _label.y : (_height - _loadingMsg.height)/2 );
				}
			}
			
			addChild(_loading);
			_loading.start();
			
			if (_loadingMsg)
				addChild(_loadingMsg);
			
			if (_label)
				_label.visible = false;
			
			if (_arrow)
				_arrow.visible = false;
			
			clear();
			buttonMode = mouseEnabled = mouseChildren = false;
		}
		
		public function endSubmit():void
		{
			if (_loading && contains(_loading))
			{
				_loading.stop();
				
				if (_loadingMsg && contains(_loadingMsg))
					removeChild(_loadingMsg);
				
				clear();
				
				if (_label)
					_label.visible = true;
				
				if (_arrow)
					_arrow.visible = true;
				
				drawBackground(_buttonColor);
				buttonMode = mouseEnabled = mouseChildren = true;
			}
		}
		
		public function clear():void
		{
			this.graphics.clear();
			
			if (_gradientLayer && contains(_gradientLayer))
				removeChild(_gradientLayer);
			_gradientLayer = null;
			
			if (_rollover && contains(_rollover))
				removeChild(_rollover);
			_rollover = null;
		}
		
		public function set underline(value:Boolean):void
		{
			_underline = value;
			
			drawBackground(_buttonColor);
		}
		
		public function set nextArrow(value:Boolean):void
		{
			if (value)
			{
				_arrow = new nextArrowImg() as Bitmap;
				_arrow.transform.colorTransform.color = _fontColor;
				_arrow.smoothing = true;
				_arrow.x = _width - 30;
				_arrow.y = (_height - _arrow.height)/2;
				addChild(_arrow);
				
				_label.x = (_width - 32)/2 - _label.width/2;
				
				clear();
				
				drawBackground(_buttonColor);
			}
		}
		
		public function set rolloverColor(color:uint):void
		{
			_rollColor = color;
		}
		
		public function set textColor(color:uint):void
		{
			_fontColor = color;
			_label.textColor = color;
			
			if (_arrow)
			{
				var tf:ColorTransform = _arrow.transform.colorTransform;
				tf.color = color;
				_arrow.transform.colorTransform = tf;
			}
		}
		
		public function get text():String { return _label.text; }
		
		public function get textField():TextField { return _label; }
		public function get gradient():Sprite { return _gradientLayer; }
		
		public function get enabled():Boolean { return !(_disabler && contains(_disabler)); }
		
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		public function set text(value:String):void
		{
			_text = value;
			
			_label.text = value;
			positionLabel();
			clear();
			
			drawBackground(_buttonColor);
		}
		
		override public function set width(value:Number):void
		{
			if (isNaN(value) || value <= 0) return;
			
			_width = value;
			
			positionLabel();
			clear();
			
			drawBackground(_buttonColor);
		}
		
		override public function set height(value:Number):void
		{
			if (isNaN(value) || value <= 0) return;
			
			_height = value;
			
			positionLabel();
			clear();
			
			drawBackground(_buttonColor);
		}
		
		public function set color(value:uint):void
		{
			_buttonColor = value;
			
			clear();
			
			drawBackground(_buttonColor);
		}
		
		public function set font_size(value:uint):void
		{
			_fontSize = value;
			
			_label.size = _fontSize;
			positionLabel();
			
			clear();
			drawBackground(_buttonColor);
		}
		
		public function set font_color(value:uint):void
		{
			_fontColor = value;
			
			_label.color = _fontColor;
		}
		
		public function set curve_size(value:uint):void
		{
			_curveSize = value;
			
			clear();
			
			drawBackground(_buttonColor);
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'button'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.stringVar('text', _text, 'Button'),
					ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('width', _width, 100), 
					ConfigurableObjectUtils.numberVar('height', _height, 32), 
					ConfigurableObjectUtils.colorVar('color', _buttonColor, '009adf'), 
					ConfigurableObjectUtils.numberVar('font_size', _fontSize, 17), 
					ConfigurableObjectUtils.colorVar('font_color', _fontColor, 'ffffff'), 
					ConfigurableObjectUtils.numberVar('curve_size', _curveSize, 16, {desc:"Radius (in pixels) of the button's rounded corners."}),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('actions', _actions, null, {hidden:true, desc:"clicking on the button"})];
		}
		
		public function getConfig():Object
		{
			return ConfigurableObjectUtils.getConfigObject(this);
		}
		
		public function setConfig(config:Object):void
		{
			config = ConfigurableObjectUtils.decodeConfig( config, this );
			
			for (var configName:Object in config)
			{
				switch (configName)
				{
					case 'text':
						text = config[configName];
						break;
					case 'x':
						x = config[configName];
						break;
					case 'y':
						y = config[configName];
						break;
					case 'width':
						width = config[configName];
						break;
					case 'height':
						height = config[configName];
						break;
					case 'color':
						color = config[configName];
						break;
					case 'font_size':
						font_size = config[configName];
						break;
					case 'font_color':
						font_color = config[configName];
						break;
					case 'curve_size':
						curve_size = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
					case 'actions':
						_actions = config[configName];
						break;
				}
			}
		}
	}
}