package com.socialvibe.core.utils
{
	import com.adobe.serialization.json.*;
	import com.socialvibe.core.ui.controls.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ConfigurableObjectUtils
	{
		static public const VARIABLE_CHANGED:String = 'variableChanged';
		static public const TRIGGER_ACTION:String 	= 'triggerAction';
		
		static public const NUMBER_VAR:int = 0;
		static public const STRING_VAR:int = 1;
		static public const COLOR_VAR:int = 2;
		static public const FILE_VAR:int = 3;
		static public const BOOLEAN_VAR:int = 4;
		static public const ARRAY_VAR:int = 5;
		static public const SELECT_VAR:int = 6;
		
		static public function getConfigJSON(control:Object):String
		{
			return (new JSONEncoder(getConfigObject( control ))).getString();
		}
		
		static public function getConfigObject(control:Object):Object
		{
			var configVars:Array = control.getConfigVars();
			
			var configObject:Object = {};
			configObject['name'] = control.name;
			configObject['controlClass'] = getQualifiedClassName( control );
			
			for each (var configVar:Object in configVars)
			{
				if (configVar.type == SELECT_VAR)
					configObject[configVar.name] = configVar.value.value;
				else
					configObject[configVar.name] = configVar.value;
			}
			
			if (configObject.actions && configObject.actions.length == 0)
				delete configObject.actions;
			
			if (configObject.effects && configObject.effects.length == 0)
				delete configObject.effects;
			
			return configObject;
		}
		
		static public function decodeConfig( config:Object, control:Object ):Object
		{
			var configVars:Array = control.getConfigVars();
			
			var typeMapping:Object = {};
			for each (var configVar:Object in configVars)
			{
				typeMapping[configVar.name] = configVar.type;
			}
						
			// need to extract property names separately to avoid annoying flash bug
			var properties:Array = [];
			for ( var property:String in config ) {
				properties.push( property );					
			}
			
			var decodedConfig:Object = {};
			for each (var propertyName:String in properties)
			{
				switch (typeMapping[propertyName])
				{
					case COLOR_VAR:
						decodedConfig[propertyName] = config[propertyName] ? Number('0x' + config[propertyName]) : NaN;
						break;
					case NUMBER_VAR:
						decodedConfig[propertyName] = Number(config[propertyName]);
						break;
					case BOOLEAN_VAR:
						decodedConfig[propertyName] = (config[propertyName] == 'true') || (config[propertyName] == true);
						break;
					default:
						decodedConfig[propertyName] = config[propertyName];
				}
				
				if (propertyName == 'name')
					control.name = String(config[propertyName]);
			}
			
			return decodedConfig;
		}
		
		static public function createConfigVar(name:String, type:int, value:Object, params:Object = null):Object
		{
			var configVar:Object = {'name':name, 'type':type, 'value':value};
			
			for (var param:Object in params)
				configVar[param] = params[param];
			
			return configVar;
		}
		
		static public function numberVar(name:String, value:Object, defaultValue:Object = null, params:Object = null):Object
		{
			return createConfigVar(name, NUMBER_VAR, (isNaN(Number(value)) ? (defaultValue === null ? "" : defaultValue) : value), params);
		}
		
		static public function stringVar(name:String, value:Object, defaultValue:Object = null, params:Object = null):Object
		{
			return createConfigVar(name, STRING_VAR, (value === null ? (defaultValue === null ? "" : defaultValue) : value), params);
		}
		
		static public function colorVar(name:String, value:Number, defaultValue:Object = null, params:Object = null):Object
		{
			return createConfigVar(name, COLOR_VAR, (isNaN(value) ? (defaultValue === null ? "" : defaultValue) : value.toString(16)), params);
		}
		
		static public function fileVar(name:String, value:Object, params:Object = null):Object
		{
			return createConfigVar(name, FILE_VAR, (value ? value : ""), params);
		}
		
		static public function booleanVar(name:String, value:Object, defaultValue:Object = null, params:Object = null):Object
		{
			return createConfigVar(name, BOOLEAN_VAR, (value === null ? (defaultValue === null ? false : defaultValue) : value), params);
		}
		
		static public function arrayVar(name:String, value:Array, defaultValue:Object = null, params:Object = null):Object
		{
			return createConfigVar(name, ARRAY_VAR, (value === null ? (defaultValue === null ? [] : defaultValue) : value), params);
		}
		
		static public function selectVar(name:String, value:Object, options:Array, defaultValue:Object = null, params:Object = null):Object
		{
			return createConfigVar(name, SELECT_VAR, {value:(value === null ? (defaultValue === null ? "" : defaultValue) : value), options:options}, params);
		}
		
		static public function addAction(control:Object, action:Object):void
		{
			var config:Object = control.getConfig();
			var actions:Array = config.actions || [];
			
			actions.push( action.getConfig() );
			control.setConfig( {actions:actions} );
		}
		
		static public function addEffect(control:Object, effect:Object):void
		{
			var config:Object = control.getConfig();
			var effects:Array = config.effects || [];
			
			effects.push( effect.getConfig() );
			control.setConfig( {effects:effects} );
		}
		
		static public function addPlaceholder(control:Sprite, label:String, w:Number, h:Number):void
		{
			removePlaceholder(control);
			
			var placeholder:Sprite = new Sprite();
			
			placeholder.addChild(new SVText('[' + label + ']', 2, 0, 10, false, 0x000000));
			
			var g:Graphics = placeholder.graphics;
			g.lineStyle(1, 0x000000, 0.8);
			g.beginFill(0, 0);
			g.drawRect(0, 0, w-1, h-1);
			
			g.lineStyle(1, 0x000000, 0.3);
			g.lineTo(w-1, h-1);
			g.moveTo(0, h-1);
			g.lineTo(w-1, 0);
			
			placeholder.alpha = 0.5;
			placeholder.blendMode = BlendMode.INVERT;
			
			placeholder.name = 'placeholder';
			control.addChild(placeholder);
		}
		
		static public function removePlaceholder(control:Sprite):void
		{
			var placeholder:Sprite = control.getChildByName('placeholder') as Sprite;
			
			if (placeholder && control.contains(placeholder))
				control.removeChild(placeholder);
		}
	}
}