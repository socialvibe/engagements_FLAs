package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.*;
	
	import flash.display.Bitmap;
	import flash.display.BlendMode;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class SVVideoVotePreview extends Sprite implements IConfigurableControl
	{
		[Embed(source="assets/images/video/play_button.png")]
		public var playBtnImg:Class;
		
		public static const WATCH_MOVIE:String = "clickedOnSVVideoVotePreview";
		
		protected var _imageURL:String;
		protected var _videoURL:String;
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _buttonImage:Bitmap;
		protected var _rollover:Bitmap;
		protected var _playButton:Bitmap;
		protected var _videoLabel:String;
		
		protected var _watched:Boolean = false;
		
		protected var _effects:Array;
		
		public function SVVideoVotePreview(width:Number = 200, height:Number = 50)
		{
			_width = width;
			_height = height;
			
			init();
		}
		
		
		protected function init():void
		{
			ConfigurableObjectUtils.addPlaceholder(this, getControlName(), _width, _height);
		}
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		public function set video_url(value:String):void
		{
			_videoURL = value;
		}
		
		override public function set height(value:Number):void
		{
			resize(_width, value);
		}
		
		override public function get height():Number
		{
			return _height;
		}
		
		override public function set width(value:Number):void
		{
			resize(value, _height);
		}
		
		override public function get width():Number
		{
			return _width;
		}
		
		public function set video_label(value:String):void
		{
			_videoLabel = value;
		}
		
		public function get video_label():String
		{
			return _videoLabel;
		}
		
		public function set preview_image(url:String):void
		{
			if (AssetCache.hasAsset(url))
			{
				loadBitmap(AssetCache.getAsset(url) as Bitmap);
				_imageURL = url;
			}
			else
				loadRemoteImage(url);
		}
		
		public function get preview_image():String
		{
			return _imageURL;
		}
		
		public function set watched(value:Boolean):void
		{
			_watched = value;
		}
		
		public function get watched():Boolean
		{
			return _watched;
		}
		
		public function get video_url():String
		{
			return _videoURL;
		}
		
		public function set beingWatched(value:Boolean):void
		{
			if (_playButton) {
				_playButton.visible = !value;
			}
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
		
		/* =============================
		Event Handlers
		============================= */
		private function onRollOver(e:Event):void
		{
			if (!_buttonImage) {
				return;
			}
			
			_rollover.visible = true;
		}
		
		private function onRollOut(e:Event):void
		{
			if (!_buttonImage) {
				return;
			}
			_rollover.visible = false;
		}
		
		private function onClick(e:Event):void
		{
			if (!_buttonImage) {
				return;
			}
			
			_watched = true;
			
			this.dispatchEvent(new SVEvent(WATCH_MOVIE, _videoURL, true, false));
		}
		
		/* =============================
		Interface Implementations
		============================= */
		
		public function getControlName():String { return "video_preview_button"; }
		
		public function getConfigVars():Array 
		{
			return [
					ConfigurableObjectUtils.numberVar('width', width, _width), 
					ConfigurableObjectUtils.numberVar('height', height, _height),
					ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y),
					ConfigurableObjectUtils.stringVar('video_label', video_label),
					ConfigurableObjectUtils.fileVar('preview_image', preview_image, {preload:true}),
					ConfigurableObjectUtils.stringVar('video_url', video_url),
					ConfigurableObjectUtils.arrayVar('preload_urls', ['preview_image'], null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true})];
		}
		
		public function getConfig():Object
		{
			return ConfigurableObjectUtils.getConfigObject(this);
		}
		
		public 	function setConfig(config:Object):void
		{
			config = ConfigurableObjectUtils.decodeConfig( config, this );
			
			for (var configName:Object in config)
			{
				switch (configName)
				{
					case 'width':
						width = config[configName];
						break;
					case 'height':
						height = config[configName];
						break;
					case 'x':
						x = config[configName];
						break;
					case 'y':
						y = config[configName];
						break;
					case 'video_label':
						video_label = config[configName];
						break;
					case 'video_url':
						video_url = config[configName];
						break;
					case 'preview_image':
						preview_image = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
				}
			}
		}
		
		/* =============================
		Utility Functions
		============================= */	
		protected function onImageLoaded():void
		{
			ConfigurableObjectUtils.removePlaceholder(this);
			
			//No Repeats
			if (!this.hasEventListener(MouseEvent.ROLL_OVER))
			{
				this.buttonMode = this.useHandCursor = true;
				this.addEventListener(MouseEvent.ROLL_OVER, onRollOver);
				this.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
				this.addEventListener(MouseEvent.CLICK, onClick);
			}
			
			_buttonImage.smoothing = true;
			
			addChildAt(_buttonImage, 0);
			
			_rollover = new Bitmap(_buttonImage.bitmapData.clone());
			_rollover.alpha = 0.5;
			_rollover.blendMode = BlendMode.MULTIPLY;
			_rollover.visible = false;
			addChild(_rollover);
			
			resize(_width, _height);
		}
		
		public function resize(width:Number, height:Number):void
		{
			_width = width;
			_height = height;
			
			if (_buttonImage)
			{
				if (!isNaN(_width))
					_buttonImage.scaleX = _rollover.scaleX = _width / (_buttonImage.width / _buttonImage.scaleX);
				
				if (!isNaN(_height))
					_buttonImage.scaleY = _rollover.scaleY = _height / (_buttonImage.height / _buttonImage.scaleY);
			}
			
			if (_buttonImage) {
				if (!_playButton) {
					_playButton = new playBtnImg() as Bitmap;
					_buttonImage.parent.addChild(_playButton);
				}
				_playButton.scaleX = _playButton.scaleY = (_height/1.75) / ( _playButton.height / _playButton.scaleY ); 
				_playButton.x = _buttonImage.width/2 - _playButton.width/2;
				_playButton.y = _buttonImage.height/2 - _playButton.height/2;
			}
			
		}
	}
}