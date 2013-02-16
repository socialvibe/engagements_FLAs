package com.socialvibe.core.ui.controls
{
	import com.greensock.TweenLite;
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	
	import flash.display.*;
	import flash.events.*;
	
	public class SVPollOption extends Sprite implements IConfigurableControl
	{
		// events
		public static const SELECTED:String = 'pollOptionSelected';
		
		// display options
		protected var _width:Number;
		protected var _height:Number;
		protected var _backgroundColor:uint;
		protected var _curveSize:Number;
		
		protected var _slideAnimation:Boolean = true;
		
		protected var _textSize:Number = 13;
		protected var _bold:Boolean = false;
		
		protected var _labelX:Number = 33;
		protected var _labelY:Number;
		protected var _labelAlpha:Number = 0.9;
		protected var _labelMultiline:Boolean = false;
		
		protected var _radioButtonX:Number = 3;
		
		protected var _textColor:uint = 0x000000;
		protected var _selectedTextColor:uint = 0x000000;
		protected var _resultTextColor:uint = 0x000000;
		protected var _percentageTextColor:uint = 0xffffff;
				
		protected var _useRadioButtons:Boolean = true;
		
		// data
		protected var _vote:Number;
		protected var _category:Number;
		protected var _labelText:String = '[label]';
		protected var _correctAnswer:Boolean = false;
		
		protected var _selected:Boolean = false;
		
		protected var _voteCount:Number = 0;
		protected var _totalVoteCount:Number = 0;
		
		protected var _lastDrawCalled:Function;
		
		
		// display objects
		protected var _backgroundLayer:Sprite;
		protected var _animationMask:Sprite;
		
		protected var _label:SVText;
		
		protected var _effects:Array;
		
		// embeds
		[Embed (source = "assets/images/selected_radio_btn.png")]
		private var DefaultSelectedBtn:Class;
		
		[Embed (source = "assets/images/unselected_radio_btn.png")]
		private var DefaultUnselectedBtn:Class;


		
		
		public function SVPollOption(width:Number = 300, height:Number = 26)
		{
			_width = width;
			_height = height;
			
			_backgroundColor = 0xff0000;
			_curveSize = 26;
			
			addEventListener(Event.ADDED_TO_STAGE, init, false, 0, true);
		}
		
		protected function init(e:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			_backgroundLayer = new Sprite();
			addChildAt(_backgroundLayer, 0);
			
			drawMask();
			addLabel(); 
						
			if (_selected)
				drawSelected();
			else
				drawUnselected();
			
			enableMouseEvents(true);
		}
		
		
		
		/* =================================
			Public Functions
		================================= */
		public function select(e:Event = null):void
		{
			if (_selected || !mouseEnabled) return;
			
			_selected = true;
			disableMouseEvents();
			
			drawSelected();

			if (_slideAnimation) {
				_animationMask.x = -3/4 * _width;
				TweenLite.to( _animationMask, .7, {x: 0} );				
			}
			
			dispatchEvent( new Event(SELECTED, true, true) );
		}
		
		public function unselect(e:Event = null):void
		{
			if (!_selected) return;
			
			_selected = false;
			enableMouseEvents();
			
			drawUnselected();
		}
		
		public function disable():void
		{
			disableMouseEvents();
		}
		
		public function loadResults( voteCount:Number, totalVoteCount:Number ):void
		{
			_voteCount = voteCount;
			_totalVoteCount = totalVoteCount;
		}
		
		public function showResults():void
		{
			_voteCount += ( isSelected() ? 1 : 0 );
			_totalVoteCount += 1;
			
			disableMouseEvents();
			drawResult();
		}
		
		public function showQuizResults():void
		{
			disableMouseEvents();
			
			if ( _correctAnswer == true )
				drawCorrect();	
			else
				drawIncorrect();
		}

			
		public function isSelected():Boolean { return _selected; }
		public function get label():String { return _labelText; }
		public function get displayWidth():Number { return _width; }		
		public function get displayHeight():Number { return _height; }
		
		// set vote and category values
		public function get vote():Number { return _vote; }
		public function set vote(value:Number):void { _vote = value; }
		public function get category():Number { return _category; }
		public function set category(value:Number):void { _category = value; }
		
		// set vote counts
		public function get voteCount():Number { return _voteCount; }
		public function set voteCount(value:Number):void { _voteCount = value; }
		public function get totalVoteCount():Number { return _totalVoteCount; }
		public function set totalVoteCount(value:Number):void { _totalVoteCount = value; }		

		
		/* =================================
			Drawing and Display Functions
		================================= */
		protected function drawSelected():void
		{			
			clear();
						
			if (_useRadioButtons)
			{
				var selectedBtn:Bitmap = new DefaultSelectedBtn() as Bitmap;
				selectedBtn.smoothing = true;
				selectedBtn.x = _radioButtonX;
				selectedBtn.y = (_height - selectedBtn.height)/2;
				_backgroundLayer.addChild(selectedBtn);
			}
			
			var g:Graphics = _backgroundLayer.graphics;
			g.beginFill(_backgroundColor, 1);
			g.drawRoundRect(0, 0, _width, _height, _curveSize);
			
			_lastDrawCalled = drawSelected;
			_label.textColor = _selectedTextColor;
		}
		
		protected function drawUnselected():void
		{
			clear();
			
			if (_useRadioButtons)
			{				
				var unselectedBtn:Bitmap = new DefaultUnselectedBtn() as Bitmap;
				unselectedBtn.smoothing = true;
				unselectedBtn.x = _radioButtonX;
				unselectedBtn.y = (_height - unselectedBtn.height)/2;
				_backgroundLayer.addChild(unselectedBtn);	
			}
			
			var g:Graphics = _backgroundLayer.graphics;
			g.beginFill(_backgroundColor, 0);
			g.drawRoundRect(0, 0, _width, _height, _curveSize);			
			
			_lastDrawCalled = drawUnselected;
			_label.textColor = _textColor;	
		}
		
		protected function drawRollover():void
		{
			clear();
			
			if (_useRadioButtons)
			{				
				var unselectedBtn:Bitmap = new DefaultUnselectedBtn() as Bitmap;
				unselectedBtn.smoothing = true;
				unselectedBtn.x = _radioButtonX;
				unselectedBtn.y = (_height - unselectedBtn.height)/2;
				_backgroundLayer.addChild(unselectedBtn);	
			}
			
			var g:Graphics = _backgroundLayer.graphics;
			g.beginFill(_backgroundColor, .45);
			g.drawRoundRect(0, 0, _width, _height, _curveSize);
			
			_lastDrawCalled = drawRollover;
			_label.textColor = _textColor;			
		}
		
		protected function drawResult():void
		{
			clear();
			
			var g:Graphics = _backgroundLayer.graphics;
			g.beginFill(_backgroundColor, .35);
			g.drawRoundRect(0, 0, _width, _height, 6);			
			
			var resultBar:Sprite = new Sprite();
			_backgroundLayer.addChild(resultBar);
			
			g = resultBar.graphics;
			g.beginFill(_backgroundColor, 1);
			g.drawRoundRect(0, 0, _width, _height, 6);			
			
			_backgroundLayer.mask = null;				
			if ( _animationMask && contains( _animationMask ) )
				removeChild( _animationMask );
			
			var resultsMask:Sprite = new Sprite();
			
			resultBar.addChild(resultsMask);
			resultBar.mask = resultsMask;
			
			g = resultsMask.graphics;
			g.beginFill(_backgroundColor, 1);
			g.drawRoundRect(0, 0, _width, _height, 6);			

			var percentage:Number = (_totalVoteCount == 0) ? 0 : _voteCount/_totalVoteCount; 
			
			resultsMask.x = -_width;
			TweenLite.to( resultsMask, .7, {x: (percentage - 1) *_width } );
			
			var percent:SVText = new SVText(Math.round(percentage * 100).toString() + "%", 0, 0, 11, true, _percentageTextColor);
			percent.x = (_label.x - percent.width)/2;
			percent.y = (_height - percent.height)/2;
			_backgroundLayer.addChild(percent);
			
			_lastDrawCalled = drawResult;
		}	
		
		protected function drawCorrect():void
		{
			var g:Graphics;
			
			if (_selected) {		
				g = _backgroundLayer.graphics;
				g.beginFill(_backgroundColor, 1);
				g.drawRoundRect(0, 0, _width, _height, _curveSize);		
				
				_label.text = "Correct!";
				_label.y = (_height - _label.textHeight)/2-2;
				TweenLite.from( _label, 0.75, { alpha: 0 } );
				
			}
			else
			{
				var flashLayer:Sprite = new Sprite();
				addChildAt( flashLayer, 0 );
				
				g = flashLayer.graphics;
				g.beginFill(_backgroundColor, 1);
				g.drawRoundRect(0, 0, _width, _height, _curveSize);
				
				TweenLite.from( flashLayer, 0.25, { alpha: 0 } );
				TweenLite.to( flashLayer, 0.25, { alpha: 0, delay: 0.25, overwrite: false } );
				TweenLite.to( flashLayer, 0.25, { alpha: 1, delay: 0.5, overwrite: false } );
				TweenLite.to( flashLayer, 0.25, { alpha: 0, delay: 0.75, overwrite: false } );
				TweenLite.to( flashLayer, 0.25, { alpha: 1, delay: 1, overwrite: false } );
				TweenLite.to( flashLayer, 0.25, { alpha: 0, delay: 1.25, overwrite: false } );
			}
			
			_lastDrawCalled = drawCorrect;
		}
		
		protected function drawIncorrect():void
		{
			if (_selected) {		
				var g:Graphics = _backgroundLayer.graphics;
				g.beginFill(_backgroundColor, 1);
				g.drawRoundRect(0, 0, _width, _height, _curveSize);		
				
				_label.text = "Incorrect!";
				_label.y = (_height - _label.textHeight)/2-2;
			}
		}
		
		// added for on the fly changes to background vars
		protected function redraw():void
		{
			if (_lastDrawCalled != null)
			{
				drawMask();
				addLabel();
				_lastDrawCalled();
			}
			
		}
		
		protected function addLabel():void
		{
			if (_label != null && contains(_label))
				removeChild( _label );
			
			_label = new SVText( _labelText, _labelX, 0, _textSize, _bold, _textColor, _width - 33);
			_label.y = _labelY = Math.round( isNaN(_labelY) ? (_height - _label.height)/2 : _labelY );
			_label.alpha = _labelAlpha;
			_label.multiline = _labelMultiline;
			addChild(_label);
		}
		
		protected function drawMask():void
		{
			_backgroundLayer.mask = null;
			if (_animationMask != null && contains(_animationMask)) {
				removeChild(_animationMask);
			}
			
			_animationMask = new Sprite();
			var g:Graphics = _animationMask.graphics;
			g.beginFill(_backgroundColor);
			g.drawRoundRect(0, 0, _width, _height, _curveSize);		
			
			if (_slideAnimation)
			{
				addChildAt(_animationMask, 0);
				_backgroundLayer.mask = _animationMask;
			}
		}
	
		
		/* =================================
			Event Handlers
		================================= */
		protected function onRollover(e:Event):void
		{
			if (_selected || !mouseEnabled) return;
			
			drawRollover();
		}
		
		protected function onRollout(e:Event):void
		{
			if (_selected || !mouseEnabled) return;
			
			drawUnselected();
		}
		
		
		
		/* =================================
			Utility Functions
		================================= */
		protected function clear():void
		{
			var g:Graphics = _backgroundLayer.graphics;
			g.clear();
			
			while (_backgroundLayer.numChildren > 0)
				_backgroundLayer.removeChildAt(0);			
		}
		
		protected function enableMouseEvents(forceEnable:Boolean = false):void
		{
			if (!forceEnable && mouseEnabled) return;
			
			addEventListener(MouseEvent.CLICK, select, false, 0, true);
			addEventListener(MouseEvent.ROLL_OVER, onRollover, false, 0, true);
			addEventListener(MouseEvent.ROLL_OUT, onRollout, false, 0, true);
			mouseEnabled = useHandCursor = buttonMode = true;			
		}
		
		protected function disableMouseEvents():void
		{
			if (!mouseEnabled) return;
			
			removeEventListener(MouseEvent.CLICK, select);
			removeEventListener(MouseEvent.ROLL_OVER, onRollover);
			removeEventListener(MouseEvent.ROLL_OUT, onRollout);
			mouseEnabled = useHandCursor = buttonMode = false;							
		}
		
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		public function set curve_size(value:uint):void
		{
			_curveSize = value;
			redraw();
		}	
		
		public function set background_color(value:uint):void
		{
			_backgroundColor = value;
			redraw();
		}	
		
		override public function set width(value:Number):void
		{
			_width = value;
			redraw();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			redraw();
		}
				
		public function set label(value:String):void{
			_labelText = value;
			redraw();
		}
		
		public function set label_x(value:Number):void{
			_labelX = value;
			
			if ( _label )
				_label.x = _labelX;
		}

		public function set label_y(value:Number):void{
			_labelY = value;
			
			if ( _label )
				_label.y = _labelY;
		}
		
		public function set label_alpha(value:Number):void{
			_labelAlpha = value;
			
			if ( _label )
				_label.alpha = _labelAlpha;
		}
		
		public function set label_multiline(value:Boolean):void{
			_labelMultiline = value;
			
			redraw();
		}
		
		public function get correctAnswer():Boolean
		{
			return _correctAnswer;
		}
		
		public function set correctAnswer(value:Boolean):void
		{
			_correctAnswer = value;
		}
		
		public function set radio_button_x(value:Number):void
		{
			_radioButtonX = value;
			redraw();
		}
		
		public function set text_size(value:Number):void{
			_textSize = value;
			redraw();
		}
		
		public function set text_color(value:uint):void
		{
			_textColor = value;
			redraw();
		}
		
		public function set selected_text_color(value:uint):void
		{
			_selectedTextColor = value;
			redraw();
		}
		
		public function set use_radio_buttons(value:Boolean):void
		{
			_useRadioButtons = value;
			redraw();
		}
		

		
		/* =================================
			IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'poll_option'; }
		
		public function getConfigVars():Array
		{
			return [
				ConfigurableObjectUtils.numberVar('x', x), 
				ConfigurableObjectUtils.numberVar('y', y), 
				ConfigurableObjectUtils.stringVar('label', _labelText, 'This is the label'),
				ConfigurableObjectUtils.booleanVar('correct_answer', _correctAnswer, false, {desc:'Sets the correct answer for quiz functionality. If any PollOptions have this set, the current step becomes a quiz instead of a poll (flashes correct/incorrect instead of displaying poll results)'}),
				ConfigurableObjectUtils.numberVar('width', _width, 300, {hidden:true}),
				ConfigurableObjectUtils.numberVar('height', _height, 26),
				ConfigurableObjectUtils.colorVar('background_color', _backgroundColor, 'FF0000', {hidden:true}), 
				ConfigurableObjectUtils.numberVar('curve_size', _curveSize, 26, {hidden:true}), 
				ConfigurableObjectUtils.numberVar('label_x', _labelX, 33),
				ConfigurableObjectUtils.numberVar('label_y', _labelY, 3),
//				ConfigurableControl.numberVar('label_alpha', _labelAlpha),
				ConfigurableObjectUtils.booleanVar('label_multiline', _labelMultiline),
//				ConfigurableControl.booleanVar('use_radio_buttons', _useRadioButtons),
//				ConfigurableControl.numberVar('radio_button_x', _radioButtonX),
				ConfigurableObjectUtils.numberVar('text_size', _textSize, 13),
				ConfigurableObjectUtils.colorVar('text_color', _textColor, '000000', {hidden:true}),
				ConfigurableObjectUtils.colorVar('selected_text_color', _selectedTextColor, '000000', {hidden:true}),
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
					case 'width':
						width = config[configName];
						break;
					case 'height':
						height = config[configName];
						break;
					case 'background_color':
						background_color = config[configName];
						break;
					case 'curve_size':
						curve_size = config[configName];
						break;
					case 'label':
						label = config[configName];
						break;
					case 'label_x':
						label_x = config[configName];
						break;					
					case 'label_y':
						label_y = config[configName];
						break;
					case 'label_alpha':
						label_alpha = config[configName];
						break;
					case 'label_multiline':
						label_multiline = config[configName];
						break;
					case 'correct_answer':
						_correctAnswer = config[configName];
						break;
					case 'use_radio_buttons':
						use_radio_buttons = config[configName];
						break;
					case 'radio_button_x':
						radio_button_x = config[configName];
						break;
					case 'text_size':
						text_size = config[configName];
						break;
					case 'text_color':
						text_color = config[configName];
						break;
					case 'selected_text_color':
						selected_text_color = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;

				}
			}
		}



//		protected var _labelX:Number = 33;
//		protected var _labelY:Number = 3;
//		protected var _labelAlpha:Number = 0.9;
//		protected var _labelMultiline:Boolean = false;
//		
//		protected var _radioButtonX:Number = 3;
//		
//		protected var _textColor:uint = 0x000000;
//		protected var _selectedTextColor:uint = 0x000000;
//		protected var _resultTextColor:uint = 0x000000;
//		protected var _percentageTextColor:uint = 0xffffff;
//		
//		protected var _useRadioButtons:Boolean = true;

	}
}