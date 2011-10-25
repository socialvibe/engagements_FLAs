package com.socialvibe.core.utils
{
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	public class Equations
	{				
		public static function easeNone (t:Number, b:Number, c:Number, d:Number):Number {
			return Linear.easeNone(t, b, c, d);
		}
	
		public static function easeInQuad (t:Number, b:Number, c:Number, d:Number):Number {
			return Quad.easeIn(t, b, c, d);
		}
	
		public static function easeOutQuad (t:Number, b:Number, c:Number, d:Number):Number {
			return Quad.easeOut(t, b, c, d);
		}
	
		public static function easeInOutQuad (t:Number, b:Number, c:Number, d:Number):Number {
			return Quad.easeInOut(t, b, c, d);
		}
	
		public static function easeInCubic (t:Number, b:Number, c:Number, d:Number):Number {
			return Cubic.easeIn(t, b, c, d);
		}
	
		public static function easeOutCubic (t:Number, b:Number, c:Number, d:Number):Number {
			return Cubic.easeOut(t, b, c, d);
		}
	
		public static function easeInOutCubic (t:Number, b:Number, c:Number, d:Number):Number {
			return Cubic.easeInOut(t, b, c, d);
		}
	
		public static function easeInQuart (t:Number, b:Number, c:Number, d:Number):Number {
			return Quart.easeIn(t, b, c, d);
		}
	
		public static function easeOutQuart (t:Number, b:Number, c:Number, d:Number):Number {
			return Quart.easeOut(t, b, c, d);
		}
	
		public static function easeInOutQuart (t:Number, b:Number, c:Number, d:Number):Number {
			return Quart.easeInOut(t, b, c, d);
		}
		
		public static function easeInQuint (t:Number, b:Number, c:Number, d:Number):Number {
			return Quint.easeIn(t, b, c, d);
		}
	
		public static function easeOutQuint (t:Number, b:Number, c:Number, d:Number):Number {
			return Quint.easeOut(t, b, c, d);
		}
	
		public static function easeInOutQuint (t:Number, b:Number, c:Number, d:Number):Number {
			return Quint.easeInOut(t, b, c, d);
		}
		
		public static function easeInSine (t:Number, b:Number, c:Number, d:Number):Number {
			return Sine.easeIn(t, b, c, d);
		}
	
		public static function easeOutSine (t:Number, b:Number, c:Number, d:Number):Number {
			return Sine.easeOut(t, b, c, d);
		}
	
		public static function easeInOutSine (t:Number, b:Number, c:Number, d:Number):Number {
			return Sine.easeInOut(t, b, c, d);
		}
		
		public static function easeInExpo (t:Number, b:Number, c:Number, d:Number):Number {
			return Expo.easeIn(t, b, c, d);
		}
	
		public static function easeOutExpo (t:Number, b:Number, c:Number, d:Number):Number {
			return Expo.easeOut(t, b, c, d);
		}
		
		public static function easeInOutExpo (t:Number, b:Number, c:Number, d:Number):Number {
			return Expo.easeInOut(t, b, c, d);
		}
		
		public static function easeInCirc (t:Number, b:Number, c:Number, d:Number):Number {
			return Circ.easeIn(t, b, c, d);
		}
	
		public static function easeOutCirc (t:Number, b:Number, c:Number, d:Number):Number {
			return Circ.easeOut(t, b, c, d);
		}
	
		public static function easeInOutCirc (t:Number, b:Number, c:Number, d:Number):Number {
			return Circ.easeInOut(t, b, c, d);
		}
		
		public static function easeInElastic (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			return Elastic.easeIn(t, b, c, d, a, p);
		}
	
		public static function easeOutElastic (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			return Elastic.easeOut(t, b, c, d, a, p);
		}
	
		public static function easeInOutElastic (t:Number, b:Number, c:Number, d:Number, a:Number = 0, p:Number = 0):Number {
			return Elastic.easeInOut(t, b, c, d, a, p);
		}
		
		public static function easeInBack (t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			return Back.easeIn(t, b, c, d, s);
		}
		
		public static function easeOutBack (t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			return Back.easeOut(t, b, c, d, s);
		}
		
		public static function easeInOutBack (t:Number, b:Number, c:Number, d:Number, s:Number = 1.70158):Number {
			return Back.easeInOut(t, b, c, d, s);
		}
		
		public static function easeInBounce (t:Number, b:Number, c:Number, d:Number):Number {
			return Bounce.easeIn(t, b, c, d);
		}
	
		public static function easeOutBounce (t:Number, b:Number, c:Number, d:Number):Number {
			return Bounce.easeOut(t, b, c, d);
		}
	
		public static function easeInOutBounce (t:Number, b:Number, c:Number, d:Number):Number {
			return Bounce.easeInOut(t, b, c, d);
		}
	}
}