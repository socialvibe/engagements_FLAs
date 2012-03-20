package com.toyota.prius.cars 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.TimelineLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Sine;
	import com.gskinner.utils.Rnd;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author jin
	 */
	public class EndAnim extends MovieClip
	{
		private var offY:int 	=  10;
		private var fromS:Number = .6;
		private var t1:Number 	= .62;
		private var t2:Number 	= .5;
		private var time:Number;
		
		public function EndAnim() 
		{
			time = getTimer();
			
			addEventListener(Event.ADDED_TO_STAGE, initListener);
		}
		
		private function initListener(e:Event):void
		{
			this.removeEventListener(Event.ADDED_TO_STAGE, initListener);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler);
			
			this.mouseChildren 	= this.mouseEnabled = false;
			
			show();
		}
		
		private function onRemovedFromStageHandler(e:Event):void 
		{
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStageHandler);
			TweenMax.killChildTweensOf( this );
		}
		
		private function show():void
		{
			var short:Boolean = ( this.parent as MovieClip ).currentLabel == "endAnimShort";
			
			if ( short )
			{
				TweenLite.from( this, .6, { alpha:0, ease:Sine.easeIn  } );
				
			}
			else
			{
				var timeline:TimelineLite = new TimelineLite({});
				timeline.append( TweenLite.from( endCopy1, .6, { alpha:0, ease:Sine.easeOut  } ) );
				timeline.append( TweenLite.from( endCopy2, .8, { alpha:0, ease:Sine.easeOut  } ), -.5 );
				
				timeline.append( TweenLite.from( car1, t1, { x:car1.x - 60, y:car1.y - 14, alpha:0, ease:Back.easeOut, easeParams:[.75] } ) );
				timeline.append( TweenLite.from( txtPrius1, t2, { scaleX:fromS, scaleY:fromS, y:txtPrius1.y + offY, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1.5]  } ), -.35 );

				timeline.append( TweenLite.from( car2, t1, { x:car2.x - 60, y:car2.y + 3, alpha:0, ease:Back.easeOut, easeParams:[.75]  } ), -.2 );
				timeline.append( TweenLite.from( txtPrius2, t2, { scaleX:fromS, scaleY:fromS, y:txtPrius2.y + offY, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1.5]  } ), -.35 );

				timeline.append( TweenLite.from( car3, t1, { x:car3.x + 60, y:car3.y + 10, alpha:0, ease:Back.easeOut, easeParams:[.75] } ), -.25 );
				timeline.append( TweenLite.from( txtPrius3, t2, { scaleX:fromS, scaleY:fromS, y:txtPrius3.y + offY, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1.5]  } ), -.35 );

				timeline.append( TweenLite.from( car4, t1-.05, { x:car4.x + 60, y:car4.y - 15, alpha:0, ease:Back.easeOut, easeParams:[.75], onComplete:playWireAnim } ), -.35 );
				timeline.append( TweenLite.from( txtPrius4, t2, { scaleX:fromS, scaleY:fromS, y:txtPrius4.y + offY, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1.5]  } ), -.35 );
			}
		}
		
		private function playWireAnim():void
		{
			car4.gotoAndPlay( 2 );
			
			trace( ( time - getTimer() ) * .001 )
		}
		
		private function get randRot():Number
		{
			return Rnd.integer( 9, 15 ) * Rnd.sign();
		}
	}
	
}