package com.socialvibe.core.ui.controls
{
	import com.socialvibe.core.utils.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class SVShape extends Sprite implements IConfigurableControl
	{
		protected var _width:Number;
		protected var _height:Number;
		protected var _color:Number;
		protected var _cornerRadius:Number;
		
		protected var _effects:Array;
		
		public function SVShape(width:Number = 100, height:Number = 100, color:Number = 0x000000, cornerRadius:Number = 0)
		{
			_width = width;
			_height = height;
			_color = color;
			_cornerRadius = cornerRadius;
			
			redrawShape();
		}
		
		protected function redrawShape():void
		{
			var g:Graphics = this.graphics;
			g.clear();
			
			g.beginFill(_color);
			g.drawRoundRect(0, 0, _width, _height, _cornerRadius);
		}
		
		
		/* ===================================
		Getters & Setters for configurability
		=================================== */
		
		override public function set width(value:Number):void
		{
			_width = value;
			
			redrawShape();
		}
		
		override public function set height(value:Number):void
		{
			_height = value;
			
			redrawShape();
		}
		
		public function set color(value:Number):void
		{
			_color = value;
			
			redrawShape();
		}
		
		public function set corner_radius(value:Number):void
		{
			_cornerRadius = value;
			
			redrawShape();
		}
		
		
		/* =================================
		IConfigurableControl functionality
		================================= */
		
		public function getControlName():String { return 'shape'; }
		
		public function getConfigVars():Array
		{
			return [ConfigurableObjectUtils.numberVar('x', x), 
					ConfigurableObjectUtils.numberVar('y', y), 
					ConfigurableObjectUtils.numberVar('width', _width), 
					ConfigurableObjectUtils.numberVar('height', _height),
					ConfigurableObjectUtils.colorVar('color', _color),
					ConfigurableObjectUtils.numberVar('corner_radius', _cornerRadius),
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
					case 'color':
						color = config[configName];
						break;
					case 'corner_radius':
						corner_radius = config[configName];
						break;
					case 'effects':
						_effects = config[configName];
						break;
				}
			}
		}
	}
}