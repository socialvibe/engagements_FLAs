package com.socialvibe.core.ui.controls
{
	import com.greensock.TweenLite;
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.net.*;
	
	public class SVSurveyOption extends Sprite implements IConfigurableControl
	{
		static public const SELECTED:String = 'surveyOptionSelected';
		
		public var category:Number;
		public var vote:Number;
		
		protected var _radio:CustomRadioButton;
		protected var _check:CustomMiniCheckbox;
		protected var _answer:SVText;
		protected var _highlight:Sprite;
		
		protected var _text:String;
		protected var _answerWidth:Number;
		protected var _checkAll:Boolean;
		
		protected var _selected:Boolean;
		protected var _effects:Array;
		
		public function SVSurveyOption(answer:String = '', answerWidth:Number = 0, checkAll:Boolean = false)
		{
			_text = answer;
			_answerWidth = answerWidth;
			_checkAll = checkAll;
			
			createQuestion();
			
			useHandCursor = buttonMode = true;
			addEventListener(MouseEvent.ROLL_OVER, function(e:Event):void {
				TweenLite.to(_highlight, .3, {alpha:1});
			});
			addEventListener(MouseEvent.ROLL_OUT, function(e:Event):void {
				TweenLite.to(_highlight, .3, {alpha:0});
			});
			addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function unselect():void
		{
			_selected = false;
			_radio.unselected();
		}
		
		private function onClick(e:Event):void
		{
			if (_radio)
			{
				_selected = true;
				_radio.selected();
			}
			else if (_check)
			{
				_check.isSelected() ? _check.unselect() : _check.select();
			}
			
			dispatchEvent(new Event(SELECTED, true));
		}
		
		protected function createQuestion():void
		{
			while (numChildren > 0)
				removeChildAt(0);
			
			_radio = null;
			_check = null;
			
			if (_checkAll)
			{
				_check = new CustomMiniCheckbox('', 0, 0);
				addChild(_check);
			}
			else
			{
				_radio = new CustomRadioButton();
				addChild(_radio);
			}
			
			_answer = new SVText(_text, (_checkAll ? 20 : 25), 0, 13, false, 0xffffff, _answerWidth).toHTML();
			_answer.multiline = true;
			_answer.y  = (_checkAll ? 4 : 8) - _answer.textHeight/2; 
			addChild(_answer);
			
			_highlight = new Sprite();
			_highlight.graphics.beginFill(0x287289, 1);
			_highlight.graphics.drawRoundRect(-5, -5, _answer.width + 20, (_checkAll ? 22 : 30), (_checkAll ? 8 : 30));
			_highlight.alpha = 0;
			addChildAt(_highlight, 0);
		}
		
		override public function get height():Number { return _checkAll ? 27 : 35; }
		
		public function get selected():Boolean
		{
			return _selected || (_check && _check.isSelected());
		}
		
		public function isCheckAll():Boolean { return _checkAll; }
		
		public function get text():String { return _text; }
		
		public function set text(value:String):void
		{
			_text = value;
			
			createQuestion();
		}
		
		public function set answer_width(value:Number):void
		{
			_answerWidth = value;
			
			createQuestion();
		}
		
		public function set check_all(value:Boolean):void
		{
			_checkAll = value;
			
			createQuestion();
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'survey_answer'; }
		
		public function getConfigVars():Array
		{
			return [
				ConfigurableObjectUtils.numberVar('x', x), 
				ConfigurableObjectUtils.numberVar('y', y), 
				ConfigurableObjectUtils.stringVar('text', _text), 
				ConfigurableObjectUtils.numberVar('answer_width', _answerWidth), 
				ConfigurableObjectUtils.booleanVar('check_all', _checkAll, null, {hidden:true}),
				ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true})];
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
					case 'text':
						text = config[configName];
						break;
					case 'answer_width':
						answer_width = config[configName];
						break;
					case 'check_all':
						check_all = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
				}
			}
		}
	}
}

import flash.display.*;
import flash.events.*;
import flash.filters.*;
import flash.net.*;

import com.socialvibe.core.ui.controls.*;

internal class CustomRadioButton extends Sprite
{
	[Embed (source = "assets/images/selected_radio_btn.png")]
	private var DefaultSelectedBtn:Class;
	
	[Embed (source = "assets/images/unselected_radio_btn.png")]
	private var DefaultUnselectedBtn:Class;
	
	public function CustomRadioButton()
	{
		super();
		
		addChild(new DefaultUnselectedBtn() as Bitmap);
	}
	
	public function selected():void
	{
		removeChildAt(0);
		addChild(new DefaultSelectedBtn() as Bitmap);
	}
	
	public function unselected():void
	{
		removeChildAt(0);
		addChild(new DefaultUnselectedBtn() as Bitmap);
	}
}

internal class CustomMiniCheckbox extends Sprite
{
	protected var _selected:Boolean;
	protected var _label:SVText;
	
	public function CustomMiniCheckbox(label:String, x:Number, y:Number)
	{
		_label = new SVText(label, 18, 0, 13, false, 0xffffff);
		addChild(_label);
		
		var g:Graphics = graphics;
		g.beginFill(0x151f25);
		g.drawRect(0, 0, 13, 13);
		g.beginFill(0x3d4448);
		g.drawRect(1, 1, 11, 11);
		g.beginFill(0xffffff);
		g.drawRect(2, 2, 9, 9);
		
		this.x = x;
		this.y = y;
	}
	
	public function select():void
	{
		if (!_selected)
		{
			_selected = true;
			
			var g:Graphics = this.graphics;
			g.beginFill(0x0076a3);
			g.drawRect(2, 2, 9, 9);
			g.beginFill(0x3d4448);
			g.drawRect(6, 6, 2, 2);
		}
	}
	
	public function unselect():void
	{
		if (_selected)
		{
			_selected = false;
			
			var g:Graphics = this.graphics;
			g.beginFill(0xffffff);
			g.drawRect(2, 2, 9, 9);
		}
	}
	
	public function isSelected():Boolean
	{
		return _selected;
	}
}