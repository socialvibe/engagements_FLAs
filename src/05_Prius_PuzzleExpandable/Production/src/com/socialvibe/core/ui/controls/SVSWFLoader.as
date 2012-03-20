package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	
	public class SVSWFLoader extends Sprite implements IConfigurableControl
	{
		public static const SWF_LOADED:String = "swfLoaded";
		
		protected var _width:Number;
		protected var _height:Number;
		protected var _origWidth:Number;
		protected var _origHeight:Number;
		
		protected var _url:String;
		protected var _swfLoader:Loader;
		protected var _swf:DisplayObject;
		
		protected var _actions:Array;
		protected var _effects:Array;
		
		public function SVSWFLoader(url:String = "")
		{
			if (url)
			{
				swf_url = url;
			}
			else
			{
				_width = 200;
				_height = 200;
				ConfigurableObjectUtils.addPlaceholder(this, getControlName(), _width, _height);
			}
		}
		
		protected function swfLoaded(e:Event):void
		{
			_swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
			
			addSWF(_swfLoader);
		}
		
		protected function addSWF(swf:DisplayObject):void
		{
			_swf = swf;
			addChild(_swf);
			
			_width = _origWidth = _swf.width;
			_height = _origHeight = _swf.height;
			
			dispatchEvent(new Event( SWF_LOADED ));
			
			dispatchEvent(new SVEvent(ConfigurableObjectUtils.TRIGGER_ACTION, _actions, true, true));
		}
		
		public function scaleSWF(w:Number, h:Number):void
		{
			if (!isNaN(w))
			{
				_width = w;
			}
			
			if (!isNaN(h))
			{
				_height = h;
			}
			
			if (_swf == null)
			{
				addEventListener(SWF_LOADED, function(e:Event):void {
					removeEventListener(SWF_LOADED, arguments.callee);
					scaleSWF(w, h);
				});
				return;
			}
			
			if (!isNaN(w))
			{
				_width = w;
				_swf.scaleX = (_width/_origWidth);
			}
			
			if (!isNaN(h))
			{
				_height = h;
				_swf.scaleY = (_height/_origHeight);
			}
		}
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		public function set swf_url(url:String):void
		{
			if (_url == url || url == "") return;
			
			ConfigurableObjectUtils.removePlaceholder(this);
			
			if (_swfLoader != null && _swfLoader.contentLoaderInfo.hasEventListener(Event.COMPLETE))
				_swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
			
			if (_swf && contains(_swf))
				removeChild(_swf);
			
			addEventListener(SWF_LOADED, function(e:Event):void {
				removeEventListener(SWF_LOADED, arguments.callee);
				dispatchEvent(new Event( ConfigurableObjectUtils.VARIABLE_CHANGED, true ));
			});
			
			_url = String(url);
			
			if (AssetCache.hasAsset(url))
			{
				AssetCache.getAsset(url, function(asset:DisplayObject):void {
					addSWF(asset);
				});
				
				_url = url;
			}
			else
			{
				_swfLoader = new Loader();
				_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded, false, 0, true);
				_swfLoader.load(new URLRequest(_url), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
			}
		}
		public function get swf_url():String
		{
			return _url;
		}
		
		override public function set width(value:Number):void
		{
			scaleSWF(value, NaN);
		}
		
		override public function set height(value:Number):void
		{
			scaleSWF(NaN, value);
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
		
		public function getControlName():String { return 'swf'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.fileVar('swf_url', swf_url, {preload:true}),
					ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('width', width), 
					ConfigurableObjectUtils.numberVar('height', height),
					ConfigurableObjectUtils.arrayVar('preload_urls', ['swf_url'], null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('actions', _actions, null, {hidden:true, desc:'when SWF is loaded'})];
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
					case 'swf_url':
						swf_url = config[configName];
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
					case 'actions':
						_actions = config[configName];
						break;
				}
			}
		}
	}
}