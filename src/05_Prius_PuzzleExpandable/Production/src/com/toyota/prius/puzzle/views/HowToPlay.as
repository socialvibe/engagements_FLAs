package com.toyota.prius.puzzle.views 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import com.greensock.TweenLite;
	import com.greensock.easing.Sine;
	import com.greensock.easing.Back;
	
	/**
	 * ...
	 * @author jin
	 */
	public class HowToPlay extends MovieClip
	{
		private var _middleH:uint;
		private var _botY:uint;
		
		private var _box:MovieClip;
		private var _btnOpen:MovieClip;
		private var _body:MovieClip;
		private var _mask:MovieClip;
		
		private var _isOpen:Boolean;
		private var _isDebug:Boolean;
		
		public function HowToPlay( isDebug:Boolean ) 
		{
			trace( this, isDebug );
			_isDebug = isDebug;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		
		private function init(e:Event = null):void 
		{	
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			if ( _isDebug )
			{
				return;
				
			}else {
				
				_box 	= this.getChildByName( "box" ) as MovieClip;
				_body 	= this.getChildByName( "body" ) as MovieClip;
				_mask 	= this.getChildByName( "maskM" ) as MovieClip;
				//_btnOpen = this.getChildByName( "btnOpen" ) as MovieClip;
			}
			
			_middleH = 6
			_botY = 20;
			_body.mask = _mask;
			_isOpen = false;
			
			this.y = 60;
			this.alpha = 0;
			
			/*
			_btnOpen.addEventListener( MouseEvent.CLICK, 		onOpenClick );
			_btnOpen.addEventListener( MouseEvent.MOUSE_OUT, 	onOpenOut );
			_btnOpen.addEventListener( MouseEvent.MOUSE_OVER, 	onOpenOver );
			_btnOpen.mouseChildren = false;
			_btnOpen.mouseEnabled = _btnOpen.buttonMode = true;
			_btnOpen.gotoAndStop( "up" );
			*/
		}
		
		
		private function onOpenOut( e:MouseEvent ):void
		{
			_btnOpen.gotoAndStop( "up" );
		}
		private function onOpenOver( e:MouseEvent ):void
		{
			_btnOpen.gotoAndStop( "over" );
		}
		
		private function onOpenClick( e:MouseEvent=null, force:Boolean=false, delay:Number=0 ):void
		{
			if ( _isOpen ) 	onClose( force );
			else 			onOpen();
			
			_isOpen = !_isOpen;
			
			_btnOpen.mc.gotoAndStop( _isOpen?"close":"open" );
			if ( force ) return;
			
			_btnOpen.mc.rotation = -45;
			TweenLite.to( _btnOpen.mc, .4, 	{ rotation:0, 	ease:Back.easeOut, easeParams:[2], delay:delay } );
		}
		
		
		public function onShow():void
		{	
			/*
			if ( _btnOpen )
			{
				_btnOpen.mouseEnabled = _btnOpen.buttonMode = true;
				if ( _isOpen ) onOpenClick( null, true );
			}
			*/
			
			if ( this.alpha == 1 && this.y == 90 ) return;
			
			
			TweenLite.killTweensOf( this );
			TweenLite.to( this, .5, 	{ y:90, alpha:1, ease:Back.easeOut, delay:1 } );
			
			onOpen();
		}
		
		public function onHide():void
		{
			if ( _btnOpen )
			{
				_btnOpen.mouseEnabled = _btnOpen.buttonMode = false;
				if( _isOpen ) onClose();
			}
			
			TweenLite.killTweensOf( this );
			TweenLite.to( this, .5, 	{ y:60, alpha:0,	ease:Back.easeIn } );
		}
		
		private function onOpen():void
		{
			if ( !_box ) return;
			
			removeTweens();
			
			var t:Number 		= .5;
			var delay:Number 	= 1.1;
			
			_box.middle.height 	= _middleH;
			_mask.height	 	= _middleH;
			_box.bottom.y 		= _botY;
			
			TweenLite.to( _box.middle, t, 	{ height:_middleH + 190, ease:Back.easeOut, easeParams:[.75], 	delay:delay } );
			TweenLite.to( _box.bottom, t, 	{ y:_botY + 190, 		 ease:Back.easeOut, easeParams:[.75], 	delay:delay} );
			TweenLite.to( _mask, t, 		{ height:_middleH + 190, ease:Sine.easeOut, delay:.05+delay } );
		}
		
		private function onClose( force:Boolean=false ):void
		{
			removeTweens();
			
			var t:Number = .4;
			if ( force )
			{
				_box.middle.height 	= _middleH;
				_mask.height	 	= _middleH;
				_box.bottom.y 		= _botY;
				return;
			}
			TweenLite.to( _box.middle, t, 	{ height:_middleH, ease:Sine.easeOut, delay:.05 } );
			TweenLite.to( _box.bottom, t, 	{ y:_botY, 		ease:Sine.easeOut, delay:.05} );
			TweenLite.to( _mask, t, 		{ height:_middleH, ease:Sine.easeOut } );
		}
		
		private function removeTweens():void
		{
			if( _box ) TweenLite.killTweensOf( _box.middle );
			if( _box ) TweenLite.killTweensOf( _box.bottom );
			if( _mask ) TweenLite.killTweensOf( _mask );
		}
		
	}
	
}