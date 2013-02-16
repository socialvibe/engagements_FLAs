package com.socialvibe.core.ui
{
	import com.socialvibe.core.config.Services;
	import com.socialvibe.core.services.ServiceLocator;
	import com.socialvibe.core.utils.SVEvent;
	import com.socialvibe.core.ui.controls.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.external.ExternalInterface;
	import flash.utils.*;
	
	import org.rubyamf.remoting.ssr.*;
	
	public class SVVideoBooth extends Sprite
	{
		public static const CLOSE:String = 'closeVideoBooth';
		public static const DOWNLOAD_CLICK:String = 'clickedDownload';
		
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _rtmpURL:String;
		protected var _filenamePrefix:String;
		protected var _maxVideoLength:uint;
		
		protected var _currentFilename:String;
		protected var _downloadLink:String;
		
		protected var _recordControls:Sprite;
		protected var _recordBtn:SVButton;
		protected var _recordLoader:SVSquareLoader;

		protected var _recordingControls:Sprite;
		protected var _stopBtn:SVButton;

		protected var _retakeControls:Sprite;
		protected var _playBtn:SVButton;
		protected var _downloadBtn:SVButton;
		protected var _recordAnotherBtn:SVButton;
		protected var _linkLoader:SVSquareLoader;
		
		
		protected var _startTime:Number;
		protected var _timerID:uint;
		protected var _timerText:SVText;
				
		protected var _currentControls:Sprite;
		
		protected var _camera:SVWebcam;		
		
		public function SVVideoBooth(rtmpURL:String, filenamePrefix:String = 'SVVideoBooth_', maxVideoLength:uint = 120, width:Number = 750, height:Number = 500)
		{
			_rtmpURL = rtmpURL;
			_filenamePrefix = filenamePrefix;
			_maxVideoLength = maxVideoLength;
			
			_width = width;
			_height = height;
			
			this.mouseEnabled = true;
			addEventListener( Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		
		/* =================================
			Initializer
		================================= */		
		protected function init(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init);
			addEventListener( Event.ADDED_TO_STAGE, addedToStageAgain, false, 0, true );			
			
			drawBackground();
			
			initCamera();
			showRecordControls();
		}
		
		protected function addedToStageAgain(e:Event):void
		{
			if ( _recordControls != null && _currentControls == _recordControls )
				_camera.start();
		}
		
		
		
		/* =================================
			Public Functions
		================================= */
		public function get camera():SVWebcam { return _camera; }
		public function get downloadLink():String { return _downloadLink; }
		public function get currentFilename():String { return _currentFilename; };
		
		
		/* =================================
			Drawing & Display Functions
		================================= */
		protected function drawBackground():void
		{
			var g:Graphics = this.graphics;
			g.beginFill(0x000000, 0.75);
			g.drawRect( 0, 0, _width, _height );
		}
		
	
		
		/* =================================
			Displaying controls
		================================= */
		protected function showRecordControls():void
		{
			if ( _currentControls && contains( _currentControls ) )
				removeChild( _currentControls );
			
			if ( _recordControls == null )
			{
				_recordControls = new Sprite();
				
				_recordBtn = new SVButton( 'Start Recording', 145 );
				_recordBtn.color = 0xff0000;
				_recordBtn.addEventListener( MouseEvent.CLICK, onRecord, false, 0, true)
				_recordBtn.x = (_width - _recordBtn.width)/2;
				_recordBtn.y = 425;
				_recordControls.addChild(_recordBtn);
				
				var closeText:SVText = new SVText( 'close', _width - 50, _height - 30, 14, true, 0xffffff );
				_recordControls.addChild( closeText );
				
				var closeHitbox:ButtonHitBox = new ButtonHitBox( closeText.textWidth + 20, closeText.textHeight + 6, closeText.textHeight + 6, closeText.x - 8, closeText.y);
				closeHitbox.addEventListener( MouseEvent.CLICK, onClose, false, 0, true );
				_recordControls.addChild( closeHitbox );
			}
			
			_recordBtn.visible = false;
			
			_currentControls = _recordControls;
			addChild( _recordControls )
		}
		
		protected function onWebcamReady(e:Event):void
		{
			_recordBtn.visible = true;
		}
		
		protected function onRecord(e:Event):void
		{
			if ( _currentControls && contains( _currentControls ) )
				removeChild( _currentControls );
			
			_currentFilename = _filenamePrefix + String((new Date).getTime());
			_camera.record( _rtmpURL, _currentFilename );	
		}
		
		protected function onRecordStarted(e:Event):void
		{
			showRecordingControls();
			startTimer();
		}
		
		protected function onClose(e:Event):void
		{
			_camera.kill();
			dispatchEvent( new Event( CLOSE, true, true ) );
		}
		

		
		protected function showRecordingControls():void
		{
			if ( _currentControls && contains( _currentControls ) )
				removeChild( _currentControls );
			
			if ( _recordingControls == null )
			{
				_recordingControls = new Sprite();
				
				_stopBtn = new SVButton( 'Stop' );
				_stopBtn.color = 0xff0000;
				_stopBtn.addEventListener( MouseEvent.CLICK, onStopRecord, false, 0, true)
				_stopBtn.x = (_width - _stopBtn.width)/2;
				_stopBtn.y = 440;
				_recordingControls.addChild(_stopBtn);
				
				_timerText = new SVText( '', 0, 0, 13, false, 0xcccccc );
				_timerText.x = (_width - _timerText.width)/2;
				_timerText.y = 417;
				_recordingControls.addChild(_timerText);
				
			}
			
			_currentControls = _recordingControls;
			addChild( _recordingControls )

		}
		
		protected function onStopRecord(e:Event=null):void
		{
			_camera.stopRecord();

			stopTimer();
			showRetakeControls();
			fetchDownloadLink();
		}
		
		
		
		protected function showRetakeControls():void
		{
			if ( _currentControls && contains( _currentControls ) )
				removeChild( _currentControls );
			
			if ( _retakeControls == null )
			{
				_retakeControls = new Sprite();
				
				_playBtn = new SVButton( 'Play' );
				_playBtn.color = 0xf7c53d;
				_playBtn.addEventListener( MouseEvent.CLICK, onClickPlay, false, 0, true );
				_playBtn.y = 425;
				_retakeControls.addChild( _playBtn );
				
				_recordAnotherBtn = new SVButton('Take another', 120);
				_playBtn.color = 0x918f8f;
				_recordAnotherBtn.addEventListener( MouseEvent.CLICK, onRerecord );
				_recordAnotherBtn.y = 425;
				_retakeControls.addChild( _recordAnotherBtn );
				
				_downloadBtn = new SVButton('Download');
				_downloadBtn.addEventListener( MouseEvent.CLICK, onClickDownload );
				_downloadBtn.y = 425;
				_retakeControls.addChild( _downloadBtn );
				
				_playBtn.x = (_width - ( _playBtn.width + 10 + _recordAnotherBtn.width + 10 + _downloadBtn.width ))/2;
				_recordAnotherBtn.x = _playBtn.x + _playBtn.width + 10;
				_downloadBtn.x = _recordAnotherBtn.x + _recordAnotherBtn.width + 10;
				
				var closeText:SVText = new SVText( 'close', _width - 50, _height - 30, 14, true, 0xffffff );
				_retakeControls.addChild( closeText );
				
				var closeHitbox:ButtonHitBox = new ButtonHitBox( closeText.textWidth + 20, closeText.textHeight + 6, closeText.textHeight + 6, closeText.x - 8, closeText.y);
				closeHitbox.addEventListener( MouseEvent.CLICK, onClose, false, 0, true );
				_retakeControls.addChild( closeHitbox );
			}
			
			// hide buttons while transfering video from fms to s3
			_playBtn.visible = false;
			_recordAnotherBtn.visible = false;
			_downloadBtn.visible = false;
			
			_linkLoader = new SVSquareLoader( false, 'Processing...');
			_linkLoader.y = 425;
			_linkLoader.x = (_width - _linkLoader.width)/2;
			_retakeControls.addChild( _linkLoader );
			
			_currentControls = _retakeControls;
			addChild( _retakeControls )
		}
		
		protected function onClickPlay(e:Event):void
		{
			_camera.play(_rtmpURL, _currentFilename );
		}
		
		protected function onRerecord(e:Event):void
		{
			showRecordControls();
			_camera.start();
		}
		
		protected function onClickDownload(e:Event):void
		{			
			var call:String = 'function(){ window.location = "' + _downloadLink + '"; return true; }';
			ExternalInterface.call(call);
			
			dispatchEvent( new Event( DOWNLOAD_CLICK, true, true ) );
		}
		

		
		/* =================================
			Countdown Timer functions
		================================= */
		protected function startTimer(e:Event=null):void
		{
			_timerText.visible = true;
			_startTime = (new Date()).getTime();
			
			updateCountdown();
			_timerID = setInterval( updateCountdown, 400 );
		}
		
		protected function updateCountdown():void
		{
			var recordTime:Number = int( ((new Date()).getTime() - _startTime)/1000 );
			var timeLeft:Number = _maxVideoLength - recordTime;
			
			if ( timeLeft < 0 ) {

				onStopRecord();
				return;
			}
			
			var dateObject:Date = new Date();
			dateObject.setTime( timeLeft * 1000 );
			
			var timeLeftInText:String = dateObject.minutes.toString() + ':' + (dateObject.seconds >= 10 ? '' : '0' ) + dateObject.seconds.toString();
			
			_timerText.text = 'Recording now, ' + timeLeftInText +' left...';
			_timerText.x = (_width - _timerText.width)/2;
		}
		
		protected function stopTimer(e:Event=null):void
		{
			if ( !isNaN(_timerID) )
				clearInterval( _timerID );
			
			_timerID = NaN;
			_timerText.visible = false;
		}
		
		
		
		/* =================================
			Webcam Management
		================================= */
		protected function initCamera():void
		{	
			_camera = new SVWebcam(480, 360);
			_camera.addEventListener( SVWebcam.RECORDING_STARTED, onRecordStarted, false, 0, true );
			_camera.addEventListener( SVWebcam.READY, onWebcamReady, false, 0, true );
			_camera.x = (_width - 480)/2;
			_camera.y = (_height - 360)/2 - 25;
			addChild( _camera );
			
			// add video cam border
			var g:Graphics = this.graphics;
			g.beginFill(0x666666, 0.85);
			g.drawRoundRect( _camera.x - 4, _camera.y - 4, 480 + 2*4, 360 + 2*4, 5 );
			
			_camera.start();
		}
		
		
		
		
		/* =================================
			Download link management
		================================= */
		protected var _retryAttempts:Number = 5;
		
		protected function fetchDownloadLink():void
		{
			ServiceLocator.getInstance().getPartnerService("EngagementsController").fms_to_s3
				([ { 'filename':_currentFilename, 'extension':'flv' } ], onReadyForDownload, onNotReady, { noExceptions:true });
		}

		protected function onNotReady(fault:FaultEvent = null):void
		{
			if (_retryAttempts > 0)
			{
				setTimeout(fetchDownloadLink, 5000);
				_retryAttempts -= 1;				
			}
		}
		
		protected function onReadyForDownload(e:ResultEvent):void
		{
			if (e.result.status == Services.STATUS_OK)
			{
				_downloadLink = String(e.result.data);
				showDownloadLinks();
			}
			else				
			{
				// retry
				onNotReady();
			}
		}
		
		protected function showDownloadLinks():void
		{
			_playBtn.visible = true;
			_recordAnotherBtn.visible = true;
			_downloadBtn.visible = true;
			
			if (_linkLoader != null && _linkLoader.parent == _retakeControls )
				_linkLoader.stop();
		}
		
		

		/* =================================
			Event Management
		================================= */

		

	}
}

import com.socialvibe.core.ui.controls.*;
import com.socialvibe.core.ui.SVSquareLoader;

import flash.display.*;
import flash.events.*;

internal class ButtonHitBox extends Sprite
{
	protected var _width:Number;
	protected var _height:Number;
	protected var _curveSize:Number;
	
	protected var _overlay:Sprite;
	
	protected var _rollover:Boolean = false;
	protected var _loading:Boolean = false;
	
	protected var _loader:SVSquareLoader;
	
	
	public function ButtonHitBox( width:Number, height:Number, curveSize:Number = 0, x:Number = 0, y:Number = 0 )
	{
		this.x = x;
		this.y = y;
		_width = width;
		_height = height;
		_curveSize = curveSize;
		
		
		// add overlay
		drawOverlay();
		
		// set mouse events	
		this.buttonMode = this.useHandCursor = true;
		addEventListener( MouseEvent.ROLL_OVER, onRollover, false, 0, true);
		addEventListener( MouseEvent.ROLL_OUT, onRollout, false, 0, true);
		
		//		showBounds();
	}
	
	
	/* =================================
		Public Functions
	================================= */
	public function showBounds():void
	{
		var g:Graphics = this.graphics;
		g.beginFill(0xff0000, 0.5);
		g.drawRoundRect(0, 0, _width, _height, _curveSize);
	}
	
	public function startLoading():void
	{
		_loading = true;
		this.mouseEnabled = false;
		
		drawOverlay();	
		
		if (_loader == null) {
			_loader = new SVSquareLoader(false);
			_loader.scaleX = _loader.scaleY = (_height/1.5)/_loader.height;
			_loader.x = (_width - _loader.width)/2;
			_loader.y = (_height - _loader.height)/2;
		}
		
		addChild( _loader );
		_loader.start();
		
		
	}
	
	public function stopLoading():void
	{
		_loading = false;
		this.mouseEnabled = true;
		
		_loader.stop();
		
		drawOverlay();
	}
	
	
	/* =================================
	Drawing & Display Functions
	================================= */
	protected function drawOverlay():void
	{
		_overlay ||= new Sprite();
		addChild(_overlay);
		
		var g:Graphics = _overlay.graphics;
		g.clear();
		
		if (_loading)
		{
			g.beginFill(0xa22b71, 1);
			g.drawRoundRect(0, 0, _width, _height, _curveSize);			
		}
		else if (_rollover)
		{
			g.beginFill( 0xffffff, 0.10 );
			g.drawRoundRect(0, 0, _width, _height, _curveSize);
		}
		else
		{
			g.beginFill( 0xffffff, 0 );
			g.drawRoundRect(0, 0, _width, _height, _curveSize);
		}
	}
	
	
	/* =================================
	Event Listeners
	================================= */
	protected function onRollover(e:MouseEvent):void
	{
		_rollover = true;
		drawOverlay();
	}
	
	protected function onRollout(e:MouseEvent):void
	{
		_rollover = false;
		drawOverlay();
	}
}