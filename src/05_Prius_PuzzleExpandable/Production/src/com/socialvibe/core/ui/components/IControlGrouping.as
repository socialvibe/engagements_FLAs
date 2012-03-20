package com.socialvibe.core.ui.components
{
	import flash.display.DisplayObject;
	
	public interface IControlGrouping
	{
		function addControl( control:DisplayObject ):void;
		
		function get controlNames():Array;
	}
}