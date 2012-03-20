package com.socialvibe.core.ui
{
	import com.socialvibe.core.config.*;
	import com.socialvibe.core.utils.*;
	import com.socialvibe.core.ui.controls.SVText;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.text.*;

	public class SVRadioButton extends Sprite
	{
		public static const SELECTED:String     	= 'selected';
		public static const UNSELECTED:String     = 'unselected';
		
		protected var _width:Number;
		protected var _selected:Boolean;
		protected var _selectedColor:uint;
		protected var _label:SVText;
		
		protected var _fieldBackground:Sprite;
		protected var _dot:Sprite;
		
		public function SVRadioButton(label:String, x:Number, y:Number, selectedColor:uint = 0, selected:Boolean = false, w:Number = 22, labelColor:uint = 0xFFFFFF)
		{
			_width = w;
			_selectedColor = selectedColor;
			
			initRadio(selected);
			initLabel(label, labelColor);
			
			this.x = x;
			this.y = y;
			
			this.buttonMode = true;
			this.useHandCursor = true;
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		protected function initRadio(selected:Boolean):void
		{
			var g:Graphics = this.graphics;
			
			g.beginFill(0xFFFFFF, 0.3);
			g.drawRoundRect(0, 0, _width, _width, _width);
			
			_fieldBackground = new Sprite();
			_fieldBackground.x = 3;
			_fieldBackground.y = 3;
			addChild(_fieldBackground);
			
			g = _fieldBackground.graphics;
			
			g.beginFill(0xFFFFFF);
			g.drawRoundRect(0, 0, _width-6, _width-6, _width-6);
			
			_fieldBackground.filters = [ new GradientGlowFilter( 3, 45, [0, 0], [0.3, 0], [0, 255] ) ];
			
			_dot = new Sprite();
			_dot.x = 3;
			_dot.y = 3;
			addChild(_dot);
			
			g = _dot.graphics;
			
			g.beginFill(0x7D7D7D);
			g.drawRoundRect(0, 0, _width-6, _width-6, _width-6);
			g.drawRoundRect(_width/2-6, _width/2-6, 6, 6, 6);
			
			_dot.visible = false;
			_dot.filters = [ new GradientGlowFilter( 3, 45, [0, 0], [0.3, 0], [0, 255] ) ];
			
			if (selected)
				select();
			else
				unselect();
		}
		
		protected function initLabel(label:String, labelColor:uint):void
		{
			_label = new SVText(label, _width+3, 1, 12, false, labelColor);
			addChild(_label);
		}
		
		private function onClick(e:MouseEvent):void
	    {
	    	if (!_selected)
	    	{
	    		select();
	    	}
	    }
	    
	    public function select():void
	    {
	    	if (!_selected)
	    	{
		        _selected = true;
		        
		        _dot.visible = true;

		        dispatchEvent(new Event( SELECTED ));
		    }
	    }
	   
	    public function unselect():void
	    {
	        if (_selected)
	        {
	            _selected = false;
	       		
	       		_dot.visible = false;
	       		
	       		dispatchEvent(new Event( UNSELECTED ));
	        }
	    }

		public function isSelected():Boolean
	    {
	    	return _selected;
	    }
	}
}