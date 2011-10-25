package com.socialvibe.core.utils
{
	import com.socialvibe.core.config.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.*;
	import flash.system.*;
	
	public class EmbeddedImage extends Bitmap
	{
		public static const EMBEDDED_IMAGES_LOADED:String = "embedded_images_loaded";
		
		public static var IMAGES:Object;
		public static var imagesLoader:Loader;
		public static var embeddedImagesLoaded:Boolean = false;
		public static var imagesLoadDispatcher:EventDispatcher = new EventDispatcher();
		
		private var _imgClassName:String;
		private var _loaded:Boolean;
		
		public function EmbeddedImage(imgClassName:String)
		{
			super();
			
			_imgClassName = imgClassName;
			
			if (embeddedImagesLoaded)
			{
				this.bitmapData = Bitmap(new IMAGES[_imgClassName]).bitmapData;
				_loaded = true;
			}
			else
			{
				imagesLoadDispatcher.addEventListener(EMBEDDED_IMAGES_LOADED, onEmbeddedImagesLoaded, false, 999, true);
			}
		}
		
		private function onEmbeddedImagesLoaded(e:Event):void
		{
			this.bitmapData = Bitmap(new IMAGES[_imgClassName]).bitmapData;
			_loaded = true;
		}
		
		public static function loadImageAssets():void
		{
			if (imagesLoader == null)
			{
				imagesLoader = new Loader();
				imagesLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function onEmbeddedImagesLoaded(e:Event):void {
					EmbeddedImage.IMAGES = e.target.applicationDomain.getDefinition("ImageAssets");
					EmbeddedImage.embeddedImagesLoaded = true;
					EmbeddedImage.imagesLoadDispatcher.dispatchEvent(new Event( EmbeddedImage.EMBEDDED_IMAGES_LOADED ));
				});
				imagesLoader.load(new URLRequest((Security.sandboxType == Security.LOCAL_TRUSTED ? '' : Services.S3_URL) + "ImageAssets.swf?5"));
			}
		}
		
		public function isLoaded():Boolean { return _loaded; }
		
		public static function getImage(imgClassName:String, color:Number = undefined):EmbeddedImage
		{
			var img:EmbeddedImage = new EmbeddedImage(imgClassName);
			if (!isNaN(color))
			{
				var tf:ColorTransform = img.transform.colorTransform;
				tf.color = color;
				img.transform.colorTransform = tf;
			}
			return img;
		}
		
		public static function getLevelStar(level:String):DisplayObject
		{
			switch (level)
			{
				case 'Gold':
					return getImage('goldLevelImg');
					break;
				case 'Platinum':
					return getImage('platinumLevelImg');
					break;
				case 'Diamond':
					/*
					if (CPUCalc.Speed == CPUCalc.FAST && IMAGES['gleamAni'])
					{
						var s:Sprite = new Sprite();
						s.addChild(getImage('diamondLevelImg'));
						var g:DisplayObject = DisplayObject(new IMAGES['gleamAni']);
						g.x = 16;
						g.y = 4;
						s.addChild(g);
						return s;
					}
					*/
					return getImage('diamondLevelImg');
					break;
				case 'Pink':
					return getImage('pinkLevelImg');
					break;
				case 'Black':
					return getImage('blackLevelImg');
					break;
			}
			return getImage('goldLevelImg');
		}
	}
}