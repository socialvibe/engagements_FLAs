package com.socialvibe.core.ui
{
	import com.socialvibe.core.services.SVEventTracker;
	import com.socialvibe.core.ui.controls.SVText;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.Camera;
	import flash.media.Microphone;
	import flash.media.Video;
	import flash.net.*;
	import flash.system.*;
	import flash.utils.*;
	
	import com.greensock.TweenLite;
		
	public class SVWebcam extends Sprite
	{
		public static const WEBCAM_NOT_FOUND:String = 'noWebcamsFound';
		public static const ACCESS_DENIED:String = 'webcamAccessDenied';
		public static const VIDEO_FEED_TIMEOUT:String = 'videoFeedTimeout';
		public static const READY:String = 'webcamReady';
		
		public static const RECORDING_STARTED:String = 'recordingStarted';
		public static const RECORDING_FAILED:String = 'recordingFailed';
		
		public static const PLAYBACK_STARTED:String = 'playbackStarted';
		public static const PLAYBACK_FAILED:String = 'playbackFailed';
		
		
		// display options
		protected var _width:Number;
		protected var _height:Number;

		// internal state
		protected var _accessDenied:Boolean = false;
		
		// webcam components
		protected var _camera:Camera;
		protected var _video:Video;
		
		// display objects
		protected var _errorMessage:SVText;
		protected var _loadingScreen:Sprite;

		// data
		private var _snapshotImage:Bitmap;
		
		// etc
		private var _recordStream:NetStream;
				
		public function SVWebcam(width:Number = 320, height:Number = 240)
		{
			_width = width;
			_height = height;
			
			addEventListener( Event.ADDED_TO_STAGE, init, false, 0, true );
		}
		
		/* =================================
			Public Functions
		================================= */
		public function start():void
		{
			if (_camera && !_camera.muted)
				resumeVideoFeed();
			else
				readyCamera();
		}
		
		public function kill():void
		{
			stopCamera();
		}
		
		public function snapshot(freeze:Boolean = true):Bitmap
		{
			var bmd:BitmapData = new BitmapData(_video.width,_video.height,false);
			bmd.draw(_video,new Matrix());
			_snapshotImage = new Bitmap( bmd );
			_snapshotImage.x = _video.x;
			_snapshotImage.y = _video.y;
			
			if (freeze)
			{
				_video.attachCamera(null);
				addChild( _snapshotImage );
			}
			
			return new Bitmap(_snapshotImage.bitmapData.clone());;
		}
		
		public function record(rtmp:String, publish_name:String):void
		{
			showLoadingMessage( 'Initializing...' );
			
			var my_nc:NetConnection = new NetConnection();
			my_nc.client = new CustomClient();
			my_nc.addEventListener(NetStatusEvent.NET_STATUS, function(e:NetStatusEvent):void {
				switch (e.info.code) {
					case "NetConnection.Connect.Success":
						_recordStream = new NetStream(my_nc);
						_recordStream.client = new CustomClient();
						
						var mic:Microphone = Microphone.getMicrophone();
						_recordStream.attachAudio(mic);
						_recordStream.attachCamera(Camera.getCamera());
						
						_recordStream.publish(publish_name, "record");
						
						hideLoadingMessage();
						dispatchEvent( new Event( RECORDING_STARTED, true, true ) );
						break;
				}
			});
			my_nc.connect(rtmp);
		}
		
		public function stopRecord():void
		{
			if (_recordStream)
			{
				_recordStream.attachAudio(null);
				_recordStream.attachCamera(null);
				_recordStream.close();
				
				_video.attachCamera(null);
				_camera = null;
			}
		}
		
		public function play(rtmp:String, publish_name:String):void
		{
			showLoadingMessage( 'Loading...' );
			
			var my_nc:NetConnection = new NetConnection();
			my_nc.client = new CustomClient();
			my_nc.addEventListener(NetStatusEvent.NET_STATUS, function(e:NetStatusEvent):void {
				switch (e.info.code) {
					case "NetConnection.Connect.Success":
						_recordStream = new NetStream(my_nc);
						_recordStream.client = new CustomClient();
						_recordStream.play(publish_name);
						_video.attachNetStream(_recordStream);

						hideLoadingMessage();
						dispatchEvent( new Event( PLAYBACK_STARTED, true, true ) );
						break;
				}
			});
			my_nc.connect(rtmp);
			
			
		}

		public function freeze():void
		{
			
		}
		
		public function unfreeze():void
		{
			if ( _snapshotImage && contains( _snapshotImage ) )
				removeChild( _snapshotImage );
			
			if ( _camera && !_camera.muted )
				resumeVideoFeed()
		}
		

		
		public function retryCameraDetection():void
		{
			
		}
		
		
		public function get cameraDetected():Boolean { return false; }
		public function get permissionGiven():Boolean { return false; }


		
		/* =================================
			Initializer
		================================= */	
		protected function init(e:Event=null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
		
			drawBackground();
			addVideoStream();
		}
		

		/* =================================
			Drawing & Display Functions
		================================= */	
		protected function drawBackground():void
		{
			var g:Graphics = this.graphics;
			g.beginFill(0x000000);
			g.drawRect(0, 0, _width, _height);
		}
		
		protected function addVideoStream():void
		{
			_video = new Video(_width, _height);			
			_video.alpha = 0;
			addChild(_video);
		}
		

		
		
		/* =================================
			Camera / Camera Permissions
		================================= */	
		protected function readyCamera():void
		{
			var availableCameraNames:Array = Camera.names;
			var usbCameraIndex:Number = availableCameraNames.indexOf("USB Video Class Video");
			
			// try to make sure to pick the USB video class for MacBook Pro compatibility
			if (usbCameraIndex > -1){	
				_camera = Camera.getCamera( usbCameraIndex.toString() );
			} else {
				_camera = Camera.getCamera();	
			}
			
			// no camera found
			if (_camera == null) {
				showErrorMessage( 'Unable to detect webcam' );
				dispatchEvent( new Event( WEBCAM_NOT_FOUND, true, true ) );
				return;
			}

			// access denied in past, need to re-pop up permissions
			if (_camera.muted && _accessDenied ) {
				showErrorMessage( 'Access denied by user' );
				Security.showSettings(SecurityPanel.PRIVACY);
				return;
			}
			
			// set up camera
			_camera.setMode( _width, _height, 15 );
			
			// attach the feed to the video 
			_camera.addEventListener(ActivityEvent.ACTIVITY, onCameraLoaded, false, 0, true);
			_camera.addEventListener(StatusEvent.STATUS, onPermissionsChanged, false, 0, true );
			
			_video.attachCamera( _camera );
			_video.alpha = 0;
			
			showLoadingMessage( 'Starting webcam...');
			_cameraTimeoutID = setTimeout( cameraLoadTimeout, 5000 );
		}
		
		protected function resumeVideoFeed():void
		{
			_camera.addEventListener(ActivityEvent.ACTIVITY, onCameraLoaded, false, 0, true);
			
			_video.attachCamera( _camera );
			_video.alpha = 1;				
		} 
		
		protected function stopCamera():void
		{
			_video.attachCamera(null);
			_camera = null;
		}
			
		
		
		/* =================================
			Event Handlers
		================================= */
		protected function onCameraLoaded( e:ActivityEvent):void
		{
			if ( !isNaN(_cameraTimeoutID) )
				clearTimeout(_cameraTimeoutID);
				
			hideLoadingMessage();
			hideErrorMessage();
			
			_camera.removeEventListener(ActivityEvent.ACTIVITY, onCameraLoaded);
			_camera.setLoopback(true);
			_camera.setQuality(0, 100);
			checkActivityLevel();
			
			TweenLite.to( _video, 0.5, {alpha:1} );
			dispatchEvent( new Event( READY, true, true ) );
		}
		
		protected function onPermissionsChanged( e:StatusEvent ):void
		{
			if (_camera && _camera.muted)
			{
				_accessDenied = true;
				dispatchEvent( new Event(ACCESS_DENIED, true, true) );
			}
		}
		
		
		
		/* ======================================
			Detecting Inactive/Disabled Cameras
		======================================== */
		protected var _consecutiveInactivityPeriods:Number = 0;
		protected var _cameraTimeoutID:uint;
		protected function checkActivityLevel():void
		{
			if (_camera == null || _camera.muted ) {
				return;
			}
			
			if (_camera.activityLevel < 1)
			{
				_consecutiveInactivityPeriods += 1;
				
				if( _consecutiveInactivityPeriods > 20)
				{
					hideLoadingMessage();
					showErrorMessage('Unable to load webcam');
					return;
				}

				setTimeout( checkActivityLevel, 1000 );
			}
			else
			{
				_consecutiveInactivityPeriods = 0;
			}
		}
		
		protected var _consecutiveTimeouts:Number = 0;
		protected function cameraLoadTimeout():void
		{
			// if permissions haven't been set yet, then reset timeout
			if (_camera && _camera.muted && !_accessDenied) {
				_cameraTimeoutID = setTimeout( cameraLoadTimeout, 5000 );
				return;
			}
			
			if ( _consecutiveTimeouts < 2 )
			{
				_cameraTimeoutID = setTimeout( cameraLoadTimeout, 3000 );
				_consecutiveTimeouts += 1;
				return;
			}
			
			_cameraTimeoutID = NaN;
			
			hideLoadingMessage();
			showErrorMessage('Unable to load webcam');
		}
		
		
		/* =================================
			Helpers
		================================= */
		protected function showErrorMessage( message:String ):void
		{
			hideErrorMessage();
			
			_errorMessage = new SVText( message, 0, 0, 13, false );
			_errorMessage.x = (_width - _errorMessage.textWidth)/2;
			_errorMessage.y = (_height - _errorMessage.textHeight)/2;
			_errorMessage.alpha = 0;
			addChild( _errorMessage );
			
			TweenLite.to( _errorMessage, 1.5, {alpha: 0.5} );
		}
		
		protected function hideErrorMessage():void
		{
			if ( _errorMessage && contains( _errorMessage ) )
			{
				TweenLite.to( _errorMessage, 1, {alpha: 0, onComplete: function(d:DisplayObject):void {
					if (d && d.parent) d.parent.removeChild(d);
				}, onCompleteParams: [_errorMessage ] } );
			}
		}
		
		protected function showLoadingMessage( message:String ):void
		{
			hideErrorMessage();
			
			if ( _loadingScreen && contains( _loadingScreen ) )
			{
				TweenLite.to( _loadingScreen, 0.5, {alpha: 0, onComplete: function(d:DisplayObject):void {
					if (d && d.parent) d.parent.removeChild(d);
				}, onCompleteParams: [_loadingScreen ] } );
			}
			
			_loadingScreen = new Sprite();
			addChild( _loadingScreen );
			
			TweenLite.from( _loadingScreen, 1, {alpha: 0 } );
			
			var g:Graphics = _loadingScreen.graphics;
			g.beginFill( 0x000000, 0.55 );
			g.drawRect( 0, 0, _width, _height );
			
			var loader:SVSquareLoader = new SVSquareLoader(true, message);
			loader.x = (_width - loader.width)/2;
			loader.y = (_height - loader.height)/2;
			_loadingScreen.addChild( loader );
		}
		
		protected function hideLoadingMessage():void
		{
			if ( _loadingScreen && contains( _loadingScreen ) )
			{
				removeChild( _loadingScreen );
			}
		}
	}
}

class CustomClient {
	public function onBWDone():void {
		
	}
	public function onTimeCoordInfo(info:Object):void {
		
	}
	public function onPlayStatus(info:Object):void {
		
	}
	public function onMetaData(info:Object):void {
		
	}
	public function onCuePoint(info:Object):void {
		
	}
}