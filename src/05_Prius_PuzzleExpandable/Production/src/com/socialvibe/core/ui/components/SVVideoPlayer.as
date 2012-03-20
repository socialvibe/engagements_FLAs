package com.socialvibe.core.ui.components
{
	import com.socialvibe.core.ui.components.videoplayers.IVideoPlayer;
	import com.socialvibe.core.ui.components.videoplayers.VideoPlayer;
	import com.socialvibe.core.ui.components.videoplayers.YouTubePlayer;
	import com.socialvibe.core.ui.controls.IConfigurableControl;
	import com.socialvibe.core.ui.IStartableControl;
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	import com.socialvibe.core.utils.SVEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	public class SVVideoPlayer extends Sprite implements IConfigurableControl, IStartableControl
	{
		static public const VIDEO_STARTED:String 	= 'videoStarted';
		static public const VIDEO_COMPLETED:String 	= 'videoCompleted';
		static public const VIDEO_PROGRESS:String 	= 'videoProgress';
		
		static public const VIDEO_FIRST_QUARTILE:String = 'videoFirstQuartile';
		static public const VIDEO_MIDPOINT:String 		= 'videoMidpoint';
		static public const VIDEO_THIRD_QUARTILE:String = 'videoThirdQuartile';
		
		protected var _videoURL:String;
		protected var _previewImageURL:String;
		protected var _videoWidth:Number;
		protected var _videoHeight:Number;
		protected var _autoPlay:Boolean;
		protected var _addPlayButton:Boolean;
		protected var _showControls:Boolean;
		protected var _loop:Boolean;
		
		protected var _actions:Array;
		protected var _effects:Array;
		
		protected var _firstQuartilePast:Boolean;
		protected var _midpointPast:Boolean;
		protected var _thirdQuartilePast:Boolean;
		
		protected var _currentPlayer:IVideoPlayer;
		
		public function SVVideoPlayer(videoURL:String = '', previewImgURL:String = '', videoWidth:Number = 300, videoHeight:Number = 225, autoPlayEnabled:Boolean = true, addPlayButton:Boolean = true, loop:Boolean = false, showControls:Boolean = true)
		{
			_videoURL = videoURL;
			_previewImageURL = previewImgURL;
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
			_autoPlay = autoPlayEnabled;
			_addPlayButton = addPlayButton;
			_loop = loop;
			_showControls = showControls;
			
			
			var regex:RegExp = /youtube\.com\/watch\?v=([^&\/]+)/;
			var regexResult:String = regex.exec(_videoURL);
			
			if (regexResult) {
				//Youtube
				_currentPlayer = new YouTubePlayer(_videoURL, _previewImageURL, _videoWidth, _videoHeight, _autoPlay, _addPlayButton, _loop, _showControls);				
			} else {
				//Normal HTML
				_currentPlayer = new VideoPlayer(_videoURL, _previewImageURL, _videoWidth, _videoHeight, _autoPlay, _addPlayButton, _loop, _showControls);
			}
			
			addEventListener( VIDEO_STARTED, onStarted, false, 0, true );
			addEventListener( VIDEO_PROGRESS, onProgress, false, 0, true );
			addEventListener( VIDEO_COMPLETED, onCompleted, false, 0, true );
			
			if (!_videoURL && !_previewImageURL)
				ConfigurableObjectUtils.addPlaceholder(this, getControlName(), width, height);
			else
				init();
			
			addEventListener( Event.ADDED_TO_STAGE, onAddedToStage, false, 0, true );		
		}
		
		protected function init():void
		{
			addChild(_currentPlayer as Sprite);
			_currentPlayer.init();
		}
		
		protected function onAddedToStage(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, onAddedToStage );
			
			addChild(_currentPlayer as Sprite);
			_currentPlayer.onAddedToStage(e); 
		}
		
		protected function onStarted(e:Event):void
		{
			_firstQuartilePast = false;
			_midpointPast = false;
			_thirdQuartilePast = false;
		}
		
		protected function onProgress(e:Event):void
		{
			var progress:Number = current_time / total_time;
			
			if (!_firstQuartilePast && progress >= 0.25)
			{
				_firstQuartilePast = true;
				dispatchEvent(new Event(VIDEO_FIRST_QUARTILE, true, true));
			}
			else if (!_midpointPast && progress >= 0.50)
			{
				_midpointPast = true;
				dispatchEvent(new Event(VIDEO_MIDPOINT, true, true));
			}
			else if (!_thirdQuartilePast && progress >= 0.75)
			{
				_thirdQuartilePast = true;
				dispatchEvent(new Event(VIDEO_THIRD_QUARTILE, true, true));
			}
		}
		
		protected function onCompleted(e:Event):void
		{
			dispatchEvent(new SVEvent(ConfigurableObjectUtils.TRIGGER_ACTION, _actions, true, true));
		}
		
		public function kill():void{ _currentPlayer.kill(); }
		public function play():void{ _currentPlayer.play(); }
		public function pause():void{ _currentPlayer.pause(); }
		public function resume():void{ _currentPlayer.resume(); }
		public function cropSourceVideo( cropArea:Rectangle ):void { _currentPlayer.cropSourceVideo(cropArea); }
		public function isMovieEnded():Boolean { return _currentPlayer.isMovieEnded(); }
		
		// IStartable implementation //
		public function start():void{ _currentPlayer.play(); }
		public function stop():void{ _currentPlayer.pause(); }
		public function restart():void{ _currentPlayer.restart(); }
		
		
		public function get total_time():Number { return _currentPlayer.total_time; }
		public function get current_time():Number { return _currentPlayer.current_time; }
		
		public function get video_url():String{ return _currentPlayer.video_url }
		public function set video_url(value:String):void {
			ConfigurableObjectUtils.removePlaceholder(this);
			
			_videoURL = value;
			createPlayer();
		}
		
		public function get preview_url():String { return _currentPlayer.preview_url; }
		public function set preview_url(value:String):void {
			ConfigurableObjectUtils.removePlaceholder(this);
			
			_currentPlayer.preview_url = _previewImageURL = value;
		}
		public function set auto_play(value:Boolean):void { _currentPlayer.auto_play = _autoPlay = value; }
		public function get auto_play():Boolean { return _autoPlay; }
		
		override public function get width():Number { return _currentPlayer.width; }
		override public function set width(value:Number):void
		{
			_currentPlayer.width = _videoWidth = value;
			
			if (!_videoURL && !_previewImageURL)
				ConfigurableObjectUtils.addPlaceholder(this, getControlName(), _videoWidth, _videoHeight);
		}
		
		override public function get height():Number { return _currentPlayer.height; }
		override public function set height(value:Number):void
		{
			_currentPlayer.height = _videoHeight = value;
			
			if (!_videoURL && !_previewImageURL)
				ConfigurableObjectUtils.addPlaceholder(this, getControlName(), _videoWidth, _videoHeight);
		}
		
		public function disableControls():void { _currentPlayer.disableControls(); }
		
		private function createPlayer():void
		{
			if (_currentPlayer)
			{
				_currentPlayer.kill();
				if (Sprite(_currentPlayer).parent)
					Sprite(_currentPlayer).parent.removeChild(_currentPlayer as Sprite);
				_currentPlayer = null;
			}
			
			var regex:RegExp = /youtube\.com\/watch\?v=([^&\/]+)/;
			var regexResult:String = regex.exec(_videoURL);
			
			if (regexResult) {
				//Youtube
				_currentPlayer = new YouTubePlayer(_videoURL, '', _videoWidth, _videoHeight, _autoPlay, _addPlayButton, _loop, _showControls);
				init();
			} else {
				//Normal HTML
				_currentPlayer = new VideoPlayer(null, null, _videoWidth, _videoHeight, _autoPlay, _addPlayButton, _loop, _showControls);
				addChild(_currentPlayer as Sprite);
				
				_currentPlayer.preview_url = _previewImageURL;
				_currentPlayer.video_url = _videoURL;
			}
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'video'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.stringVar('video_url', video_url),
					ConfigurableObjectUtils.fileVar('preview_url', preview_url),
					ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('width', width, 300), 
					ConfigurableObjectUtils.numberVar('height', height, 225), 
					ConfigurableObjectUtils.booleanVar('auto_play', _autoPlay, false),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('actions', _actions, null, {hidden:true, desc:"upon video completion"})];
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
					case 'video_url':
						video_url = config[configName];
						break;
					case 'preview_url':
						preview_url = config[configName];
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
					case 'auto_play':
						auto_play = config[configName];
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