package { 
	import flash.display.Sprite;
	
	public class Shapes {

		// draw square 
		
		public static function drawSqaure(width,height,color,alpha) {
			
			var square = new Sprite();
			square.graphics.beginFill(color, alpha);
			square.graphics.drawRoundRect(0, 0, width, height, 0);
			square.graphics.endFill();
			return square;
			
		}

		
	}
	
	
}