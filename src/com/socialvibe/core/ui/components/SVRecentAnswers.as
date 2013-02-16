package com.socialvibe.core.ui.components
{
	import com.socialvibe.core.config.Services;
	import com.socialvibe.core.ui.SVSquareLoader;
	import com.socialvibe.core.ui.controls.IConfigurableControl;
	import com.socialvibe.core.utils.ConfigurableObjectUtils;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.filters.*;
	import flash.utils.setTimeout;
	
	import com.greensock.TweenLite;
	
	public class SVRecentAnswers extends Sprite implements IConfigurableControl
	{
		// display options
		private var _width:Number;
		private var _height:Number;		
		private var _loaderGlow:Boolean = true;
		
		protected var _answerClass:Class = Answer;
		protected var _displayParams:Object;
		
		protected var _effects:Array;
		
		// data
		protected var _answerData:Array;
		
		// display objects
		protected var _answerPanel:Sprite;
		protected var _loader:SVSquareLoader;

		protected var _textColor:uint = 0x000000;
		protected var _textAlpha:Number = 1.0;
		protected var _dropShadow:Boolean = false;
		
		public function SVRecentAnswers(width:Number = 275, height:Number = 200)
		{
			_width = width;
			_height = height;
			
			addEventListener( Event.ADDED_TO_STAGE, init, false, 0, true );
		}
		
		protected function init(e:Event):void
		{
			removeEventListener( Event.ADDED_TO_STAGE, init );
			
			if (_answerData == null)
				startLoading();
			
			if (Services.BUILDER_MODE)
				setTimeout(generateDebugComments, 1000);
		}
		
		
		public function generateDebugComments(count:Number = 5):void
		{
			var users:Array = ["barbeautender", "thebritbritt", "rangjo42", "BeMillsweiser", "MollyAintDrunk", "Spicy_Asian_Guy", "thatguymike", "jezey35", "Levinator", "Steinlager43", "Sam-Pickleback", "Shinburger", "Bemills86", "LeprechaunOne", "TheChenderBritt", "SayjotaGRChamp", "StinkeyFinkey", "Tongenstein8", "TheDavisRules", "BetaKid967", "HongLong", "CaptainBob", "TamaraStar", "BillyNoPants", "stinky188", "Plaidman15", "Powderdustman", "JoshSt.BernarD", "The d00d", "Skaterchic2000", "MacFanNumeroUno"];
			
			var result:Array = [];
			for (var i:int=0; i<count; i++)
				result.push( {display_name:users[Math.floor(Math.random()*users.length)], body:loremIpsumWords(2 + Math.floor(Math.random()*15))} );
			
			loadRecentAnswers( result );
		}
		
		public function loremIpsumWords(count:Number):String
		{
			var lorem_ipsum:String = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec gravida mi vitae orci commodo laoreet. Pellentesque vestibulum, mi vitae porta accumsan, purus nisi tempus sem, vitae pretium ipsum risus et justo. Aliquam suscipit enim vel orci rutrum iaculis.";
			
			var words:Array = lorem_ipsum.split(/\s+/);
			var randomStart:Number = Math.floor(Math.random() * (words.length-count));
			var firstWord:String = words[randomStart] as String;
			words[randomStart] = firstWord.charAt(0).toUpperCase() + firstWord.substring(1, firstWord.length);
			
			return words.splice(randomStart, count).join(' ');
		}

		
		/* =================================
			Public Functions
		================================= */			
		public function loadRecentAnswers( answers:Array ):void
		{
			if (answers == null || answers.length == 0)
			{
				setTimeout(generateDebugComments, 1000);
				return;
			}
			
			stopLoading();
			_answerData = answers.map( function(e:Object, i:int, a:Array):CommentData { return new CommentData(e); } );
			_answerData.reverse();
			
			renderAnswers();
		}
		
		public function pushNewAnswer( data:Object ):void
		{	
			var answerData:CommentData = new CommentData(data);
			
			stopLoading();
			
			var newAnswer:Sprite = new _answerClass( answerData, _width, _displayParams || { textColor: _textColor, textAlpha:_textAlpha, dropShadow: _dropShadow } ) as Sprite;
			newAnswer.alpha = 0;
			addChild( newAnswer );
			
			TweenLite.to( newAnswer, 2, {alpha:1} );
			TweenLite.to( _answerPanel, 1.5, {y: _answerPanel.y + newAnswer.height} );
			
			// remove any answers that are now out of bounds
			for (var i:Number = _answerPanel.numChildren-1; i >= 0; i--)
			{
				if ( _answerPanel.height + newAnswer.height <= _height )
					break;
				
				_answerPanel.removeChildAt( i );
			}
		}
		
		public function showBounds():void
		{
			var g:Graphics = this.graphics;
			g.beginFill(0xff0000, 0.25);
			g.drawRect(0, 0, _width, _height);
		}
		
		public function hideBounds():void
		{
			var g:Graphics = this.graphics;
			g.clear();
		}
		
		public function set displayParams( params:Object ):void { _displayParams = params; }
		public function set answerClass( c:Class ):void { _answerClass = c; }
		
		override public function get width():Number { return _width; }
		override public function get height():Number { return _height; }
		


		/* =================================
			Display Functions
		================================= */
		protected function renderAnswers():void
		{
			if (_answerData == null)
				return;
			
			if (_answerPanel != null && contains(_answerPanel))
				removeChild( _answerPanel );
			
			_answerPanel = new Sprite();
			addChildAt(_answerPanel, 0);
			
			for each ( var answerData:CommentData in _answerData )
			{
				var answerObject:Sprite = new _answerClass( answerData, _width, _displayParams || { textColor: _textColor, textAlpha:_textAlpha, dropShadow: _dropShadow }  ) as Sprite;
				answerObject.y = _answerPanel.height;
				
				if ( _answerPanel.y + _answerPanel.height + answerObject.height > _height)
				{
					// special case for empty answer panel (show truncated comment)
					if (  _answerPanel.height == 0 && 'setMaxLines' in (answerObject as Object) ) {
						(answerObject as Object).setMaxLines(3);						
						_answerPanel.addChild( answerObject );							
					}
					else
						break;
				}					
				else
					_answerPanel.addChild( answerObject );
			}
			
			TweenLite.from( _answerPanel, 1, {alpha: 0} );
		}

		
		
		
		
		/* =================================
			Utility Functions
		================================= */	
		protected function startLoading():void
		{
			if (_loader == null)
			{
				_loader = new SVSquareLoader( true, 'Loading Answers' );
				_loader.x = (_width - _loader.width) / 2;
				_loader.y = 25;
				
				if (_loaderGlow)
					_loader.filters = [ new GlowFilter(0, 0.25) ]
			}
			
			addChild(_loader);
			_loader.start();
		}
		
		protected function stopLoading():void
		{
			if ( _loader != null )
				_loader.stop();
		}
		
		public function set loaderGlow( glow:Boolean ):void { _loaderGlow = glow; renderAnswers(); }
		
		/* =========================================
			Getters & Setters for configurability
		========================================= */
		
		override public function set width(value:Number):void { _width = value; renderAnswers(); }
		override public function set height(value:Number):void { _height = value; renderAnswers(); }
		public function set text_color(value:uint):void { _textColor = value; renderAnswers(); }
		public function set text_alpha(value:Number):void { _textAlpha = value; renderAnswers(); }
		public function set drop_shadow(value:Boolean):void { _dropShadow = value; renderAnswers(); }
		
		/* ======================================
			IConfigurableControl functionality
		====================================== */
		public function getControlName():String { return 'recent_answers'; }
		
		public function getConfigVars():Array
		{
			return [
				ConfigurableObjectUtils.numberVar('x', x), 
				ConfigurableObjectUtils.numberVar('y', y),
				ConfigurableObjectUtils.numberVar('width', _width, NaN),
				ConfigurableObjectUtils.numberVar('height', _height, NaN),
				ConfigurableObjectUtils.colorVar('text_color', _textColor),
				ConfigurableObjectUtils.numberVar('text_alpha', _textAlpha),
				ConfigurableObjectUtils.booleanVar('drop_shadow', _dropShadow),
				ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true})
			];
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
					case 'text_color':
						text_color = config[configName];
						break;
					case 'text_alpha':
						text_alpha = config[configName];
						break;
					case 'drop_shadow':
						drop_shadow = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
				}
			}
		}
	}
}


import com.socialvibe.core.ui.controls.*;
import com.socialvibe.core.utils.*;

import flash.display.*;
import flash.events.*;
import flash.filters.*;

internal class Answer extends Sprite
{
	protected var _userImg:SVImage;
	protected var _displayName:SVText;
	protected var _comment:SVText;
	
	public function Answer( data:CommentData, width:Number, displayParams:Object)
	{
		_userImg = new SVImage(data.avatarUrl);
		_userImg.scaleImage(27, 27);
		addChild(_userImg);
		
		_displayName = new SVText(data.displayName + " wrote...", 0, 0, 11, true, displayParams.textColor || 0x000000);
		_displayName.alpha = displayParams.textAlpha || 1;
		_displayName.x = 34;
		_displayName.y = -4;
		addChild(_displayName);
		
		_comment = new SVText( data.comment, 0, 0, 11, false, displayParams.textColor, width - _displayName.x);
		_comment.alpha = displayParams.textAlpha || 1;
		_comment.multiline = true;
		_comment.x = _displayName.x;
		_comment.y = _displayName.y + _displayName.textHeight;
		addChild(_comment);
		
		if ( displayParams.dropShadow )
		{
			_comment.filters = _displayName.filters = [ new DropShadowFilter(1, 45, 0, 1, 1, 1) ];
		}
	}
	
	public function setMaxLines( maxLines:Number = 3 ):void
	{
		_comment.setMaxLines( maxLines-1 );
	}
}


internal class CommentData extends Object
{
	public var avatarUrl : String;
	
	public var displayName : String; 
	public var comment : String;
	public var agoText : String;
	
	public function CommentData( data:Object )
	{
		if (data == null) return;
		
		avatarUrl = data.avatar_url || "http://media.socialvi.be/m/activities/socialvibe/q_silhouette.gif";
		
		displayName = (data.display_name || 'Someone');
		comment = data.body;
		agoText = data.ago;
	}
}
