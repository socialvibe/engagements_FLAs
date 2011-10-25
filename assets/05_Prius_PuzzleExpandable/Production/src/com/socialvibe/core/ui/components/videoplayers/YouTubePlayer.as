package com.socialvibe.core.ui.components.videoplayers
{
	import com.greensock.TweenLite;
	import com.socialvibe.core.ui.SVVideoPlayerControlsBase;
	import com.socialvibe.core.ui.components.SVVideoPlayer;
	import com.socialvibe.core.ui.controls.IConfigurableControl;
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	import com.socialvibe.core.utils.SVEvent;
	
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.Capabilities;
	import flash.system.LoaderContext;
	import flash.system.Security;
	import flash.system.SecurityDomain;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	public class YouTubePlayer extends Sprite implements IVideoPlayer 
	{
		private const YOUTUBE_LIBRARY_SWF:String = "http://media.socialvi.be/m/RSL/FlashYouTube.swf";
		
		private var _videoURL:String;
		private var _previewImageURL:String;
		private var _videoWidth:Number;
		private var _videoHeight:Number;
		private var _autoPlay:Boolean;
		private var _addPlayButton:Boolean;
		private var _showControls:Boolean;
		private var _loop:Boolean;
		
		private var _youtubeID:String;
		
		
		private var _intervalId:Number;
		private var _isDragging:Boolean;
		private var _controlHidden:Boolean = true;
		
		private var _videoHolder:Sprite;
		private var _hitArea:Sprite;
		private var _youtubeVideo:*;
		private var _videoControl:VideoControl;
		private var _loader:Loader;
		private var _sliderIntervalID:Number;
		
		private var YouTubeEvent:Class; 
		private var YouTubeError:Class;
		private var YouTubePlayingState:Class;
		private var FlashYouTube:Class;
		
		private var _mask:Sprite;
		private var _firstRun:Boolean = true;
		
		public function YouTubePlayer(videoURL:String = '', previewImgURL:String = '', videoWidth:Number = 300, videoHeight:Number = 225, autoPlayEnabled:Boolean = false, addPlayButton:Boolean = true, loop:Boolean = false, showControls:Boolean = true):void
		{
			
			_videoURL = videoURL;
			createYouTubeID();
			_previewImageURL = previewImgURL;
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
			_autoPlay = autoPlayEnabled;
			_addPlayButton = addPlayButton;
			_loop = loop;
			_showControls = showControls;
			
			_videoHolder = new Sprite();
			_hitArea = new Sprite();
			_hitArea.useHandCursor = _hitArea.buttonMode = true;
			_hitArea.mouseChildren = true;
			
			_loader = new Loader();
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onExternalLibraryLoaded, false, 0, true);
			
			if (Security.sandboxType == "localTrusted") {
				_loader.load(new URLRequest(YOUTUBE_LIBRARY_SWF), new LoaderContext(true, ApplicationDomain.currentDomain));
			} else {
				_loader.load(new URLRequest(YOUTUBE_LIBRARY_SWF), new LoaderContext(true, ApplicationDomain.currentDomain, SecurityDomain.currentDomain));
			}
		}
		
		private function createYouTubeID():void
		{
			var regex:RegExp = /youtube\.com\/watch\?v=([^&\/]+)/;
			var regexResult:String = regex.exec(_videoURL);
			_youtubeID = regexResult.split(",")[1].toString();
		}
		
		private function onExternalLibraryLoaded(e:Event):void
		{
			//Libraries from com.youtube.* should have laoded.
			YouTubeEvent = (_loader.contentLoaderInfo.applicationDomain.getDefinition("com.youtube.YouTubeEvent") as Class);
			YouTubeError = (_loader.contentLoaderInfo.applicationDomain.getDefinition("com.youtube.YouTubeError") as Class);
			YouTubePlayingState = (_loader.contentLoaderInfo.applicationDomain.getDefinition("com.youtube.YouTubePlayingState") as Class);
			FlashYouTube = (_loader.contentLoaderInfo.applicationDomain.getDefinition("com.youtube.FlashYouTube") as Class)
			
			_youtubeVideo = new FlashYouTube();
			_youtubeVideo.addEventListener(YouTubeEvent.PLAYER_LOADED, youtubeHandlePlayerLoaded, false, 0, true);
			_videoHolder.addChild(_youtubeVideo);
			
			if (_showControls) { 
				setupControls();
				_sliderIntervalID = setInterval(updateHead, 200);
				maskOutControls();
			}
			
			if (_autoPlay) {
				if (_videoControl) {
					_videoControl.play();
				} else {
					play();
				}
			}
		}
		
		
		public function onAddedToStage(e:Event):void {
			//DO nothing, since we must wait for youtube to load.
			
			if (!hasEventListener(Event.REMOVED_FROM_STAGE))
				addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
		}
		
		protected function onRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			
			kill();
		}
		
		public function init():void
		{
			this.addChild(_videoHolder);
		}
		
		public function kill():void
		{
			if (_youtubeVideo) {
				_youtubeVideo.destroy();
			}
			
			this.removeChild(_videoHolder);
		}
		
		public function play():void
		{
			if (_youtubeVideo)
				_youtubeVideo.playVideo();
		}
		public function pause():void
		{
			if (_youtubeVideo)
				_youtubeVideo.pauseVideo();
		}
		public function resume():void
		{
			if (_youtubeVideo) 
				_youtubeVideo.playVideo();
		}
		public function restart():void
		{
			_youtubeVideo.seekTo(0);
		}
		
		public function isMovieEnded():Boolean
		{
			return (Math.round(current_time) >= Math.round(total_time));
		}
		
		public function get total_time():Number
		{
			return _youtubeVideo.getDuration();
		}
		
		public function get current_time():Number
		{
			return _youtubeVideo.getCurrentTime();
		}
		
		override public function set width(value:Number):void
		{
			_videoWidth = value;
			setVideoSize();
		}
		override public function get width():Number{ return _videoWidth; }
		override public function set height(value:Number):void
		{
			_videoHeight = value;
			setVideoSize();
		}
		override public function get height():Number{ return _videoHeight; }
		public function get video_url():String { return _videoURL; }
		public function set video_url(value:String):void {
			_videoURL = value;
			
			if (_autoPlay) {
				_youtubeVideo.loadVideoById(_youtubeID, 0, "highres");
			} else {
				_youtubeVideo.cueVideoById(_youtubeID, 0, "highres");
			}
		}	
		public function set preview_url(img:String):void{}
		public function get preview_url():String{ return null; }
		public function set auto_play(value:Boolean):void
		{
			_autoPlay = value;
		}
		
		//Utility
		private function maskOutControls():void
		{
			if (!_mask) {
				_mask = new Sprite();
				_videoHolder.addChild(_mask);
			}
			_mask.graphics.clear();
			_mask.graphics.beginFill(0x123456);
			_mask.graphics.drawRect(0,0,_videoWidth, _videoHeight);
			
			
			_videoHolder.mask = _mask;
		}
		public function disableControls():void{}
		public function cropSourceVideo( cropArea:Rectangle):void{}
		
		private function updateHead():void
		{
			if (_youtubeVideo && _videoControl) {
				_videoControl.headPosition = _youtubeVideo.getCurrentTime()/_youtubeVideo.getDuration();
			}
			
			dispatchEvent(new Event(SVVideoPlayer.VIDEO_PROGRESS, true, true));
		}
		
		protected function setupControls():void
		{
			_videoControl = new VideoControl(_videoWidth);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.PAUSE, onPause, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.PLAY, onPlay, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.SOUND_OFF, soundOff, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.SOUND_ON, soundOn, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.START_OVER, onStartOver, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.DRAGGED, onDragged, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.DRAG_START, onDragStart, false, 0, true);
			_videoControl.x = 0;
			_videoControl.y = _videoHeight;
			_videoHolder.addChild(_videoControl);
		}
		
		private function setVideoSize():void
		{
			if (_youtubeVideo) {
				_youtubeVideo.setSize(_videoWidth, _videoHeight);
			}
			if (_showControls) {
				buildHitAreaForOverridingYouTubeMouseActions();
				maskOutControls();
			}
		}
		
		private function buildHitAreaForOverridingYouTubeMouseActions():void
		{
			if (_hitArea) {
				_hitArea.graphics.clear();
				_hitArea.graphics.beginFill(0x123456, 0);
				_hitArea.graphics.drawRect(0, 0, _videoWidth, _videoHeight);
				_hitArea.graphics.endFill();
			}
		}
		
		//Events
		protected function showControl(e:Event = null):void 
		{
			if (_controlHidden) {
				_controlHidden = false;
				if (_videoControl != null) {
					TweenLite.killTweensOf(_videoControl);
					TweenLite.to(_videoControl, 1,{ y: _videoHeight -  _videoControl.height, onCompleteParams:[this], onComplete: function(target:Object):void { target._controlHidden = false;}});
				}
			}
			
			clearInterval(_intervalId);
			_intervalId = setInterval(hideControl, 3000);
		}
		
		protected function hideControl(e:Event = null):void 
		{
			if (_videoControl == null) return;
			
			if (!_controlHidden) {
				_controlHidden = true;
				TweenLite.killTweensOf(_videoControl);
				TweenLite.to(_videoControl, 1, {y:_youtubeVideo.height, onCompleteParams:[this], onComplete: function(target:Object):void { target._controlHidden = true;}});
			}
			clearInterval(_intervalId);
		}
		
		protected function onPlay(e:Event):void
		{
			play();
		}
		
		protected function onPause(e:Event):void
		{
			pause();
		}
		
		protected function onStartOver(e:Event):void
		{
			restart();
		}
		
		protected function onDragStart(e:Event):void
		{
			_isDragging = true;
			clearInterval(_sliderIntervalID);
		}
		
		protected function onDragged(e:DataEvent):void
		{
			_youtubeVideo.seekTo(Number(e.data)*_youtubeVideo.getDuration());
			if (_videoControl.isPlaying()) {
				resume();
			}
			_isDragging = false;
			_sliderIntervalID = setInterval(updateHead, 200);
		}
		
		protected function soundOn(e:Event):void 
		{
			_youtubeVideo.unMute();
		}
		
		protected function soundOff(e:Event):void
		{
			_youtubeVideo.mute();
		}
		private function youtubeHandlePlayerLoaded(event:*):void
		{
			if (_autoPlay) {
				_youtubeVideo.loadVideoById(_youtubeID, 0, "highres");
			} else {
				_youtubeVideo.cueVideoById(_youtubeID, 0, "highres");
			}
			
			setVideoSize();
			
			_youtubeVideo.addEventListener(YouTubeEvent.STATUS, youtubeHandlePlayingState);
			_youtubeVideo.addEventListener(YouTubeEvent.ERROR, youtubeHandleError);
			
		
			init();
		}
		
		private function youtubeHandlePlayingState(event:*):void{
			
			switch(event.playerState){
				case YouTubePlayingState.BUFFERING:
					break;
				case YouTubePlayingState.UNSTARTED:
					break;
				case YouTubePlayingState.PLAYING:
					if (_firstRun) {
						dispatchEvent(new SVEvent(SVVideoPlayer.VIDEO_STARTED, _videoURL, true, true));
						if (_showControls && _videoControl) {
							showControl();
							_hitArea.addEventListener(MouseEvent.MOUSE_OVER, showControl);
						}
						_firstRun = false;
					}
					
					if (!_videoHolder.contains(_hitArea)){
						if (_videoControl) {
							_videoHolder.addChildAt(_hitArea, _videoHolder.getChildIndex(_videoControl));
						} else {
							_videoHolder.addChild(_hitArea);
						}
					}
					
					break;
				case YouTubePlayingState.PAUSE:
					break;
				case YouTubePlayingState.VIDEO_CUED:
					break;
				case YouTubePlayingState.VIDEO_ENDED:
					this.dispatchEvent(new SVEvent(SVVideoPlayer.VIDEO_COMPLETED, _videoURL, true, true));
					
					if (_loop) {
						_youtubeVideo.seekTo(0);
					}
					break;
				default:
					//"uh what happens?? " + event.playerState;
					break;
			}
		}
		
		private function youtubeHandleError(event:*):void{
			
			switch(event.errorCode){
				case YouTubeError.VIDEO_NOT_FOUND:
					break;
				case YouTubeError.VIDEO_NOT_ALLOWED:
					break;
				case YouTubeError.EMBEDDING_NOT_ALLOWED:
					break;      
				default:
					break;
			}
		}
		
	}
}