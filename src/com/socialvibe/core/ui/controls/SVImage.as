package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.LoaderContext;
	
	public class SVImage extends Sprite implements IConfigurableControl
	{
		public static const IMAGE_LOADED:String = "imageLoaded";
		
		protected var _width:Number;
		protected var _height:Number;
		protected var _origWidth:Number;
		protected var _origHeight:Number;
		
		protected var _url:String;
		protected var _img:DisplayObject;
		protected var _imgLoader:Loader;
		
		protected var _imageMask:Sprite;
		protected var _curveSize:Number;
		
		protected var _effects:Array;
		
		public function SVImage(url:String = "")
		{
			_curveSize = 0;
			
			if (url)
			{
				imageURL = url;
			}
			else
			{
				_width = 200;
				_height = 200;
				ConfigurableObjectUtils.addPlaceholder(this, getControlName(), _width, _height);
			}
		}
		
		public function set imageURL(url:String):void
		{
			if (_url && _url == url) return;
			
			clearImage();
			_url = url;
			
			if (_imgLoader != null && _imgLoader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
			{
				_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgLoadErr);
				_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			}
			
			if (url)
			{
				_imgLoader = new Loader();
				_imgLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imgLoadErr, false, 0, true);
				_imgLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, imgLoaded, false, 0, true);
				_imgLoader.load(new URLRequest(url), new LoaderContext(true));
			}
		}
		
		protected function imgLoaded(e:Event):void
		{
			_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgLoadErr);
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
			
			try {
				var img:Bitmap = Bitmap(_imgLoader.content);
				img.smoothing = true;
				addImage(img);
			} catch (err:Error) {
				addImage(_imgLoader); // loading an img outside the security sandbox
			}
		}
		
		protected function addImage(img:DisplayObject):void
		{
			_img = img;
			addChild(_img);
			
			_width = _origWidth = _img.width;
			_height = _origHeight = _img.height;
			
			dispatchEvent(new Event( IMAGE_LOADED ));
		}
		
		protected function imgLoadErr(e:IOErrorEvent):void
		{
			_imgLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, imgLoadErr);
			_imgLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, imgLoaded);
		}
		
		public function scaleImage(w:Number, h:Number):void
		{
			if (!isNaN(w))
			{
				_width = w;
			}
			
			if (!isNaN(h))
			{
				_height = h;
			}
			
			if (_img == null)
			{
				addEventListener(IMAGE_LOADED, function(e:Event):void {
					removeEventListener(IMAGE_LOADED, arguments.callee);
					scaleImage(w, h);
				}, false, 99);
				return;
			}
			
			if (!isNaN(w))
			{
				_img.scaleX = (_width/_origWidth);
			}
			
			if (!isNaN(h))
			{
				_img.scaleY = (_height/_origHeight);
			}
		}
		
		public function roundCorners(size:Number):void
		{
			if (_img == null)
			{
				addEventListener(IMAGE_LOADED, function(e:Event):void {
					removeEventListener(IMAGE_LOADED, arguments.callee);
					roundCorners(size);
				});
				return;
			}
			
			_curveSize = size;
			
			if (_imageMask && contains(_imageMask)) {
				removeChild(_imageMask);
			}
			_imageMask = new Sprite();
			_imageMask.graphics.beginFill(0, 1);
			_imageMask.graphics.drawRoundRect(0, 0, width, height, _curveSize);
			addChild(_imageMask);
			mask = _imageMask;
		}
		
		public function clearImage():void
		{
			while (numChildren > 0)
				removeChildAt(0);
			
			ConfigurableObjectUtils.removePlaceholder(this);
			
			_url = null;
			_img = null;
		}
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		public function set image_url(url:String):void
		{
			clearImage();
			
			addEventListener(IMAGE_LOADED, function(e:Event):void {
				removeEventListener(IMAGE_LOADED, arguments.callee);
				_img.dispatchEvent(new Event( ConfigurableObjectUtils.VARIABLE_CHANGED, true ));
			});
			
			if (AssetCache.hasAsset(url))
			{
				var cachedAsset:Bitmap = AssetCache.getAsset(url) as Bitmap;
				cachedAsset.smoothing = true;
				addImage(cachedAsset);
				
				_url = url;
			}
			else
			{
				imageURL = url;
			}
		}
		public function get image_url():String
		{
			return _url;
		}
		
		override public function set width(value:Number):void
		{
			scaleImage(value, NaN);
		}
		
		override public function set height(value:Number):void
		{
			scaleImage(NaN, value);
		}
		
		override public function get width():Number
		{
			return isNaN(_width) ? super.width : _width;
		}
		
		override public function get height():Number
		{
			return isNaN(_height) ? super.height : _height;
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'image'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.fileVar('image_url', image_url, {preload:true}),
					ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('width', width), 
					ConfigurableObjectUtils.numberVar('height', height),
					ConfigurableObjectUtils.arrayVar('preload_urls', ['image_url'], null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true})];
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
					case 'effects':
						_effects = config[configName];
						break;
				}
			}
		}
	}
}