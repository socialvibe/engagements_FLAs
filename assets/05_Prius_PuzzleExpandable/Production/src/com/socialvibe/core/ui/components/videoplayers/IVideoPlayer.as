package com.socialvibe.core.ui.components.videoplayers
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;

	public interface IVideoPlayer
	{
		public function IVideoPlayer():void;
		
		function onAddedToStage(e:Event):void;
		function init():void;
		function kill():void;
		function play():void;
		function pause():void;
		function resume():void;
		function restart():void;
		
		function set width(value:Number):void;
		function get width():Number;
		function set height(value:Number):void;
		function get height():Number;
		function set video_url(value:String):void;
		function get video_url():String;	
		function set preview_url(img:String):void;
		function get preview_url():String;
		function set auto_play(value:Boolean):void;
		function get total_time():Number;
		function get current_time():Number;
		
		//Utility
		function disableControls():void;
		function cropSourceVideo( cropArea:Rectangle):void;
		function isMovieEnded():Boolean;
	}
}