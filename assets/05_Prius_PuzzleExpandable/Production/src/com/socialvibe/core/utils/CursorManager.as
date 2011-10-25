package com.socialvibe.core.utils
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.*;
	
	public class CursorManager extends EventDispatcher
	{
		public static var cursorManager:CursorManager;
		
		private var _cursor:Sprite;
		private var _area:Sprite;
		
		public function CursorManager(key:SingletonBlocker):void
      	{
      		
      	}
      	
		public static function initManager():CursorManager
		{
			if (cursorManager == null)
         	{
            	cursorManager = new CursorManager(new SingletonBlocker());
          	}
         	return cursorManager;
        }
      	
      	public function setCursor(area:Sprite = null, cursor:Sprite = null):void
      	{
      		if (cursor == null)
      		{
      			if (_area == null)
      				return;
      			
      			_area.stage.removeEventListener(MouseEvent.MOUSE_MOVE, onCursorMove);
				_area.removeEventListener(MouseEvent.ROLL_OUT, onExitSite);
				_area.removeEventListener(MouseEvent.ROLL_OVER, onEnterSite);
				
				if (_area.stage.contains(_cursor))
					_area.stage.removeChild(_cursor);
      			Mouse.show();
      		}
      		else
      		{
      			area.stage.addChild(cursor);
      			area.stage.addEventListener(MouseEvent.MOUSE_MOVE, onCursorMove, false, 0, true);
      			area.addEventListener(MouseEvent.ROLL_OUT, onExitSite, false, 0, true);
				area.addEventListener(MouseEvent.ROLL_OVER, onEnterSite, false, 0, true);
      			Mouse.hide();
      		}
      		
      		_area = area;
      		_cursor = cursor;
      	}
		
		private function onCursorMove(e:MouseEvent):void
		{
			_cursor.x = e.stageX;
			_cursor.y = e.stageY;
		}
		private function onEnterSite(e:MouseEvent):void
		{
			if (_area && !_area.stage.contains(_cursor))
			{
				_area.stage.addChild(_cursor);
				Mouse.hide();
			}
		}
		private function onExitSite(e:MouseEvent):void
		{
			if (_area && _area.stage.contains(_cursor))
			{
				_area.stage.removeChild(_cursor);
				Mouse.show();
			}
		}
		
		public function get cursor():Sprite
		{
			return _cursor;
		}
	}
}

// restrict singleton instantiation to this class only
internal class SingletonBlocker {}