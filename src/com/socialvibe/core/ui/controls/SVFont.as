package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.system.*;
	import flash.text.*;
	import flash.utils.*;
	
	public class SVFont extends SVSWFLoader implements IConfigurableControl
	{
		public function SVFont(url:String = "")
		{
			if (url)
			{
				swf_url = url;
			}
			else
			{
				_width = 36;
				_height = 24;
				ConfigurableObjectUtils.addPlaceholder(this, getControlName(), _width, _height);
			}
		}
		
		override protected function swfLoaded(e:Event):void
		{
			_swfLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, swfLoaded);
			
			addFont(_swfLoader.content);
		}
		
		protected function addFont(swf:DisplayObject):void
		{
			var FontAsset:Class = LoaderInfo(swf.loaderInfo).applicationDomain.getDefinition(getQualifiedClassName( swf )) as Class;
			
			Font.registerFont(FontAsset.FontClass);
			SVText.setDefaultCustomFont('CustomFontName');
		}
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		override public function set swf_url(url:String):void
		{
			if (_url == url || !url) return;
			
			ConfigurableObjectUtils.removePlaceholder(this);
			
			_url = String(url);
			
			if (AssetCache.hasAsset(url))
			{
				AssetCache.getAsset(url, function(asset:DisplayObject):void {
					addFont(asset);
				});
			}
			else
			{
				_swfLoader = new Loader();
				_swfLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, swfLoaded, false, 0, true);
				_swfLoader.load(new URLRequest(_url), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
			}
		}
		override public function get swf_url():String
		{
			return _url;
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		override public function getControlName():String { return 'font'; }

	}
}