package com.socialvibe.core.utils
{
	import com.socialvibe.core.config.Services;
	
	import flash.display.*;
	import flash.text.*;
	import flash.xml.*;
	
	public class SVUtilities
	{
		public static function formatTotalNumber(number:int):String
		{
			var buffer:String = "";
			
			while (number > 999)
			{
				var thou:String = String(number%1000);
				if (thou.length == 1)
				{
					thou = "00" + thou;
				}
				else if (thou.length == 2)
				{
					thou = "0" + thou;
				}
				buffer = "," + thou + buffer;
				number /= 1000;
			}
			buffer = String(number) + buffer;
			
			return buffer;
		}
		
		public static function formatLargeTotal(number:int, threshold:int = 100000):String
		{
			if (number < threshold)
				return formatTotalNumber(number);
			
			if (number < 1000000)
				return Math.floor(number/1000) + 'K';
			
			if (number < 10000000)
				return (Math.floor(number / 100000)/10) + 'Mil';
			
			return Math.floor(number/1000000) + 'Mil';
		}
		
		public static function formatRank(rank:Number):String
		{
			if (isNaN(rank) || rank == 0)
				return 'n/a';
			
			switch (rank % 100)
			{
				case 11:
				case 12:
				case 13:
					return formatTotalNumber(rank) + "th";
			}
			
			switch (rank % 10)
			{
				case 1:
					return formatTotalNumber(rank) + "st";
				case 2:
					return formatTotalNumber(rank) + "nd";
				case 3:
					return formatTotalNumber(rank) + "rd";
				default:
					return formatTotalNumber(rank) + "th";
			}
		}
		
		public static function getDefaultAvatarURL(gender:String):String
		{
			return Services.SERVICES_URL + '/images/site/avatar_' + gender.toLowerCase() + '.png'
		}
		
		public static function calcDaysUntil(date:Date):String
		{
			var diff:Number = date.getTime() - new Date().getTime();
			return Math.floor(diff / 1000 / 60 / 60 / 24) + " days";
		}
		
		public static function formatDate(date:Date):String
		{
			return date.month+1 + "/" + date.date + "/" + String(date.fullYear).substr(2, 2);
		}
		/*
		public static function formatLongDate(date:Date):String
		{
			return DateUtil.getShortMonth(date) + ' ' + date.date + ', ' + date.fullYear + ' ' + DateUtil.getShortHour(date) + ':' + NumberFormatter.addLeadingZero(date.minutes) + DateUtil.getAMPM(date);
		}
		*/
		public static function linkify(text:String, display:String = null, popup:Boolean = false):String
		{
			var pattern:RegExp = /(http[^\s\<]+)/gims;
			
			if (display)
				return text.replace(pattern, '<a href="$1" '+ (popup ? 'target="_blank" ' : '') +'>' + display + '</a>');
			else
				return text.replace(pattern, '<a href="$1" '+ (popup ? 'target="_blank" ' : '') +'>$1</a>');
		}
		
		public static function htmlify(text:String):String
		{
			var pattern:RegExp = /\n|\r/gims;
			
			return text.replace(pattern, '<br>');
		}
		
		public static function validateEmail(str:String):Boolean
		{
	        var pattern:RegExp = /^(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+$/;
	        var result:Object = pattern.exec(str);
	        if(result == null) {
	            return false;
	        }
	        return true;
	    }
	    
	    public static function validateURL(str:String):Boolean
		{
			var pattern:RegExp = /^https?:\/\//;
	        var result:Object = pattern.exec(str);
	        if(result == null) {
	            return false;
	        }
	        return true;
	    }
		
		public static function getStyleSheet(activeColor:String = '#e122a0', hoverColor:String = '#FFFFFF'):StyleSheet
		{
			var hover:Object = new Object();
			var link:Object = new Object();
			var active:Object = new Object();
			
			hover.color = hoverColor;
			hover.textDecoration = "underline";
			link.color = activeColor;
			active.color = activeColor;
			active.textDecoration = "underline";
			
			var style:StyleSheet = new StyleSheet();
			style.setStyle("a:hover", hover);
			style.setStyle("a:link", link);
			style.setStyle("a:active", active);
			
			return style;
		}
		
	    public static function scaleObject(object:Object, maxWidth:Number):void
	    {
	    	if (object.width > maxWidth)
			{
				object.y += Math.floor( (object.height - (object.height * (maxWidth/object.width))) / 2);
				object.scaleX = (maxWidth/object.width);
				object.scaleY = object.scaleX;
			}
			else
			{
				object.scaleX = 1;
				object.scaleY = 1
			}
	    }
		
		public static function randomize(arr:Array):void
		{
			arr.sort(shuffle);
		}
		private static function shuffle(a:Object, b:Object):int
		{
			return Math.floor(Math.random() * 3) - 1;
		}
				
		public static function htmlUnescape(str:String):String
		{
		    return new XMLDocument(str).firstChild.nodeValue;
		}
		
		public static function htmlEscape(str:String):String
		{
		    return XML( new XMLNode( XMLNodeType.TEXT_NODE, str ) ).toXMLString();
		}
		
		// returns brightness value from 0 to 255 (> 200 is bright)
		public static function getBrightness(color:uint):int
		{
			var r:int = (color >> 16) & 0xFF;
		    var g:int = (color >> 8) & 0xFF;
		    var b:int = color & 0xFF;
		    
			return ((r * 299) + (g * 587) + (b * 114)) / 1000;
		}
		
		public static function rgb_to_hsb(color:uint):Array
		{
		    var r:int = (color >> 16) & 0xFF;
		    var g:int = (color >> 8) & 0xFF;
		    var b:int = color & 0xFF;
		
		    var min:int = Math.min(Math.min(r, g), b);
		    var max:int = Math.max(Math.max(r, g), b);
		
		    var delta:int = max - min;
		
		    var brightness:int = max;
		    var saturation:Number = (max == 0) ? 0 : Number(delta) / max;
		
		    var hue:Number = 0;
		    if (saturation != 0) {
		        if (r == brightness) hue = (60 * (g - b)) / delta;
		        else
		        if (g == brightness) hue = 120 + (60 * (b - r)) / delta;
		        else         hue = 240 + (60 * (r - g)) / delta;
		
		        if (hue < 0) hue += 360;
		    }
		
		    return [ Math.round(hue), Math.round(saturation * 100), Math.round((brightness / 255) * 100) ];
		}

		public static function hsb_to_rgb(hsb:Array):uint
		{
		    var brightness:Number = hsb[2] / 100;
		    if (brightness == 0) return 0;
		    var hue:Number = (hsb[0] % 360) / 60;
		    var saturation:Number = hsb[1] / 100;
		
		    var i:Number = Math.floor(hue);
		    var p:Number = (1 - saturation);
		    var q:Number = (1 - (saturation * (hue - i)));
		    var t:Number = (1 - (saturation * (1 - (hue - i))));
		
		    var r:Number, g:Number, b:Number;
		    switch (i) {
		        case 0: r = 1; g = t; b = p; break;
		        case 1: r = q; g = 1; b = p; break;
		        case 2: r = p; g = 1; b = t; break;
		        case 3: r = p; g = q; b = 1; break;
		        case 4: r = t; g = p; b = 1; break;
		        case 5: r = 1; g = p; b = q; break;
		    }
		
		    return ((Math.round(r * 255 * brightness) & 0xFF) << 16) | ((Math.round(g * 255 * brightness) & 0xFF) << 8) | (Math.round(b * 255 * brightness) & 0xFF);
		}
		
		public static function quickBox(aWidth:Number, aHeight:Number, color:uint, cornerRadius:Number = -1):Sprite {
			var returnSprite:Sprite = new Sprite;
			var g:Graphics = returnSprite.graphics;
			g.beginFill(color);
			if (cornerRadius > 0) {
				g.drawRoundRect(0,0,aWidth, aHeight, cornerRadius);
			} else {
				g.drawRect(0,0,aWidth, aHeight);
			}
			g.endFill();
			return returnSprite;
		}
		
		public static function eatWhitespace(s:String):String
		{
			while ( s && s.length > 0 && s.charAt(0) == ' ' )
			{
				s = s.slice(1);
			}
			
			return s;
		}
	}
}