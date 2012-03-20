package com.toyota.prius.puzzle.elements
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.text.TextFormatAlign;
	import flash.events.MouseEvent;
	
	public class Button extends MovieClip
	{
		
		private var _text	:String;
		private var _label	:TextField;
		private var _format	:TextFormat;
		
		public function Button(text:String)
		{
			super();
			_text = text;
			construct();
		}
		
		protected function construct():void
		{
			_format			= new TextFormat('Verdana',10,0x00);
			_format.align	= TextFormatAlign.CENTER;
			_label			= new TextField();
			_label.selectable = false;
			_label.width 	= 100;
			_label.height 	= 15;
			_label.setTextFormat(_format);
			_label.defaultTextFormat = _format;
			_label.text = _text;
			
			graphics.lineStyle(0,0,1,true,'normal',CapsStyle.NONE,JointStyle.MITER,0);
			graphics.beginFill(0xD0D0CF);
			graphics.drawRect(1,1,100,13);
			graphics.endFill();
			
			addChild(_label);
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDownHandler);
			
		}
		
		private function onMouseDownHandler(e:MouseEvent):void
		{
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			graphics.lineStyle(0,0,1,true,'normal',CapsStyle.NONE,JointStyle.MITER,0);
			graphics.beginFill(0xEBEBEA);
			graphics.drawRect(1,1,100,13);
			graphics.endFill();
		}
		
		private function onMouseUpHandler(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUpHandler);
			graphics.lineStyle(0,0,1,true,'normal',CapsStyle.NONE,JointStyle.MITER,0);
			graphics.beginFill(0xD0D0CF);
			graphics.drawRect(1,1,100,13);
			graphics.endFill();
		}
		
		public function setLabel( str:String ):void
		{
			_text = str;
			_label.text = _text; 
		}
	}

}