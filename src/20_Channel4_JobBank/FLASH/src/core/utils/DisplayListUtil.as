package core.utils {

	import flash.display.DisplayObjectContainer;
	import flash.display.MovieClip;

	public class DisplayListUtil {

		public static function removeAllChildrens(_container) {
			
			var i : Number = _container.numChildren;
			if(i > 0) {
				while (i--) {
					
					_container.removeChildAt(i);
					
				}
			}
			
		}
		
		
		public static function stopAll(content:DisplayObjectContainer):void
		{
			if (content is MovieClip)
				(content as MovieClip).stop();
				
			if (content.numChildren)
			{
				var child:DisplayObjectContainer;
				for (var i:int, n:int = content.numChildren; i < n; ++i)
				{
					if (content.getChildAt(i) is DisplayObjectContainer)
					{
						child = content.getChildAt(i) as DisplayObjectContainer;
						
						if (child.numChildren)
							stopAll(child);
						else if (child is MovieClip)
							(child as MovieClip).stop();
					}
				}
			}
		}		
		
		
		public static function gotoAndstopAll(content:DisplayObjectContainer, stopFrame:Number = 1):void
		{
			if (content is MovieClip)
				(content as MovieClip).gotoAndStop(stopFrame);
				
			if (content.numChildren)
			{
				var child:DisplayObjectContainer;
				for (var i:int, n:int = content.numChildren; i < n; ++i)
				{
					if (content.getChildAt(i) is DisplayObjectContainer)
					{
						child = content.getChildAt(i) as DisplayObjectContainer;
						
						if (child.numChildren)
							gotoAndstopAll(child, stopFrame);
						else if (child is MovieClip)
							(child as MovieClip).gotoAndStop(stopFrame);;
					}
				}
			}
		}		
		
		
		
	}

}
