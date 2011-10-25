package cc.text
{
import flash.text.TextFormat;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.GridFitType;
import flash.text.AntiAliasType;
import flash.text.TextFieldType;
import flash.events.FocusEvent;
import cc.utils.StringUtils;
	
	public class Text extends TextField
	{
		protected var _width	:int;
		protected var _height	:int;
		protected var _format	:TextFormat;
		protected var _input	:Boolean;
		protected var _default 	:String;
		
		public function Text(format:TextFormat,text:String,width:int=1,height:int=-1,input:Boolean=false)
		{
			_format 	= format;
			_width 		= width;
			_height 	= height;
			_input		= input;
			_default 	= text;
			
			construct();
			if(_format == null)
			{
				_format 		= new TextFormat('Verdana',11,0x00);
				embedFonts 		= false;
			}
			setTextFormat(_format);
			defaultTextFormat 	= _format;
			this.text	 		= text;
		}
		
		protected function construct():void
		{
			
			if(_width<0)
			{
				this.multiline 	= false;
				this.autoSize 	= TextFieldAutoSize.RIGHT;
			}
			else if(_width==0)
			{
				this.multiline 	= false;
				this.autoSize 	= TextFieldAutoSize.CENTER;
			}
			else if(_width==1)
			{
				this.multiline 	= false;
				this.autoSize 	= TextFieldAutoSize.LEFT;
			}
			else
			{
				this.width 		= _width;
			}
			
			if(_height>1)
			{
				height 			= _height;
				this.multiline 	= true;
			}
			else if(_height==0)
			{
				this.height = 2;
				this.multiline 	= true;
				this.wordWrap	= true;
				this.autoSize 	= TextFieldAutoSize.LEFT;
			}
			
			if(_input)
			{
				this.type		= TextFieldType.INPUT;
				addEventListener(FocusEvent.FOCUS_IN, 	onFocusIn);
				addEventListener(FocusEvent.FOCUS_OUT, 	onFocusOut);
			}
			else
			{
				this.selectable		= false;
				this.mouseEnabled 	= false;
			}
			this.embedFonts		= true;
			this.gridFitType 	= GridFitType.SUBPIXEL;
			this.antiAliasType 	= AntiAliasType.ADVANCED;
			
		}
		
		protected function onFocusIn(e:FocusEvent):void
		{
			if(text==_default)	text = '';
		}
		
		protected function onFocusOut(e:FocusEvent):void
		{
			if(text=='')		text = _default;
		}
		
		public function set defaultText(value:String):void
		{
			if(text==_default)
				text = value;
			_default = value;
		}
		
		public function get isChanged():Boolean
		{
			return (text!=''&&text!=_default);
		}
		
		public function get defaultText():String
		{
			return _default;
		}
		
		override public function toString():String
		{
			return StringUtils.formatToString(this, 'text');
		}
		
	}

}