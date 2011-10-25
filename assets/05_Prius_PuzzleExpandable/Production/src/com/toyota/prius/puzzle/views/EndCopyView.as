package com.toyota.prius.puzzle.views
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
		
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.TimelineLite;
	import com.greensock.easing.*;
	import com.gskinner.utils.Rnd;
	
	/**
	 * ...
	 * @author jin
	 */
	
	public class EndCopyView extends MovieClip 
	{
		private var timeline:TimelineLite;
		private var _copyHead:MovieClip;
		private var _copySub:MovieClip;
		private var _copy1H:MovieClip;
		private var _copy1S:MovieClip;
		private var _copy2H:MovieClip;
		private var _copy2S:MovieClip;
		private var _copy3H:MovieClip;
		private var _copy3S:MovieClip;
		private var _copy4H:MovieClip;
		private var _copy4S:MovieClip;
		private var _isDebug:Boolean;
		
		public function EndCopyView( debug:Boolean=false ):void 
		{
			_isDebug = debug;
			
			if ( _isDebug ) return;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, 	onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, 	onRemovedFromStage);
			
			init();
		}
		
		private function onRemovedFromStage(e:Event = null):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			if ( timeline ) timeline.kill();
		}
		
		private function init():void 
		{
			if ( !_isDebug )
			{
				_copyHead 	= this.getChildByName( "copyHead" )  as MovieClip;
				_copySub 	= this.getChildByName( "copySub" )  as MovieClip;
				_copy1H		= this.getChildByName( "copy1H" )  as MovieClip;
				_copy1S		= this.getChildByName( "copy1S" )  as MovieClip;
				_copy2H		= this.getChildByName( "copy2H" )  as MovieClip;
				_copy2S		= this.getChildByName( "copy2S" )  as MovieClip;
				_copy3H		= this.getChildByName( "copy3H" )  as MovieClip;
				_copy3S		= this.getChildByName( "copy3S" )  as MovieClip;
				_copy4H		= this.getChildByName( "copy4H" )  as MovieClip;
				_copy4S		= this.getChildByName( "copy4S" )  as MovieClip;
			}
				
			this.mouseChildren = this.mouseEnabled = false;
			
			for ( var i:uint = 0; i < this.numChildren; i ++ )
			{
				var mc:MovieClip = this.getChildAt( i ) as MovieClip;
				mc.mouseChildren = mc.mouseEnabled = false;
			}
			
			playEveryoneAnim();
		}
		
		public function playEveryoneAnim( short:Boolean = false ):void 
		{
			var offY:int 	= 15;
			var offY2:int 	= offY*.8;
			var fromS:Number 	= .6;
			var t1:Number 		= .5;
			var t2:Number 		= .45;
			
			if ( timeline ) timeline.kill();
			
			timeline = new TimelineLite( { delay:2 } );
			timeline.append( TweenMax.from( _copyHead, 1, { alpha:0, ease:Sine.easeOut  } ) );
			timeline.append( TweenMax.from( _copySub, .75, { alpha:0, ease:Sine.easeOut  } ), -.4 );
			timeline.append( TweenMax.from( _copy1H, t1, { scaleX:fromS, scaleY:fromS, y:_copy1H.y + offY, 	rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[2]  } ), -.4 );
			timeline.append( TweenMax.from( _copy1S, t2, { scaleX:fromS, scaleY:fromS, y:_copy1S.y + offY2, 	rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1]  } ), -.4 );
			timeline.append( TweenMax.from( _copy2H, t1, { scaleX:fromS, scaleY:fromS, y:_copy1H.y + offY, 	rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[2]  } ), -.2 );
			timeline.append( TweenMax.from( _copy2S, t2, { scaleX:fromS, scaleY:fromS, y:_copy2S.y + offY2, 	rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1]  } ), -.4 );
			timeline.append( TweenMax.from( _copy3H, t1, { scaleX:fromS, scaleY:fromS, y:_copy1H.y + offY, 	rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[2]  } ), -.3 );
			timeline.append( TweenMax.from( _copy3S, t2, { scaleX:fromS, scaleY:fromS, y:_copy3S.y + offY2, 	rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1]  } ), -.4 );
			timeline.append( TweenMax.from( _copy4H, t2, { scaleX:fromS, scaleY:fromS, y:_copy1H.y + offY, 	rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[2]  } ), -.4 );
			timeline.append( TweenMax.from( _copy4S, t2, { scaleX:fromS, scaleY:fromS, y:_copy4S.y + offY2, 	rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1]  } ), -.2 );
		}
		
		private function get randRot():Number
		{
			return Rnd.integer( 7, 15 ) * Rnd.sign();
		}

	}

}