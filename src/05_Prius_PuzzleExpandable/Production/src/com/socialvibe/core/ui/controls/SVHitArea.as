package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class SVHitArea extends Sprite implements IConfigurableControl
	{
		protected var _width:Number;
		protected var _height:Number;
		
		protected var _actions:Array;
		protected var _effects:Array;
		
		public function SVHitArea(width:Number = 100, height:Number = 20)
		{
			_width = width;
			_height = height;
			
			redrawArea();
		}
		
		protected function redrawArea():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			
			if (_actions == null || _actions.length == 0)
			{
				g.lineStyle(1, 0x000000, 0.25);
				g.beginFill(0, 0.1);
				
				this.blendMode = BlendMode.INVERT;
			}
			else
			{
				g.beginFill(0, 0);
				
				this.blendMode = BlendMode.NORMAL;
			}
			
			
			g.drawRect(0, 0, _width, _height);
		}
		
		protected function onClick(e:Event):void
		{
			dispatchEvent(new SVEvent(ConfigurableObjectUtils.TRIGGER_ACTION, _actions, true, true));
		}
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		override public function set width(value:Number):void
		{
			_width = value;
			
			redrawArea();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			
			redrawArea();
		}
		
		public function set actions(value:Array):void
		{
			_actions = value;
			
			redrawArea();
			
			if (!hasEventListener(MouseEvent.CLICK))
			{
				buttonMode = useHandCursor = true;
				addEventListener(MouseEvent.CLICK, onClick, false, 0, true);
			}
		}
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'hit_area'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('width', _width), 
					ConfigurableObjectUtils.numberVar('height', _height),
					ConfigurableObjectUtils.arrayVar('effects', _effects, null, {hidden:true}),
					ConfigurableObjectUtils.arrayVar('actions', _actions, null, {hidden:true, desc:"clicking on the hit area"})];
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
					case 'effects':
						_effects = config[configName];
						break;
					case 'actions':
						actions = config[configName];
						break;
				}
			}
		}
	}
}