package com.socialvibe.core.ui
{
	import com.socialvibe.core.ui.controls.SVText;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;

	public class SVCheckbox extends Sprite
	{
		public static const SELECTED:String     = 'selected';
		public static const UNSELECTED:String   = 'unselected';
		
		protected var _selected:Boolean;
		protected var _label:SVText;
		
		[Embed(source="assets/images/checkbox.png")]
		public static var checkboxImg:Class;
		
		[Embed(source="assets/images/checkbox_checked.png")]
		public static var checkboxCheckedImg:Class;
		
		public function SVCheckbox(label:String, x:Number, y:Number, selected:Boolean = false, labelColor:uint = 0xFFFFFF)
		{
			initImages(selected);
			initLabels(label, labelColor);
			
			this.x = x;
			this.y = y;
			
			this.buttonMode = true;
			this.useHandCursor = true;
			addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		protected function initImages(selected:Boolean):void
		{
			var checked:Bitmap = new checkboxCheckedImg() as Bitmap;
			checked.smoothing = true;
			addChild(checked);
			
			var unchecked:Bitmap = new checkboxImg() as Bitmap;
			unchecked.smoothing = true;
			addChild(unchecked);
			
			if (selected)
				select();
		}
		
		protected function initLabels(label:String, labelColor:uint):void
		{
			_label = new SVText(label, 25, 3, 11, false, labelColor);
			addChild(_label);
			
			_label.width = _label.textWidth+4;
		}
		
		private function onClick(e:MouseEvent):void
	    {
	    	if (_selected)
	    	{
	    		unselect();
	    	}
	    	else
	    	{
	        	select();
	     	}
	    }
	    
	    public function enable():void
	    {
	    	this.mouseEnabled = true;
	    }
	    
	    public function disable():void
	    {
	    	this.mouseEnabled = false;
	    }
	    
	    public function select(quiet:Boolean = false):void
	    {
	    	if (!_selected)
	    	{
		        _selected = true;
		        
		        this.swapChildrenAt(0, 1);

				if (!quiet)
			        dispatchEvent(new Event( SELECTED ));
		    }
	    }
	   
	    public function unselect(quiet:Boolean = false):void
	    {
	        if (_selected)
	        {
	            _selected = false;
	       		
	       		this.swapChildrenAt(0, 1);
	       		
	       		if (!quiet)
			        dispatchEvent(new Event( UNSELECTED ));
	        }
	    }

		public function isSelected():Boolean
	    {
	    	return _selected;
	    }
	    
	    public function set label(value:String):void
	    {
	    	_label.text = value;
	    }
	    
	    public function get textField():TextField { return _label; }
	}
}