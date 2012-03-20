package cc.utils
{
	
	import flash.display.BitmapData;
	
	public class ColorUtils
	{
		
		/**
		 * Converts a RGB color value to HEX
		 * 
		 * @return 0xRRGGBB
		 */
		public static function RGBToHex(rOrArray:Object, g:uint=0x00, b:uint=0x00):uint {
			if(rOrArray is Array)
			{
				g = rOrArray[1];
				b = rOrArray[2];
				rOrArray = rOrArray[0];
			}
		    var hex:uint = ((rOrArray as Number) << 16 | g << 8 | b);
		    return hex;
		}

		/**
		 * Converts a HEX color value to RGB
		 * 
		 * @return Array [R,G,B]
		 */
 		public static function HexToRGB(hex:uint):Array {
		    var rgb:Array = [];

		    var r:uint = hex >> 16 & 0xFF;
		    var g:uint = hex >> 8 & 0xFF;
		    var b:uint = hex & 0xFF;

		    rgb.push(r, g, b);
		    return rgb;
		}
		
		/**
		 * Converts a RGB color value to HSV
		 * 
		 * @return Array [H,S,V]
		 */
		public static function RGBToHSV(r:uint, g:uint, b:uint):Array{
		    var max:uint = Math.max(r, g, b);
		    var min:uint = Math.min(r, g, b);

		    var hue:Number = 0;
		    var saturation:Number = 0;
		    var value:Number = 0;

		    var hsv:Array = [];

		    //get Hue
		    if(max == min){
		        hue = 0;
		    }else if(max == r){
		        hue = (60 * (g-b) / (max-min) + 360) % 360;
		    }else if(max == g){
		        hue = (60 * (b-r) / (max-min) + 120);
		    }else if(max == b){
		        hue = (60 * (r-g) / (max-min) + 240);
		    }

		    //get Value
		    value = max;

		    //get Saturation
		    if(max == 0){
		        saturation = 0;
		    }else{
		        saturation = (max - min) / max;
		    }

		    hsv = [Math.round(hue), Math.round(saturation * 100), Math.round(value / 255 * 100)];
		    return hsv;

		}

		/**
		 * Converts a HSV color value to RGB
		 * 
		 * @return Array [R,G,B]
		 */
		public static function HSVToRGB(h:Number, s:Number, v:Number):Array{
		    var r:Number = 0;
		    var g:Number = 0;
		    var b:Number = 0;
		    var rgb:Array = [];

		    var tempS:Number = s / 100;
		    var tempV:Number = v / 100;

		    var hi:int = Math.floor(h/60) % 6;
		    var f:Number = h/60 - Math.floor(h/60);
		    var p:Number = (tempV * (1 - tempS));
		    var q:Number = (tempV * (1 - f * tempS));
		    var t:Number = (tempV * (1 - (1 - f) * tempS));

		    switch(hi){
		        case 0: r = tempV; g = t; b = p; break;
		        case 1: r = q; g = tempV; b = p; break;
		        case 2: r = p; g = tempV; b = t; break;
		        case 3: r = p; g = q; b = tempV; break;
		        case 4: r = t; g = p; b = tempV; break;
		        case 5: r = tempV; g = p; b = q; break;
		    }

		    rgb = [Math.round(r * 255), Math.round(g * 255), Math.round(b * 255)];
		    return rgb;
		}
		
		/**
		 * Calculates the average color of the provided bitmapData.
		 * 
		 * @return uint average color
		 */
		public static function averageColour( source:BitmapData ):uint
		{
			var red		:Number = 0;
			var green	:Number = 0;
			var blue	:Number = 0;

			var count	:Number = 0;
			var pixel	:Number;

			for (var x:int = 0; x < source.width; x++)
			{
				for (var y:int = 0; y < source.height; y++)
				{
					pixel = source.getPixel(x, y);

					red 	+= pixel >> 16 & 0xFF;
					green 	+= pixel >> 8 & 0xFF;
					blue 	+= pixel & 0xFF;

					count++
				}
			}

			red 	/= count;
			green 	/= count;
			blue 	/= count;

			return red << 16 | green << 8 | blue;
		}
		
		/**
		 * Returns 'steps' count of colors between 'from' and
		 * 'to' color values. Remember that both 'from' and 'to'
		 * are included in the result.
		 * 
		 * @return Array	Color range
		 */
		public static function colorRange(from:uint,to:uint,steps:uint=10):Array
		{
			var arr:Array = new Array(steps);
			
			steps--;
			
			var from_rgb:Array = HexToRGB(from);
			var to_rgb	:Array = HexToRGB(to);
			
			var r_h	:uint = (to_rgb[0] - from_rgb[0])/steps;
			var g_h	:uint = (to_rgb[1] - from_rgb[1])/steps;
			var b_h	:uint = (to_rgb[2] - from_rgb[2])/steps;
			
			for (var i:int = 0; i < steps; i++)
			{
				arr[i] = RGBToHex(from_rgb[0]+r_h*i,from_rgb[1]+g_h*i,from_rgb[2]+b_h*i);
			}
			arr[steps] = to;
			
			return arr;
		}
		
		public static function colorRangeAngle(from:uint,to:uint,steps:uint=10):Array
		{
			var f_rgb:Array = HexToRGB(from);
			var t_rgb:Array = HexToRGB(to);
			var f_hsv:Array = RGBToHSV(f_rgb[0],f_rgb[1],f_rgb[2]);
			var t_hsv:Array = RGBToHSV(t_rgb[0],t_rgb[1],t_rgb[2]);
			
			var arr:Array = new Array(steps);
			steps--;
			var h_h	:Number = (t_hsv[0]-f_hsv[0])/steps;
			var h_s	:Number = (t_hsv[1]-f_hsv[1])/steps;
			var h_v	:Number = (t_hsv[2]-f_hsv[2])/steps;
			var rgb:Array;
			for (var i:int = 0; i < steps; i++)
			{
				arr[i] = RGBToHex(HSVToRGB(f_hsv[0]+h_h*i,f_hsv[1]+h_s*i,f_hsv[2]+h_v*i));
			}
			arr[steps] = to;
			
			return arr;
		}
		
		public static function lerpColorAngle(from:uint,to:uint,percent:Number=0.5):uint
		{
			var f_rgb:Array = HexToRGB(from);
			var t_rgb:Array = HexToRGB(to);
			var f_hsv:Array = RGBToHSV(f_rgb[0],f_rgb[1],f_rgb[2]);
			var t_hsv:Array = RGBToHSV(t_rgb[0],t_rgb[1],t_rgb[2]);
			
			var h_h	:Number = (t_hsv[0]-f_hsv[0])*percent;
			var h_s	:Number = (t_hsv[1]-f_hsv[1])*percent;
			var h_v	:Number = (t_hsv[2]-f_hsv[2])*percent;
			
			return RGBToHex(HSVToRGB(f_hsv[0]+h_h,f_hsv[1]+h_s,f_hsv[2]+h_v));
		}
		
	}
	
}