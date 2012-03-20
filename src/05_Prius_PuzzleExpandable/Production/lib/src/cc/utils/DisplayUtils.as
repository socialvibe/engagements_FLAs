package cc.utils
{
import flash.display.DisplayObject;

	public class DisplayUtils
	{
		
		public static const HORIZONTAL		:String = 'horizontal';
		public static const VERTICAL		:String	= 'vertical';
		public static const ROTATION		:String	= 'rotation';
		
		public static function grid(items:Array,horizontalSpacing:Number,verticalSpacing:Number,itemsPerLine:uint,snapToPixel:Boolean=true):void
		{
			for (var i:int = 0; i < items.length; i++)
			{
				items[i].x = (items[i].width+horizontalSpacing)*int(i%itemsPerLine);
				items[i].y = (items[i].height+verticalSpacing)*int(i/itemsPerLine);
				if(snapToPixel)
				{
					items[i].x = int(items[i].x);
					items[i].y = int(items[i].y);
				}
			}
		}
		
		public static function spaceEvenly(items:Array,space:Number,orientation:String='horizontal',snapToPixel:Boolean=true):void
		{
			for (var i:int = 1; i < items.length; i++)
			{
				if(orientation==VERTICAL)
				{
					items[i].y = items[i-1].y + items[i-1].height + space;
					if(snapToPixel)	items[i].y = int(items[i].y);
				}
				else
				{
					items[i].x = items[i-1].x + items[i-1].width + space;
					if(snapToPixel)	items[i].x = int(items[i].x);
				}
			}
		}
		
		/**
		 * Snaps the specified object to the closest whole pixel.
		 */
		public static function snapToPixel(object:DisplayObject):void
		{
			object.x = int(object.x);
			object.y = int(object.y);
		}
		
		public static function snapTo(object:DisplayObject,space:int=10,value:String='x'):void
		{
			object[value] = int(object[value]/space)*space;
		}
		
		
	}

}