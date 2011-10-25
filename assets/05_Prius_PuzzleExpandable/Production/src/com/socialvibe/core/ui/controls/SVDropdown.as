package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	import com.socialvibe.core.utils.SVEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.Point;
	import flash.text.*;
	import flash.utils.*;
	
	public class SVDropdown extends Sprite implements IConfigurableControl
	{
		public static const VALUE_CHANGE:String = 'dropDownValueChange';
		
		[Embed (source="assets/images/drop_down_arrow.png")]
		public static var dropdownBtnClass:Class;
		
		protected var _width:Number;
		protected var _height:Number;
		protected var _expandedHeight:Number;
		protected var _curveSize:Number;
		protected var _accentColor:uint;
		protected var _defaultLabel:String;
		protected var _itemList:String;
		
		protected var _inputArea:Sprite;
		protected var _selectedField:SVText;
		
		protected var _actions:Array;
		protected var _effects:Array;
		
		protected var _button:Sprite;
		protected var _btnHover:Bitmap;
		
		protected var _items:Array;
		protected var _dropdown:Sprite;
		protected var _expanded:Boolean;
		
		protected var _selectedLabel:String;
		protected var _selectedValue:Object;
		
		public function SVDropdown( width:Number = 180, height:Number = 24, curveSize:Number = 12, accentColor:uint = 0x000000, items:Array = null, defaultLabel:String = "Select an option" )
		{
			_items = items || [];
			
			_width = width;
			_height = height;
			_curveSize = curveSize;
			_accentColor = accentColor;
			_defaultLabel = defaultLabel;
			
			recreate();
			
			buttonMode = useHandCursor = true;
			addEventListener(MouseEvent.CLICK, onDropdown, false, 0, true);
		}
		
		protected function recreate():void
		{
			while (numChildren > 0)
				removeChildAt(0);
			
			_expandedHeight = _items.length * 18 + 10;
			
			_inputArea = new Sprite();
			addChild( _inputArea );
			
			drawBackground();
			addTextField();
			addButton();
			addDropdown();
			
			_inputArea.filters = [ new DropShadowFilter( 4, 45, 0, 0.2, 4, 4, 1, 1, true ) ];
		}
		
		protected function drawBackground(rollover:Boolean = false):void
		{
			var g:Graphics = this.graphics;
			g.clear();
			
			g.beginFill( 0xacacac );
			g.drawRoundRect( 0, 0, _width, _height, _curveSize );
			
			g = _inputArea.graphics;
			g.clear();
			
			g.beginFill( rollover ? 0xdbdbdb : 0xe8e8e8 );
			g.drawRoundRect( 1, 1, _width - 2, _height - 2, _curveSize );
		}
		
		protected function addTextField():void
		{			
			_selectedField = new SVText( _defaultLabel, 5, 0, 12, false, 0x555555, _width - 6 );
			_selectedField.y = Math.floor(_height - _selectedField.textHeight)/2 -1;
			_selectedField.height = _height;
			_inputArea.addChild( _selectedField );
		}
		
		protected function addButton():void
		{
			_button = new Sprite();
			_button.addChild(new dropdownBtnClass());
			_button.x = _width - _button.width - 5;
			_button.y = Math.ceil((_height - _button.height)/2);
			addChild(_button);
			
			var g:Graphics = _button.graphics;
			g.beginFill(0xaaaaaa);
			g.drawRect(-6, -_button.y+2, 2, _height-3);
			
			addEventListener(MouseEvent.ROLL_OVER, function(e:Event):void {
				drawBackground(true);
			});
			
			addEventListener(MouseEvent.ROLL_OUT, function(e:Event):void {
				drawBackground();
			});
			
			addEventListener(MouseEvent.CLICK, function(e:Event):void {
				drawBackground();
			});
		}
		
		protected function addDropdown():void
		{
			_dropdown = new Sprite();
			
			_dropdown.focusRect = false;
			
			var g:Graphics = _dropdown.graphics;
			g.beginFill( 0xdedfdf );
			g.drawRect( 0, 0, _width, _expandedHeight );
			g.beginFill( 0xffffff );
			g.drawRect( 1, 1, _width-2, _expandedHeight-2 );
			
			for (var i:int=0; i<_items.length; i++)
			{
				var dItem:DropdownItem = new DropdownItem(_items[i].label, _accentColor, _items[i].value, _width-2);
				dItem.addEventListener(DropdownItem.ITEM_SELECTED, onItemSelected, false, 0, true);
				dItem.x = 1;
				dItem.y = 5 + (i*18);
				_dropdown.addChild(dItem);
			}
			
			_dropdown.filters = [ new DropShadowFilter( 4, 45, 0, 0.2 ) ];
		}
		
		protected function onDropdown(e:Event):void
		{
			if (_expanded)
			{
				setTimeout(addEventListener, 250, MouseEvent.CLICK, onDropdown, false, 0, true);
				
				if (_dropdown.hasEventListener(FocusEvent.FOCUS_OUT))
					_dropdown.removeEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
				
				if (stage && stage.contains(_dropdown))
					stage.removeChild(_dropdown);
			}
			else
			{
				var dropdownOnStage:Point = parent.localToGlobal(new Point(this.x, this.y));
				_dropdown.x = dropdownOnStage.x;
				_dropdown.y = dropdownOnStage.y + _height;
				stage.addChild(_dropdown);
				
				_dropdown.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut, false, 0, true);
				removeEventListener(MouseEvent.CLICK, onDropdown);
				
				stage.focus = _dropdown;
			}
			
			_expanded = !_expanded;
		}
		
		protected function onFocusOut(e:FocusEvent):void
		{
			if (e.relatedObject == null || e.relatedObject.parent != _dropdown)
				onDropdown(null);
		}
		
		protected function onItemSelected(e:SVEvent):void
		{
			setTimeout(function():void {
				onDropdown(null);
				update(e.data);
				_inputArea.parent.dispatchEvent(new SVEvent(ConfigurableObjectUtils.TRIGGER_ACTION, _actions, true, true));
			}, 230);
		}
		
		protected function update(selection:Object):void
		{
			if (_selectedValue != selection.value)
			{
				_selectedValue = selection.value;
				_selectedLabel = selection.label;
				_selectedField.text = _selectedLabel;
				
				dispatchEvent( new SVEvent( VALUE_CHANGE, _selectedValue, false, false ) );
			}
		}
		
		public function set items(values:Array):void
		{
			_items = values || [];
			
			recreate();
		}
		
		public function set value(value:Object):void
		{
			for (var i:int=0; i<_items.length; i++)
			{
				if (_items[i].value == value)
				{
					update(_items[i]);
					break;
				}
			}
		}
		
		public function get value():Object { return _selectedValue; }
		public function get label():String { return _selectedLabel; }
		
		
		
		
		
		
		override public function set width(value:Number):void
		{
			_width = value;
			
			recreate();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			
			recreate();
		}
		
		public function set accent_color(value:Number):void
		{
			_accentColor = value;
			
			recreate();
		}
		
		public function set default_label(value:String):void
		{
			_defaultLabel = value;
			
			recreate();
		}
		
		public function set curve_size(value:Number):void
		{
			_curveSize = value;
			
			recreate();
		}
		
		public function set item_list(value:String):void
		{
			_itemList = value;
			
			var items:Array = _itemList.split(',');
			for (var i:int=0; i<items.length; i++)
				items[i] = {label:items[i], value:items[i]};
			
			this.items = items;
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'dropdown'; }
		
		public function getConfigVars():Array
		{
			return [
				ConfigurableObjectUtils.numberVar('x', x), 
				ConfigurableObjectUtils.numberVar('y', y), 
				ConfigurableObjectUtils.numberVar('width', _width), 
				ConfigurableObjectUtils.numberVar('height', _height), 
				ConfigurableObjectUtils.colorVar('accent_color', _accentColor),
				ConfigurableObjectUtils.stringVar('default_label', _defaultLabel), 
				ConfigurableObjectUtils.numberVar('curve_size', _curveSize), 
				ConfigurableObjectUtils.stringVar('item_list', _itemList, null, {desc:'comma separated list of values.'}),
				ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true}),
				ConfigurableObjectUtils.arrayVar('actions', _actions, null, {hidden:true, desc:"selecting an option in the dropdown"})];
		}
		
		public function getConfig():Object
		{
			return ConfigurableObjectUtils.getConfigObject(this);
		}
		
		public function setConfig(config:Object):void
		{
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
					case 'width':
						width = config[configName];
						break;
					case 'height':
						height = config[configName];
						break;
					case 'accent_color':
						accent_color = config[configName];
						break;
					case 'default_label':
						default_label = config[configName];
						break;
					case 'curve_size':
						curve_size = config[configName];
						break;
					case 'item_list':
						item_list = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
					case 'actions':
						_actions = config[configName];
						break;
				}
			}
		}
	}
}

import com.socialvibe.core.ui.controls.SVText;
import com.socialvibe.core.utils.SVEvent;

import flash.display.*;
import flash.events.*;
import flash.filters.*;
import flash.text.*;
import flash.utils.*;

internal class DropdownItem extends Sprite
{
	public static const ITEM_SELECTED:String = 'dropdownItemSelected';
	
	private var _label:SVText;
	private var _accentColor:uint;
	private var _value:Object;
	private var _width:Number;
	private var _blinkIdx:Number;
	
	public function DropdownItem(label:String, accentColor:uint, value:Object, width:Number):void
	{
		_accentColor = accentColor;
		_value = value;
		_width = width;
		
		_label = new SVText(label, 3, 0, 11, false, 0x353535, width-6);
		addChild(_label);
		
		buttonMode = useHandCursor = true;
		this.addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
		this.addEventListener(MouseEvent.ROLL_OVER, onRollOver, false, 0, true);
		this.addEventListener(MouseEvent.ROLL_OUT, onRollOut, false, 0, true);
	}
	
	private function blink():void
	{
		if (_blinkIdx > 0)
		{
			if (_blinkIdx % 2 == 0)
			{
				this.graphics.clear();
			}
			else
			{
				this.graphics.beginFill(_accentColor);
				this.graphics.drawRect(0, 0, _width, 18);
			}
			_blinkIdx -= 1;
		}
	}
	
	private function onClick(e:Event):void
	{
		dispatchEvent(new SVEvent(ITEM_SELECTED, {label:_label.text, value:_value}));
		
		_blinkIdx = 4;
		blink();
		setInterval(blink, 50);
	}
	
	private function onRollOut(e:Event):void
	{
		this.graphics.clear();
		_label.textColor = 0x353535;
	}
	
	private function onRollOver(e:Event):void
	{
		this.graphics.beginFill(_accentColor);
		this.graphics.drawRect(0, 0, _width, 18);
		_label.textColor = 0xffffff;
	}
}