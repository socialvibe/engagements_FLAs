package com.socialvibe.core.ui.controls
{
	public interface IConfigurableControl
	{
		function getControlName():String;
		
		function getConfigVars():Array;
		
		function getConfig():Object;
		
		function setConfig(config:Object):void;
	
	}
}