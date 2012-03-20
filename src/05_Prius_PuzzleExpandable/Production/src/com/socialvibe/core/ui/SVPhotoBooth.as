package com.socialvibe.core.ui
{
	import com.socialvibe.core.ui.controls.*;
	import com.socialvibe.core.utils.SVEvent;
	
	import flash.display.*;
	import flash.events.*;
	
	public class SVPhotoBooth extends Sprite
	{
		public static const CLOSE:String = 'closePhotoBooth';
		public static const PHOTO_SELECTED:String = 'photoBoothPhotoSelected';
		public static const PHOTO_TAKEN:String = 'photoBoothPhotoTaken';
		
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _snapshotControls:Sprite;
		protected var _snapshotBtn:SVButton;
		
		protected var _retakeControls:Sprite;
		protected var _takeAnotherBtn:SVButton;
		protected var _useBtn:SVButton;
		
		protected var _currentSnapshot:Bitmap;
		protected var _selectedSnapshot:Bitmap;
		
		private var _camera:SVWebcam;		
		
		public function SVPhotoBooth(width:Number = 750, height:Number = 500)
		{
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
			
			drawBackground();
			
			readyCamera();
			showSnapshotControls();	
		}
		
		
		/* =================================
			Public Functions
		================================= */
		public function get selectedPhoto():Bitmap { return _selectedSnapshot; }
		
		
		/* =================================
			Drawing & Display Functions
		================================= */
		protected function drawBackground():void
		{
			var g:Graphics = this.graphics;
			g.beginFill(0x000000, 0.75);
			g.drawRect( 0, 0, _width, _height );
		}
		
		
		protected function showSnapshotControls():void
		{
			if ( _snapshotControls == null )
			{
				_snapshotControls = new Sprite();
				
				_snapshotBtn = new SVButton( 'Take Photo', 120, 27, 14, 27 );
				_snapshotBtn.addEventListener( MouseEvent.CLICK, onSnapshot, false, 0, true)
				_snapshotBtn.x = (_width - _snapshotBtn.width)/2;
				_snapshotBtn.y = 425;
				_snapshotControls.addChild(_snapshotBtn);
				
				
				var closeText:SVText = new SVText( 'close', _width - 50, _height - 30, 14, true, 0xffffff );
				_snapshotControls.addChild( closeText );
				
				var closeHitbox:ButtonHitBox = new ButtonHitBox( closeText.textWidth + 20, closeText.textHeight + 6, closeText.textHeight + 6, closeText.x - 8, closeText.y);
				closeHitbox.addEventListener( MouseEvent.CLICK, onClose, false, 0, true );
				_snapshotControls.addChild( closeHitbox );
			}
			
			if ( _retakeControls && contains( _retakeControls ) )
				removeChild( _retakeControls );
			
			addChild( _snapshotControls )
		}
		
		protected function showRetakeControls():void
		{
			if ( _retakeControls == null )
			{
				_retakeControls = new Sprite();
				
				_takeAnotherBtn = new SVButton('Take another', 120, 27, 14, 27 );
				_takeAnotherBtn.addEventListener( MouseEvent.CLICK, function(e:Event):void{
					_camera.unfreeze();
					showSnapshotControls();
				} );
				_takeAnotherBtn.x = (756 - 120*2 + 10)/2;
				_takeAnotherBtn.y = 425;
				_retakeControls.addChild( _takeAnotherBtn );
				
				_useBtn = new SVButton('Use this', 120, 27, 14, 27 );
				_useBtn.addEventListener( MouseEvent.CLICK, function(e:Event):void{
					dispatchEvent( new SVEvent( PHOTO_SELECTED, _currentSnapshot, true, true ) );
				} );
				_useBtn.x = (756 - 120*2 + 10)/2 + 130;
				_useBtn.y = 425;
				_retakeControls.addChild( _useBtn );
				
				var closeText:SVText = new SVText( 'close', _width - 50, _height - 30, 14, true, 0xffffff );
				_retakeControls.addChild( closeText );
				
				var closeHitbox:ButtonHitBox = new ButtonHitBox( closeText.textWidth + 20, closeText.textHeight + 6, closeText.textHeight + 6, closeText.x - 8, closeText.y);
				closeHitbox.addEventListener( MouseEvent.CLICK, onClose, false, 0, true );
				_retakeControls.addChild( closeHitbox );
			}
			
			if ( _snapshotControls && contains( _snapshotControls ) )
				removeChild( _snapshotControls );
			
			addChild( _retakeControls )
			
		}
		
		private function readyCamera():void
		{	
			_camera = new SVWebcam(480, 360);
			_camera.x = (_width - 480)/2;
			_camera.y = (_height - 360)/2 - 25;
			addChild( _camera );
			
			var g:Graphics = this.graphics;
			g.beginFill(0x666666, 0.85);
			g.drawRoundRect( _camera.x - 4, _camera.y - 4, 480 + 2*4, 360 + 2*4, 5 );
			
			_camera.start();
		}
		
		private function onSnapshot(e:Event):void
		{			
			_currentSnapshot = _camera.snapshot(true);
			showRetakeControls();
			
			dispatchEvent( new SVEvent( PHOTO_TAKEN, _currentSnapshot, true, true ) );
		}
		
		private function onClose(e:Event):void
		{
			dispatchEvent( new Event( CLOSE, true, true ) );
		}
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