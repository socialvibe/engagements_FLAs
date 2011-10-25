package com.socialvibe.core.ui.components
{
	import com.socialvibe.core.config.Services;
	import com.socialvibe.core.ui.controls.IConfigurableControl;
	import com.socialvibe.core.ui.controls.SVPollOption;
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.Point;
	
	public class SVPollOptionGroup extends Sprite implements IConfigurableControl, IControlGrouping
	{
		static public const DEFAULT_OPTION_SPACING:Number = 3;
		static public const DEFAULT_WIDTH:Number = 300;
		
		private var _optionWidth:Number;
		private var _optionHeight:Number;
		private var _backgroundColor:Number;
		private var _curveSize:Number;
		private var _labelX:Number;
		private var _textSize:Number;
		private var _textColor:uint;
		private var _selectedTextColor:uint;
		
		protected var _controlNames:Array = [];
		public var _controls:Array = [];
				
		public function SVPollOptionGroup()
		{	
			if (Services.BUILDER_MODE)
				addEventListener( Event.ADDED, onAdded, false, 0, true );
		}
		
		// if this looks hacky, its because IT IS
		protected function onAdded(e:Event):void
		{
			if (e.currentTarget != e.target)
				return;
			
			removeEventListener( Event.ADDED, onAdded );
			
			// look in parent for linked controls
			for ( var i:Number = 0; i < parent.numChildren; i++ )
			{
				var child:DisplayObject = parent.getChildAt( i );
				
				if ( _controlNames.indexOf( child.name ) != -1 && _controls.indexOf(child) == -1 )
					_controls.push( child );
			}
			
			this.parent.addEventListener( Event.ADDED, onSiblingAdded, false, 0, true );
		}
		
		protected function onSiblingAdded(e:Event):void
		{
			var sibling:DisplayObject = e.target as DisplayObject;
			
			if( sibling.parent != this.parent )
				return;
			
			// see if new sibling is a linked control
			if ( _controlNames.indexOf( sibling.name ) != -1 && _controls.indexOf(sibling) == -1 )
				_controls.push( sibling );
		}		
		
		public function addControl( control:DisplayObject ):void
		{
			_controls ||= [];
			_controls.push( control );
		}
		
		public function get controlNames():Array
		{
			_controlNames = [];
			
			for each ( var child:DisplayObject in _controls ) {
				_controlNames.push( child.name );
			}
			
			return _controlNames;
		}
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		override public function set x(value:Number):void
		{
			var deltaX:Number = value - this.x;
			super.x = value;

			for each( var pollOption:SVPollOption in _controls )
				pollOption.x += deltaX;				
		}
		
		override public function set y(value:Number):void
		{
			var deltaY:Number = value - this.y;
			super.y = value;
			
			for each( var pollOption:SVPollOption in _controls )
				pollOption.y += deltaY;			
		}
		
		public function set option_width(value:Number):void
		{
			_optionWidth = value;
			
			for each( var pollOption:SVPollOption in _controls )
				pollOption.width = _optionWidth;
		}
		
		public function set option_height(value:Number):void
		{
			_optionHeight = value;
			
			if (_controls && _controls.length > 0)
			{
				var currentY:Number = _controls[0].y;
				for each( var pollOption:SVPollOption in _controls )
				{
					pollOption.height = _optionHeight;
					pollOption.y = currentY;
					
					currentY += pollOption.displayHeight + DEFAULT_OPTION_SPACING;
				}
			}
		}
		
		public function set background_color(value:uint):void
		{
			_backgroundColor = value;

			for each( var pollOption:SVPollOption in _controls )
				pollOption.setConfig( { 'background_color': _backgroundColor.toString(16) } );
		}
		
		public function set curve_size(value:uint):void
		{
			_curveSize = value;
			
			for each( var pollOption:SVPollOption in _controls )
				pollOption.curve_size = _curveSize;	
		}
		
		public function set label_x(value:Number):void
		{
			_labelX = value;
			
			for each( var pollOption:SVPollOption in _controls )
				pollOption.label_x = _labelX;	
		}
		
		public function set text_size(value:uint):void
		{
			_textSize = value;
			
			for each( var pollOption:SVPollOption in _controls )
				pollOption.text_size = _textSize;
		}

		public function set text_color(value:uint):void
		{
			_textColor = value;
			
			for each( var pollOption:SVPollOption in _controls )
				pollOption.text_color = _textColor;
		}
		
		public function set selected_text_color(value:uint):void
		{
			_selectedTextColor = value;
			
			for each( var pollOption:SVPollOption in _controls )
				pollOption.selected_text_color = _selectedTextColor;
		}
	

		
		
//		public function set bold(value:Boolean):void
//		{
//			_bold = value;
//			
//			this.defaultTextFormat = new TextFormat(font_name, _fontSize, _color, _bold);
//			text = _str;
//		}
//		
//		public function set color(value:uint):void
//		{
//			_color = value;
//			
//			this.textColor = _color;
//		}
//		
//		override public function set width(value:Number):void
//		{
//			_width = value;
//			
//			super.width = isNaN(_width) ? this.textWidth+4 : _width;
//		}
		
		
		/* ==========================================
			IConfigurableControl functionality
		========================================== */
		public function getControlName():String { return 'poll_option_group'; }
		
		public function getConfigVars():Array
		{
			return [
				ConfigurableObjectUtils.numberVar('x', x), 
				ConfigurableObjectUtils.numberVar('y', y), 
				ConfigurableObjectUtils.numberVar('option_width', _optionWidth, DEFAULT_WIDTH),
				ConfigurableObjectUtils.numberVar('option_height', _optionHeight, 26),
				ConfigurableObjectUtils.colorVar('background_color', _backgroundColor, 'FF0000'), 
				ConfigurableObjectUtils.numberVar('curve_size', _curveSize, 26, {desc:"Radius (in pixels) of the poll options' rounded corners."}), 
				ConfigurableObjectUtils.numberVar('label_x', _labelX, 33 ),
				ConfigurableObjectUtils.numberVar('text_size', _textSize, 13),
				ConfigurableObjectUtils.arrayVar('linked_poll_options', controlNames ),
				ConfigurableObjectUtils.colorVar('text_color', _textColor, '000000'),
				ConfigurableObjectUtils.colorVar('selected_text_color', _selectedTextColor, '000000', {desc:"Color of poll option text when it is selected"})
			];
		}
		
		public function getConfig():Object
		{
			return ConfigurableObjectUtils.getConfigObject(this);
		}
		
		public function setConfig(config:Object):void
		{
			if ( !Services.BUILDER_MODE )
				return;
			
			config = ConfigurableObjectUtils.decodeConfig( config, this );
			
			for (var configName:Object in config)
			{
				switch (configName)
				{
					case 'x':
						x = config[configName];
						break;
					case 'y':
						y = config[configName];
						break;
					case 'option_width':
						option_width = config[configName];
						break;
					case 'option_height':
						option_height = config[configName];
						break;
					case 'background_color':
						background_color = config[configName];
						break;
					case 'curve_size':
						curve_size = config[configName];
						break;
					case 'label_x':
						label_x = config[configName];
						break;
					case 'text_size':
						text_size = config[configName];
						break;
					case 'linked_poll_options':
						_controlNames = config[configName];
						break;
					case 'text_color':
						text_color = config[configName];
						break;
					case 'selected_text_color':
						selected_text_color = config[configName];
						break;
				}
			}
		}
	}
}