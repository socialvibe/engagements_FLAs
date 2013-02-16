package com.socialvibe.core.ui.components.videoplayers
{	
	import com.socialvibe.core.ui.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Rectangle;
	
	public class VideoControl extends SVVideoPlayerControlsBase
	{
		[Embed(source="assets/images/video/play.png")]
		public var playBT:Class;
		
		[Embed(source="assets/images/video/play_over.png")]
		public var play_over:Class;
		
		[Embed(source="assets/images/video/pause.png")]
		public var pauseClass:Class;
		
		[Embed(source="assets/images/video/slider.png")]
		public var slider:Class;
		
		[Embed(source="assets/images/video/sound_off.png")]
		public var sound_off:Class;
		
		[Embed(source="assets/images/video/sound_on.png")]
		public var sound_on:Class;
		
		protected var _bg:Sprite;
		protected var draggableBar:Sprite;
		protected var marker:Sprite;
		
		protected var _width:Number;
		protected var _playing:Boolean;
		protected var _sound_on:Boolean;
		
		private var play_bt:Sprite;
		
		public function VideoControl(width:Number = 487)
		{
			super();
			_width = width;
			
			init();
		}
		
		protected function init():void 
		{
			_bg = new Sprite();
			_bg.graphics.beginFill(0x000000, .8);
			_bg.graphics.drawRect(0,0,_width,20);
			this.addChild(_bg);
			
			var starOver:Sprite = new Sprite();
			starOver.addChild(new play_over() as Bitmap);
			starOver.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			starOver.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
			starOver.addEventListener(MouseEvent.CLICK, onStartOver, false, 0, true);
			starOver.x = 10;
			starOver.y = 8;
			this.addChild(starOver);
			
			_playing = true;
			
			play_bt = new Sprite();
			play_bt.addChild(new pauseClass() as Bitmap);
			play_bt.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			play_bt.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
			play_bt.addEventListener(MouseEvent.CLICK, onPlayButtonClick, false, 0, true);
			play_bt.x = starOver.x + 15;
			play_bt.y = starOver.y;
			this.addChild(play_bt);
			
			draggableBar = new Sprite();
			draggableBar.graphics.lineStyle(0,0xFFFFFF);
			draggableBar.graphics.lineTo(_width - 70, 0);
			draggableBar.x = play_bt.x + 15;
			draggableBar.y = play_bt.y+ 3;
			this.addChild(draggableBar);
			
			marker = new Sprite();
			marker.addChild(new slider() as Bitmap);
			marker.filters = [new DropShadowFilter()];
			marker.addEventListener(MouseEvent.MOUSE_DOWN, onDragBarMouseDown, false, 0, true);
			marker.graphics.beginFill(0x000000, 0);
			marker.graphics.drawRect(-10,-10,20,20);
			marker.x = draggableBar.x + 3;
			marker.y = draggableBar.y-1;
			this.addChild(marker);
			
			_sound_on = true;
			
			var sound_bt:Sprite = new Sprite();
			sound_bt.addChild(new sound_off() as Bitmap);
			sound_bt.addEventListener(MouseEvent.ROLL_OVER, onMouseOver, false, 0, true);
			sound_bt.addEventListener(MouseEvent.ROLL_OUT, onMouseOut, false, 0, true);
			sound_bt.addEventListener(MouseEvent.CLICK, onSoundClick, false, 0, true);
			sound_bt.x = draggableBar.x + draggableBar.width + 10;
			sound_bt.y = starOver.y;
			this.addChild(sound_bt);
			
			starOver.useHandCursor = play_bt.useHandCursor = marker.useHandCursor = sound_bt.useHandCursor = true;
			starOver.buttonMode = play_bt.buttonMode = marker.buttonMode = sound_bt.buttonMode = true;
		}
		
		override public function set headPosition(position:Number):void
		{
			marker.x = draggableBar.x + draggableBar.width*position;
		}
		
		override public function pause():void
		{
			_playing = true;
			onPlayButtonClick();
		}
		
		override public function play():void
		{
			_playing = false;
			onPlayButtonClick();
		}
		
		protected function onMouseOver(e:MouseEvent):void
		{
			e.currentTarget.filters = [new GlowFilter(0xFFFFFF, .5, 3,3,2,3)];
		}
		
		protected function onMouseOut(e:MouseEvent):void 
		{
			e.currentTarget.filters = [];
		}
		
		protected function onStartOver(e:Event):void
		{
			this.dispatchEvent(new Event(START_OVER));
		}
		
		protected function onPlayButtonClick(e:Event = null):void 
		{
			play_bt.removeChildAt(0);
			var nextBitmap:Bitmap;
			if (_playing) {
				this.dispatchEvent(new Event(PAUSE));
				nextBitmap = new playBT() as Bitmap;
			} else {
				this.dispatchEvent(new Event(PLAY));
				nextBitmap = new pauseClass() as Bitmap;
			}
			play_bt.addChild(nextBitmap);
			_playing = !_playing;
		}
		
		protected function onDragBarMouseDown(e:Event):void
		{
			marker.addEventListener(MouseEvent.MOUSE_UP, onDragBarMouseUp, false, 0, true);
			marker.addEventListener(MouseEvent.MOUSE_OUT, onDragBarMouseUp, false, 0, true);
			var _sprite:Sprite = e.target as Sprite;
			_sprite.startDrag(false, new Rectangle(draggableBar.x,draggableBar.y-1,draggableBar.width,0));
			this.dispatchEvent(new Event(DRAG_START, true, false))
		}
		
		protected function onDragBarMouseUp(e:Event):void 
		{
			marker.removeEventListener(MouseEvent.MOUSE_UP, onDragBarMouseUp);
			marker.removeEventListener(MouseEvent.MOUSE_OUT, onDragBarMouseUp);
			
			var _sprite:Sprite = e.target as Sprite;
			_sprite.stopDrag();
			
			this.dispatchEvent(new DataEvent(DRAGGED, false, false, ( ((e.target as Sprite).x- draggableBar.x)/(draggableBar.width) ).toString()));
		}
		
		protected function onSoundClick(e:Event):void
		{
			e.target.removeChildAt(0);
			var nextBitmap:Bitmap;
			if (_sound_on) {
				this.dispatchEvent(new Event(SOUND_OFF));
				nextBitmap = new sound_on() as Bitmap;
			} else {
				this.dispatchEvent(new Event(SOUND_ON));
				nextBitmap = new sound_off() as Bitmap;
			}
			e.target.addChild(nextBitmap);
			_sound_on = !_sound_on;
		}
		
		override public function isPlaying():Boolean {
			return _playing;
		}
	}
}