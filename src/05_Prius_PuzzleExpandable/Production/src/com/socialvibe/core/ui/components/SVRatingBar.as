package com.socialvibe.core.ui.components
{
	import com.socialvibe.core.utils.SVEvent;
	
	import flash.display.*;
	import flash.events.*;
	
	public class SVRatingBar extends Sprite
	{
		public static const RATED:String = 'rated';
		
		private var _rating:Number;
		
		public function SVRatingBar()
		{
			for (var i:int=0; i<5; i++)
			{
				var star:RatingStar = new RatingStar();
				star.x = i * 19;
				star.addEventListener(MouseEvent.ROLL_OVER, onStarRollOver);
				star.addEventListener(MouseEvent.ROLL_OUT, onStarRollOut);
				star.addEventListener(MouseEvent.CLICK, onStarClick);
				addChild(star);
			}
		}
		
		private function onStarRollOver(e:Event):void
		{
			var idx:Number = this.getChildIndex(e.currentTarget as RatingStar);
			
			for (var i:int=0; i<numChildren; i++)
			{
				if (i <= idx)
					RatingStar(getChildAt(i)).color();
			}
		}
		
		private function onStarRollOut(e:Event):void
		{
			var idx:Number = this.getChildIndex(e.currentTarget as RatingStar);
			
			for (var i:int=0; i<numChildren; i++)
			{
				if (i <= idx)
					RatingStar(getChildAt(i)).uncolor();
			}
		}
		
		private function onStarClick(e:Event):void
		{
			var idx:Number = this.getChildIndex(e.currentTarget as RatingStar);
			
			for (var i:int=0; i<numChildren; i++)
			{
				var star:RatingStar = getChildAt(i) as RatingStar;
				
				star.removeEventListener(MouseEvent.ROLL_OVER, onStarRollOver);
				star.removeEventListener(MouseEvent.ROLL_OUT, onStarRollOut);
				star.removeEventListener(MouseEvent.CLICK, onStarClick);
				star.lock();
				
				if (i <= idx)
					star.color();
			}
			
			_rating = idx + 1;
			
			dispatchEvent(new SVEvent( RATED, _rating, true ));
		}
		
		public function get rating():Number { return _rating; }
	}
}

import flash.display.*;
import flash.events.*;
import flash.geom.*;

class RatingStar extends Sprite
{
	private var _star:Bitmap;
	private var _defaultTransform:ColorTransform;
	
	[Embed(source="assets/images/rating_star.png")]
	public static var RatingStarClass:Class;
	
	public function RatingStar()
	{
		_star = new RatingStarClass() as Bitmap;
		addChild(_star);
		
		_defaultTransform = _star.transform.colorTransform;
		
		this.buttonMode = true;
		this.useHandCursor = true;
	}
	
	public function color():void
	{
		var tf:ColorTransform = _star.transform.colorTransform;
		tf.color = 0xadcdf2;
		_star.transform.colorTransform = tf;
	}
	
	public function uncolor():void
	{
		_star.transform.colorTransform = _defaultTransform;
	}
	
	public function lock():void
	{
		this.buttonMode = false;
		this.useHandCursor = false;
		this.mouseEnabled = false;
	}
}