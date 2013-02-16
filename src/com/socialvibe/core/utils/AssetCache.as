package com.socialvibe.core.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	
	public class AssetCache
	{
		static private var _assetHash:Object = {};
		
		public static function storeAsset( url:String, asset:DisplayObject ):void
		{
			_assetHash[url] = asset;
		}
		
		// if you need a copy of a SWF asset, pass in a onAssetLoaded callback handler //
		public static function getAsset( url:String, onAssetLoaded:Function = null ):DisplayObject
		{
			if (_assetHash[url])
			{
				if (_assetHash[url] is Bitmap)
				{
					var b:Bitmap = new Bitmap(Bitmap(_assetHash[url]).bitmapData.clone());
					return b;
				}
				else if (onAssetLoaded != null)
				{
					var loader:Loader = new Loader();
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
						onAssetLoaded(loader.content);
					});
					var ba:ByteArray = new ByteArray();
					ba.writeBytes(DisplayObject(_assetHash[url]).loaderInfo.bytes, 0, DisplayObject(_assetHash[url]).loaderInfo.bytes.length);
					loader.loadBytes(ba);
					
					return loader;
				}
				
				return _assetHash[url] as DisplayObject;
			}
			
			return null;
		}
		
		public static function hasAsset( url:String ):Boolean
		{
			return _assetHash[url] ? true : false;
		}
	}
}