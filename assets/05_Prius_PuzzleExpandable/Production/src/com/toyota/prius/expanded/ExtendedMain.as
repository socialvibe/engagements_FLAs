package com.toyota.prius.expanded
{
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.events.MouseEvent;
		
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.TimelineLite;
	import com.greensock.easing.*;
	import com.gskinner.utils.Rnd;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author jin
	 */
	
	public class ExtendedMain extends MovieClip 
	{
		private var timeline:TimelineLite;
		public var playVid:Signal;
		public var replay:Signal;
		
		public function ExtendedMain():void 
		{
			playVid = new Signal();
			replay = new Signal();
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			init();
		}
		
		private function onRemovedFromStage(e:Event = null):void 
		{
			removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			
			if ( timeline ) timeline.kill();
			TweenMax.killAll();
			
			hideCopy();
		}
		
		private function init():void 
		{
			hideCopy();
			playEveryoneAnim();
			btnPlayVid.addEventListener( MouseEvent.CLICK, onPlayClick );
		}
		
		private function onPlayClick(e:MouseEvent):void
		{
			trace("onPlayClick : " + onPlayClick);
			playVid.dispatch();
		}
		
		public function cubePlayOutro():void
		{
			trace("cubePlayOutro : " + cubePlayOutro);
			
		}
		
		public function hideCopy():void
		{
			copyMC.visible = false;
			btnPlayVid.visible = true;
			
		}
		
		public function playEveryoneAnim( short:Boolean = false ):void 
		{
			var offY:int 	= 15;
			var offY2:int 	= offY*.8;
			var fromS:Number 	= .6;
			var t1:Number 		= .5;
			var t2:Number 		= .45;
			
			copyMC.visible = true;
			
			if ( timeline ) timeline.kill();
			
			timeline = new TimelineLite();
			timeline.append( TweenMax.from( copyMC.copyHead, 1, { alpha:0, ease:Sine.easeOut  } ) );
			
			timeline.append( TweenMax.from( copyMC.copySub, .75, { alpha:0, ease:Sine.easeOut  } ), -.25 );
			timeline.append( TweenMax.from( copyMC.copy1H, t1, { scaleX:fromS, scaleY:fromS, y:copyMC.copy1H.y + offY, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[2]  } ), .1 );
			timeline.append( TweenMax.from( copyMC.copy1S, t2, { scaleX:fromS, scaleY:fromS, y:copyMC.copy1S.y + offY2, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1]  } ), -.4 );
			timeline.append( TweenMax.from( copyMC.copy2H, t1, { scaleX:fromS, scaleY:fromS, y:copyMC.copy1H.y + offY, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[2]  } ), -.2 );
			timeline.append( TweenMax.from( copyMC.copy2S, t2, { scaleX:fromS, scaleY:fromS, y:copyMC.copy2S.y + offY2, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1]  } ), -.4 );
			timeline.append( TweenMax.from( copyMC.copy3H, t1, { scaleX:fromS, scaleY:fromS, y:copyMC.copy1H.y + offY, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[2]  } ), -.3 );
			timeline.append( TweenMax.from( copyMC.copy3S, t2, { scaleX:fromS, scaleY:fromS, y:copyMC.copy3S.y + offY2, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1]  } ), -.4 );
			timeline.append( TweenMax.from( copyMC.copy4H, t2, { scaleX:fromS, scaleY:fromS, y:copyMC.copy1H.y + offY, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[2]  } ), -.4 );
			timeline.append( TweenMax.from( copyMC.copy4S, t2, { scaleX:fromS, scaleY:fromS, y:copyMC.copy4S.y + offY2, rotation:randRot, alpha:0, ease:Back.easeOut, easeParams:[1]  } ), -.2 );
		}
		
		private function get randRot():Number
		{
			return Rnd.integer( 7, 15 ) * Rnd.sign();
		}

	}

}