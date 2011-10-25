package com.socialvibe.core.ui.components.videoplayers
{
	import com.greensock.TweenLite;
	import com.socialvibe.core.ui.SVVideoPlayerControlsBase;
	import com.socialvibe.core.ui.components.SVVideoPlayer;
	import com.socialvibe.core.ui.controls.*;
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	import com.socialvibe.core.utils.SVEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.media.SoundTransform;
	import flash.media.Video;
	import flash.net.*;
	import flash.system.LoaderContext;
	import flash.text.*;
	import flash.utils.*;
	
	public class VideoPlayer extends Sprite implements IVideoPlayer
	{
		[Embed(source="assets/images/video/play_button.png")]
		public var playBtnImg:Class;
		
		protected var _videoURL:String;
		protected var _previewImageURL:String;
		protected var _videoControl:SVVideoPlayerControlsBase;
		protected var _noKill:Boolean;
		protected var _player:Video;
		protected var _stream:NetStream;
		protected var _netConnection:NetConnection;
		protected var _mask:Sprite;
		protected var _sourceCrop:Rectangle;
		
		protected var _noControls:Boolean;
		protected var _showControls:Boolean;
		protected var _controlHidden:Boolean;
		protected var _intervalId:Number;
		protected var _playInterval:Number;
		
		protected var _loading:SVText;
		protected var _previewImg:SVImage;
		protected var _playButton:Bitmap;
		
		protected var _videoDuration:Number;
		
		protected var _videoWidth:Number;
		protected var _videoHeight:Number;
		
		protected var _autoPlay:Boolean;
		protected var _addPlayButton:Boolean;
		protected var _isDragging:Boolean;
		protected var _loop:Boolean;
		
		public function VideoPlayer(videoURL:String = '', previewImgURL:String = '', videoWidth:Number = 300, videoHeight:Number = 225, autoPlayEnabled:Boolean = false, addPlayButton:Boolean = true, loop:Boolean = false, showControls:Boolean = true)
		{
			_videoURL = videoURL;
			_previewImageURL = previewImgURL;
			_videoWidth = videoWidth;
			_videoHeight = videoHeight;
			_autoPlay = autoPlayEnabled;
			_addPlayButton = addPlayButton;
			_loop = loop;
			_showControls = showControls;		
		}
		
		public function onAddedToStage(e:Event):void			
		{
			if (_autoPlay)
				onStartPlay();
		}
		
		public function init():void
		{
			
			drawBackground();
			
			if (_previewImageURL || preview_url)
				addPreview();
		}
		
		public function drawBackground():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			
			g.beginFill(0x000000, 1);
			g.drawRect(0, 0, _videoWidth, _videoHeight);
			
			if (_mask && contains(_mask))
				removeChild(_mask);
			
			_mask = new Sprite();
			_mask.graphics.beginFill(0x123456, 1);
			_mask.graphics.drawRect(0, 0, _videoWidth, _videoHeight);
			addChild(_mask);
			mask = _mask;
		}
		
		protected function addPreview():void
		{
			if (_previewImg == null)
			{
				_previewImg = new SVImage(_previewImageURL);
				_previewImg.scaleImage(_videoWidth, _videoHeight);
				_previewImg.addEventListener(SVImage.IMAGE_LOADED, function(e:Event):void {
					
					_previewImg.useHandCursor = _previewImg.buttonMode = true;
					_previewImg.addEventListener(MouseEvent.CLICK, onStartPlay, false, 0, true);
					
					if (_addPlayButton)
					{
						_playButton = new playBtnImg() as Bitmap;
						_playButton.x = _videoWidth/2 - _playButton.width/2;
						_playButton.y = _videoHeight/2 - _playButton.height/2;
						_previewImg.addChild(_playButton);
					}
				});
				_previewImg.addEventListener(ConfigurableObjectUtils.VARIABLE_CHANGED, function(e:Event):void {
					e.stopImmediatePropagation();
				}, false, 1, false);
				
			}
			addChild(_previewImg);
			_previewImg.visible = true;
		}
		
		public function kill():void 
		{
			clearTimeout(_playInterval);
			
			if (_stream)
			{
				_stream.pause();
				_stream.close();
			}
			
			if (_player && contains(_player))
				removeChild(_player);
			
			if (_videoControl && contains(_videoControl))
				removeChild(_videoControl);
			
			if (_netConnection)
			{
				_netConnection.removeEventListener(NetStatusEvent.NET_STATUS, netStatusHandler);
				_netConnection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
				_netConnection.close();
			}
		}
		
		public function play():void
		{
			if (_previewImg && _previewImg.visible)
				onStartPlay();
			else
				resume();
		}
		
		public function pause():void
		{
			if (_videoControl) {
				_videoControl.pause();
			}
		}
		
		public function resume():void
		{
			if ((_previewImg && _previewImg.visible) || _videoControl == null)
				onStartPlay();
			else
				_videoControl.play();
		}
		
		public function restart():void
		{
			_stream.seek(0);
			_stream.resume();
		}
		
		public function cropSourceVideo( cropArea:Rectangle ):void
		{
			_sourceCrop = cropArea;
		}
		
		public function get video():Video
		{
			return _player;
		}
		
		protected function onStartPlay(e:Event = null):void 
		{
			if (!_videoURL || !stage)
				return;
			
			if (!hasEventListener(Event.REMOVED_FROM_STAGE))
				addEventListener(Event.REMOVED_FROM_STAGE, onRemoved, false, 0, true);
			
			if (_previewImg)
				_previewImg.visible = false;
			
			if (_loading == null)
			{
				_loading = new SVText('    Loading...', 0, (_videoHeight-30)/2, 30*(_videoWidth/720), false, 0x999999, _videoWidth);
				_loading.autoSize = TextFieldAutoSize.CENTER;
				addChild(_loading);
			}
			
			_netConnection = new NetConnection();
			if (!_netConnection.hasEventListener(NetStatusEvent.NET_STATUS))
			{
				_netConnection.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
				_netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler, false, 0, true);
			}
			_netConnection.client = this;
			_netConnection.connect(null);
			
			dispatchEvent(new SVEvent(SVVideoPlayer.VIDEO_STARTED, _videoURL, true, true));
		}
		
		protected function onRemoved(e:Event):void
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemoved);
			addEventListener(Event.ADDED_TO_STAGE, onReaddedToStage);
			
			if (_stream)
				_stream.pause();
			
			if (_noKill == false)
				kill();
		}
		
		protected function netStatusHandler(e:NetStatusEvent):void 
		{
			switch (e.info.code) {
				case "NetConnection.Connect.Success":
					connectStream();
					break;
				case "NetStream.Play.StreamNotFound":
					dispatchEvent(new SVEvent('externalError', "VIDEO URL NOT FOUND"));
					break;
				case "NetStream.Buffer.Full":
					if (_loading && contains(_loading))
						removeChild(_loading);
					break;
				case "NetStream.Play.Stop":
					if (isMovieEnded())
					{
						removeChild(_player);
						if (_videoControl && contains(_videoControl))
							removeChild(_videoControl);
						_player = null; 
						_videoControl = null;
						
						dispatchEvent(new SVEvent(SVVideoPlayer.VIDEO_COMPLETED, _videoURL, true, true));
						
						if (_loop)
							onStartPlay();
						else if (_previewImg)
							_previewImg.visible = true;
					}
					break;
			}
		}
		
		protected function connectStream():void 
		{
			setupVideoViewer();
			
			if (_noControls == false)
			{
				_controlHidden = true;
				setupControls();
			}
			
			if (_showControls) 
				this.addEventListener(MouseEvent.ROLL_OVER, showControl, false, 0, true);
		}
		
		protected function setupVideoViewer():void
		{
			_player = new Video(_videoWidth,_videoHeight);
			_player.width = _videoWidth;
			_player.height = _videoHeight;
			_player.smoothing = true;
			_stream = new NetStream(_netConnection);
			
			var clientObject:Object = new Object;
			clientObject.onMetaData = this.onMetaData;
			clientObject.onCuePoint = this.onCuePoint;
			
			_stream.client = clientObject;
			_stream.addEventListener(NetStatusEvent.NET_STATUS, netStatusHandler, false, 0, true);
			_stream.addEventListener(AsyncErrorEvent.ASYNC_ERROR, asyncErrorHandler, false, 0, true);
			_player.attachNetStream(_stream);
			_stream.bufferTime = 3;
			_stream.soundTransform = new SoundTransform(.75);
			_stream.play(_videoURL);
			addChild(_player);
		}
		
		protected function setupControls():void
		{
			_videoControl = new VideoControl(_player.width);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.PAUSE, onPause, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.PLAY, onPlay, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.SOUND_OFF, soundOff, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.SOUND_ON, soundOn, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.START_OVER, onStartOver, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.DRAGGED, onDragged, false, 0, true);
			_videoControl.addEventListener(SVVideoPlayerControlsBase.DRAG_START, onDragStart, false, 0, true);
			_videoControl.x = 0;
			_videoControl.y = _player.y + _player.height;
			addChild(_videoControl);
		}
		
		private function onReaddedToStage(e:Event):void
		{
			init();
		}
		
		protected function showControl(e:Event):void 
		{
			if (_controlHidden) {
				_controlHidden = false;
				if (_videoControl != null) {
					TweenLite.killTweensOf(_videoControl);
					TweenLite.to(_videoControl, 1,{ y: _videoHeight -  20, onCompleteParams:[this], onComplete: function(target:Object):void { target._controlHidden = false;}});
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
				TweenLite.to(_videoControl, 1, {y: _videoHeight, onCompleteParams:[this], onComplete: function(target:Object):void { target._controlHidden = true;}});
			}
			clearInterval(_intervalId);
		}
		
		protected function playProgress():void
		{
			if (_videoControl != null) {
				if (!_isDragging) {
					_videoControl.headPosition = _stream.time/_videoDuration;
					_playInterval = setTimeout(playProgress, 200);
				}			
			}
			
			dispatchEvent(new Event(SVVideoPlayer.VIDEO_PROGRESS, true, true));
		}
		
		protected function onPlay(e:Event):void
		{
			_stream.resume();
		}
		
		protected function onPause(e:Event):void
		{
			_stream.pause();
		}
		
		protected function onStartOver(e:Event):void
		{
			restart();
		}
		
		protected function onDragStart(e:Event):void
		{
			clearTimeout(_playInterval);
			_isDragging = true;
		}
		
		protected function onDragged(e:DataEvent):void
		{
			_stream.seek(Number(e.data)*_videoDuration);
			if (_videoControl.isPlaying()) {
				_stream.resume();
			}
			_isDragging = false;
			_playInterval = setTimeout(playProgress, 200);
		}
		
		protected function soundOn(e:Event):void 
		{
			_stream.soundTransform = new SoundTransform(.75);
		}
		
		protected function soundOff(e:Event):void
		{
			_stream.soundTransform = new SoundTransform(0);
		}
		
		protected function onMetaData(infoObject:Object):void
		{
			_videoDuration = infoObject.duration;
			_isDragging = false;
			_playInterval = setTimeout(playProgress, 200);
			
			// have to wait until metadata is loaded to implement video crop
			if (_sourceCrop != null)
			{
				var sourceScaleX:Number = _videoWidth / _sourceCrop.width;
				var sourceScaleY:Number = _videoHeight / _sourceCrop.height;
				
				_player.width = infoObject.width * sourceScaleX;
				_player.height = infoObject.height * sourceScaleY;
				_player.x = -_sourceCrop.x * sourceScaleX;
				_player.y = -_sourceCrop.y * sourceScaleY;
			}
		}
		
		public function disableControls():void
		{
			_noControls = true;
		}
		
		public function disableKill():void
		{
			_noKill = true;
		}
		
		public function get total_time():Number { return _videoDuration; }
		
		public function get current_time():Number { return _stream ? _stream.time : 0; }
		
		protected function onBWDone():void { }
		protected function onCuePoint(infoObject:Object):void{ }
		protected function securityErrorHandler(e:SecurityErrorEvent):void { }
		protected function asyncErrorHandler(e:AsyncErrorEvent):void { }
		public function isMovieEnded():Boolean { return (Math.ceil(current_time) >= Math.ceil(total_time)); }
		
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		public function get video_url():String { return _videoURL; }
		
		public function set video_url(value:String):void
		{
			kill();
			
			_videoURL = value;
			
			_loading = null;
			_player = null;
			
			if (hasEventListener(MouseEvent.ROLL_OVER))
				removeEventListener(MouseEvent.ROLL_OVER, showControl);
			
			if (!value) return;
			
			init();
			
			if (_autoPlay && stage)
				onStartPlay();
		}
		
		public function set preview_url(img:String):void
		{
			addPreview();
			
			_previewImg.image_url = img;
			_previewImg.scaleImage(_videoWidth, _videoHeight);
			
			if (img is String)
				_previewImageURL = String(img);
		}
		public function get preview_url():String
		{
			return _previewImg ? _previewImg.image_url : null;
		}
		
		override public function get width():Number { return _videoWidth; }
		
		override public function set width(value:Number):void
		{
			_videoWidth = value;
			
			if (_videoURL)
				drawBackground();
			
			if (_previewImg)
			{
				_previewImg.width = _videoWidth;
				if (_playButton)
					_playButton.x = _previewImg.width/2 - _playButton.width/2;
			}
			
			if (_player)
				_player.width = _videoWidth;
		}
		
		override public function set height(value:Number):void
		{
			_videoHeight = value;
			
			if (_videoURL)
				drawBackground();
			
			if (_previewImg)
			{
				_previewImg.height = _videoHeight;
				if (_playButton)
					_playButton.y = _previewImg.height/2 - _playButton.height/2;
			}
			
			if (_player)
				_player.height = _videoHeight;
		}
		
		override public function get height():Number { return _videoHeight; }
		
		public function set auto_play(value:Boolean):void
		{
			_autoPlay = value;
			
			if (_autoPlay && stage)
				onStartPlay();
			else
			{
				pause();
				if (_previewImg)
				{
					addChild(_previewImg);
					_previewImg.visible = true;
				}
			}
		}
	}
}