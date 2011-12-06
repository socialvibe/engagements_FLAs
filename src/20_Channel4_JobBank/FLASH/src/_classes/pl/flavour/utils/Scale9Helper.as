package pl.flavour.utils

{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	public class Scale9Helper
	{
		public static function setScaleGrid( target:Sprite, offset:uint ):void {
			var grid:Rectangle = new Rectangle( offset, offset, target.width - ( offset << 1 ), target.height - ( offset << 1 ) );
			target.scale9Grid = grid;
		}
 
		public static function showScaleGrid( target:Sprite, lineColor:uint = 0x00ff00 ):void {
			var targetScaleRect:Rectangle = target.scale9Grid;
			target.graphics.lineStyle( 2, lineColor );
			target.graphics.moveTo( 0, targetScaleRect.y );
			target.graphics.lineTo( target.width, targetScaleRect.y );
			target.graphics.moveTo( targetScaleRect.x, 0 );
			target.graphics.lineTo( targetScaleRect.x, target.height );
			target.graphics.moveTo( 0, targetScaleRect.y + targetScaleRect.height );
			target.graphics.lineTo( target.width, targetScaleRect.y + targetScaleRect.height );
			target.graphics.moveTo( targetScaleRect.x + targetScaleRect.width, 0 );
			target.graphics.lineTo( targetScaleRect.x + targetScaleRect.width, target.height );
		}
	}
}