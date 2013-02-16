package com.socialvibe.core.ui.controls
{
	import com.gskinner.geom.ColorMatrix;
	import com.socialvibe.core.config.*;
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	
	public class SVImageButton extends SVButton implements IConfigurableControl
	{
		static public const IMAGE_LOADED:String = 'buttonImageLoaded';
		
		protected var _imageURL:String;
		protected var _buttonImage:Bitmap;
		
		protected var _hoverURL:String;
		protected var _hoverImage:Bitmap;
		
		protected var _glowColor:Number;
		protected var _glowAlpha:Number = 0.5;
		protected var _glowSize:Number = 12;
		
		public function SVImageButton()
		{
			super('', NaN, NaN, 0, 0, 0);
		}
		
		override protected function init():void
		{
			ConfigurableObjectUtils.addPlaceholder(this, getControlName(), 100, 32);
		}
		
		override protected function drawBackground(color:uint):void
		{
			
		}
		
		/* =============================
		Image Loading Functions
		============================= */
		public function loadBitmap( b:Bitmap ):void
		{
			if (_buttonImage)
				removeChild(_buttonImage);
			
			_buttonImage = b;
			onImageLoaded();
		}
		
		public function loadRemoteImage( imageURL:String ):void
		{
			if (imageURL == null || imageURL == "") return;
			
			_imageURL = imageURL;
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(loadEvent:Event):void{					
				loadBitmap(loadEvent.currentTarget.content as Bitmap);
			});
			imageLoader.load( new URLRequest( imageURL), new LoaderContext(true) );
		}
		
		public function loadHoverBitmap( b:Bitmap ):void
		{
			if (_buttonImage == null)
			{
				addEventListener(IMAGE_LOADED, function(e:Event):void {
					removeEventListener(IMAGE_LOADED, arguments.callee);
					loadHoverBitmap(b);
				});
				return;
			}
			
			if (_hoverImage)
				removeChild(_hoverImage);
			
			_hoverImage = b;
			_hoverImage.smoothing = true;
			_hoverImage.scaleX = _buttonImage.scaleX;
			_hoverImage.scaleY = _buttonImage.scaleY;
			_hoverImage.visible = false;
			
			addChild(_hoverImage);
		}
		
		public function loadRemoteHoverImage( imageURL:String ):void
		{
			if (imageURL == null || imageURL == "") return;
			
			_hoverURL = imageURL;
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(loadEvent:Event):void{					
				loadHoverBitmap(loadEvent.currentTarget.content as Bitmap);
			});
			imageLoader.load( new URLRequest( imageURL), new LoaderContext(true) );
		}
		
		override protected function onRollOver(e:MouseEvent):void
		{
			if (_hoverImage != null)
				_hoverImage.visible = true;
			else if (!isNaN(_glowColor))
				_buttonImage.filters = [ new GlowFilter(_glowColor, _glowAlpha, _glowSize, _glowSize) ];
			else if (_rollover)
				_rollover.visible = true;
		}
		
		override protected function onRollOut(e:MouseEvent):void
		{
			if (_hoverImage != null)
				_hoverImage.visible = false;
			else if (_buttonImage.filters.length > 0)
				_buttonImage.filters = [];
			else if (_rollover)
				_rollover.visible = false;
		}
		
		override public function startSubmit(text:String=null):void
		{
			_fontSize = _height / 2.5;
			super.startSubmit(text);
			
			if (_buttonImage)
				_buttonImage.visible = false;
		}
		
		override public function endSubmit():void
		{
			super.endSubmit();
			
			if (_buttonImage)
				_buttonImage.visible = true;
		}
		
		protected function removeDisableFilter():void
		{
			var filters:Array = this.filters;
			for (var i:int=0; i<filters.length; i++)
			{
				var filter:BitmapFilter = filters[i] as BitmapFilter;
				if (filter is ColorMatrixFilter)
				{
					filters.splice(i, 1);
					break;
				}
			}
			this.filters = filters;
		}
		
		override public function enable():void
		{
			if (enabled)
				return;
			
			_buttonImage.alpha = 1;
			
			removeDisableFilter();
			
			buttonMode = mouseEnabled = mouseChildren = true;
		}
		
		override public function disable():void
		{
			if (!enabled)
				return;
			
			if (_buttonImage == null)
			{
				addEventListener(IMAGE_LOADED, function(e:Event):void {
					removeEventListener(IMAGE_LOADED, arguments.callee);
					disable();
				});
				return;
			}
			
			buttonMode = mouseEnabled = mouseChildren = false;
			
			var matr:ColorMatrix = new ColorMatrix();
			matr.adjustColor(5, -50, -90, 0);
			
			this.filters = (this.filters ? this.filters.concat(new ColorMatrixFilter(matr)) : [ new ColorMatrixFilter(matr) ]);
			
			_buttonImage.alpha = 0.75;
		}
		
		override public function set underline(value:Boolean):void { }
		override public function set nextArrow(value:Boolean):void { }
		override public function set rolloverColor(color:uint):void { }
		override public function set textColor(color:uint):void { }
		override public function set text(value:String):void { }
		
		override public function get enabled():Boolean { return buttonMode; }
		
		/* =============================
		Image Loading Functions
		============================= */
		public function addGlowRollover(color:uint = 0xffffff, alpha:Number = 0.45, size:Number = 5):void
		{
			_glowColor = color;
			_glowAlpha = alpha;
			_glowSize = size;
		}
		
		public function resize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			
			if (_buttonImage)
			{
				if (!isNaN(_width))
					_buttonImage.scaleX = _rollover.scaleX = _width / _buttonImage.width;
				
				if (!isNaN(_height))
					_buttonImage.scaleY = _rollover.scaleY = _height / _buttonImage.height;
			}
			
			if (_hoverImage)
			{
				if (!isNaN(_width))
					_hoverImage.scaleX = _width / _hoverImage.width;
				
				if (!isNaN(_height))
					_hoverImage.scaleY = _height / _hoverImage.height;
			}
		}
		
		/* =============================
		Utility Functions
		============================= */	
		protected function onImageLoaded():void
		{
			ConfigurableObjectUtils.removePlaceholder(this);
			
			if (!this.hasEventListener(MouseEvent.ROLL_OVER))
			{
				this.buttonMode = this.useHandCursor = true;
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
				this.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			}
			
			_buttonImage.smoothing = true;
			
			addChildAt(_buttonImage, 0);
			
			if (_rollover)
				removeChild(_rollover);
			
			_rollover = new Bitmap(_buttonImage.bitmapData.clone());
			_rollover.alpha = 0.5;
			_rollover.blendMode = BlendMode.MULTIPLY;
			_rollover.visible = false;
			addChild(_rollover);
			
			resize(isNaN(_width) ? _buttonImage.width : _width, isNaN(_height) ? _buttonImage.height : _height);
			
			dispatchEvent(new Event( IMAGE_LOADED ));
		}
		
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		public function set image_url(url:String):void
		{
			if (AssetCache.hasAsset(url)){
				loadBitmap(AssetCache.getAsset(url) as Bitmap);
				_imageURL = url;
			}
			else
				loadRemoteImage(url);
		}
		public function get image_url():String
		{
			return _imageURL;
		}
		
		public function set hover_url(url:String):void
		{
			if (AssetCache.hasAsset(url)){
				loadHoverBitmap(AssetCache.getAsset(url) as Bitmap);
				_hoverURL = url				
			}
			else
				loadRemoteHoverImage(url);
		}
		public function get hover_url():String
		{
			return _hoverURL;
		}
		
		override public function set width(value:Number):void
		{
			resize(value, _height);
		}
		
		override public function set height(value:Number):void
		{
			resize(_width, value);
		}
		
		public function set hover_glow(value:Number):void
		{
			_glowColor = value;
		}
		
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		override public function getControlName():String { return 'image_button'; }
		
		override public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.fileVar('image_url', image_url, {preload:true}),
					ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('width', width, 100), 
					ConfigurableObjectUtils.numberVar('height', height, 32), 
					ConfigurableObjectUtils.fileVar('hover_url', hover_url),
					ConfigurableObjectUtils.colorVar('hover_glow', _glowColor, null, {desc:"A color to use in the rollover glow."}),
					ConfigurableObjectUtils.arrayVar('preload_urls', ['image_url'], null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('actions', _actions, null, {hidden:true, desc:"clicking on the button"})];
		}
		
		override public function getConfig():Object
		{
			return ConfigurableObjectUtils.getConfigObject(this);
		}
		
		override public function setConfig(config:Object):void
		{
			config = ConfigurableObjectUtils.decodeConfig( config, this );
			
			for (var configName:Object in config)
			{
				switch (configName)
				{
					case 'image_url':
						image_url = config[configName];
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
					case 'hover_url':
						hover_url = config[configName];
						break;
					case 'hover_glow':
						hover_glow = config[configName];
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