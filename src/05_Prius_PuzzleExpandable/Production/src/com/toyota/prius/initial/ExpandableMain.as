package com.toyota.prius.initial
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	import flash.display.Loader;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Back;
	import com.greensock.easing.Sine;
	
	import com.refunk.events.TimelineEvent;
	import com.refunk.timeline.TimelineWatcher;
	
	import com.toyota.prius.interfaces.IPriusExpandable;
	import com.toyota.prius.puzzle.views.PuzzleState;
	
	/**
	 * ...
	 * @author jin
	 */
	
	public class ExpandableMain extends MovieClip 
	{
		private const EXPAND_FILE:String 			= "900_418_Prius_Puzzle.swf";
		private const POLITE_LOAD_FILE:String 		= "970_66_Prius_PuzzleExpandable_assets.swf";
		
		private var politeLoadUrl:String;
		private var expandLoadUrl:String;
		
		private var autoExpand:Boolean 	= false;
		private var autoClose:Boolean 	= false;
		private var firstExpand:Boolean = false;
		private var firstEndAnim:Boolean = true;
		
		private var autoCollapseT:uint = 8.5;
		
		private var assetChild:MovieClip;
		private var logoMC:MovieClip;
		private var clickthruMC:MovieClip;
		private var firstLoad:Boolean = true;
		private var infoMC:MovieClip;
		private var timelineWatcher:TimelineWatcher;
		
		private var startTime:Number;
		
		//Set whether or not you want to load in external content on expand
		private const EXTERNAL_EXPAND:Boolean = true;
		
		//Set whether or not the ad should wait until the external content loads to expand  if EXTERNAL_EXPAND is set to true
		private const WAIT_TO_EXPAND:Boolean = true;
		
		//Set whether or not to unload the external content when the ad contracts  if EXTERNAL_EXPAND is set to true
		private const UNLOAD_CONTRACT:Boolean = true;
		
		//Set whether the ad is triggered by rollover [true] or by click [false]
		private const EXPAND_ON_OVER:Boolean = false;

		//This determines what state the ad is in, and also what states it can be sent into. If true, the ad is expanded/expanding, if false it is contracted/contracting
		private var adExpansion:Boolean = false;
		
		//If the content has already loaded once, this is set to true so that it doesn't reload everytime if unloadContent is set to false and EXTERNAL_EXPAND is set to true
		private var alreadyLoaded:Boolean = false;
		
		private var debugT:Number;
		
		public function ExpandableMain( auto:Boolean ):void 
		{
			debugT = getTimer();
			
			autoExpand 	= auto;
			autoClose 	= auto;
			firstExpand = autoExpand ? true : false;
			
			politeLoadUrl = POLITE_LOAD_FILE;
			expandLoadUrl = EXPAND_FILE;
			
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			start();
		}
		
		private function start():void
		{			
			btnPlay.alpha = 0;
			btnPlay.x = 910;
			btnPlay.mouseChildren = false;
			
			timelineWatcher = new TimelineWatcher(this);
			timelineWatcher.addEventListener(TimelineEvent.LABEL_REACHED, timelineEventHandler);
			
			loadAssets();
			
			// Initialize the contracted state.
			contractState();
			
			if ( !autoExpand )
			{
				TweenLite.delayedCall( 9, autoEndAnim );
			}
		}
		
		// *******************************************************
		// LOAD CARS
		// *******************************************************
		private function loadAssets():void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onCompleteHandler);
			
			var request:URLRequest = new URLRequest(politeLoadUrl);
			loader.load(request);
			assetContainer.addChild(loader);
			//loader.mouseChildren = loader.mouseEnabled = false;
		}

		private function onCompleteHandler(e:Event ):void
		{	
			assetChild 	= e.currentTarget.content as MovieClip;
			logoMC 		= assetChild.logoMC;
			clickthruMC = assetChild.clickthruMC;
			
			//assetChild.mouseChildren = assetChild.mouseEnabled = false;
			infoMC = assetChild.viewInfo;
			viewInfo.visible = true;
			
			var label:String = autoExpand ? "introAnimShort" : "introAnim";
			//var label:String = "introAnim";
			assetChild.gotoAndStop( label );
			
			initBtns();
			timerStart();
		}
		
		// *******************************************************
		// INTRO ANIM TIMER
		// *******************************************************
		
		private function timerStart():void 
		{
			var t:Number = 3.7;
			
			var myTimer:Timer = new Timer(1000*t, 1);
			myTimer.addEventListener("timer", timerHandler);
			myTimer.start();
		}

		private function timerHandler(event:TimerEvent):void 
		{
			showBtns();
		}
		
		// *******************************************************
		// BASIC BUTTON FUNC
		// *******************************************************

		private function showBtns():void
		{
			logoMC.logoToyota.visible = true;
			
			btnPlay.y = 21;
			btnPlay.x = 667 + 40;
			
			TweenLite.killTweensOf( btnPlay );
			TweenLite.to( btnPlay, .6, { alpha:1, x:667, ease:Back.easeOut } );
			
			if ( autoExpand ) onPlayClick();
		}
		
		private function initBtns():void
		{
			createBtn( viewInfo );
			createBtn( logoMC.logoPriusGoes );
			createBtn( logoMC.logoToyota );
			createBtn( close_mc );
			createBtn( clickthruMC );
			
			//assetContainer.mouseChildren 	= assetContainer.mouseEnabled = false;
			
			logoMC.logoToyota.visible 	= false;
			viewInfo.buttonMode = false;
			
			btnPlay.buttonMode 	= true;
			btnPlay.y = -100;
			btnPlay.gotoAndStop( "up" );
		}
		
		private function createBtn( btn:MovieClip ):void
		{
			btn.addEventListener( MouseEvent.CLICK, 	onBtnClick);
			btn.addEventListener( MouseEvent.ROLL_OVER, onBtnOver );
			btn.addEventListener( MouseEvent.ROLL_OUT, 	onBtnOut );
			btn.gotoAndStop( "up" );
			btn.buttonMode = true;
			btn.mouseChildren = false;
		}

		private function onBtnClick( e:MouseEvent=null, str:String="", auto:Boolean=false ):void
		{
			if ( !auto )
			{
				autoClose 	= false;
				if ( autoExpand )
				{
					autoExpand = false;
					TweenLite.killDelayedCallsTo( onBtnClick );
					TweenLite.killDelayedCallsTo( autoEndAnim );
					
					playEndAnim();
				}
			}
			
			var which:String;
			
			if ( e ) {
				var btn:MovieClip = e.currentTarget as MovieClip;
				which = btn.name;
			}
			else
			{
				which = str;
			}
			
			switch ( which )
			{
				case "logoPriusGoes":
					EWBase.clickthru("clickTag3", "Prius Goes Plural Clickthru");
					break;
					
				case "logoToyota":
					EWBase.clickthru("clickTag2", "Toyota Logo Clickthru");
					break;
					
				case "clickthruMC":
					//Clicksthru to clickTag1, and shows up in reporting as 'Background Clickthru'
					EWBase.clickthru("clickTag1", "Background Clickthru");
					break;
					
				case "close_mc":
					
					firstExpand = false;
					TweenLite.killDelayedCallsTo( onBtnClick );
					
					// EWBase.trackInteraction(); is used to track clicks within a unit. To track user interaction with any button except for AdWonder component buttons (tracking functionality is already built in) and clickthroughs, use EWBase.trackInteraction();
					// EWBase.trackInteraction(); takes a string as a parameter. It usually reflects the label used for the button in the creative. Simply make sure it is something intuitive and meaningful since it's what will appear in our reporting system. 
					if( !autoClose ) EWBase.trackInteraction( "Close" );
					onMouseOut( null, true );
					
					break;
			}
		}

		private function onBtnOver( e:MouseEvent ):void
		{
			var btn:MovieClip = e.currentTarget as MovieClip;
			btn.gotoAndPlay( "over" );
			
			var which:String = btn.name;
			switch ( which )
			{
				case "viewInfo":
					infoMC.gotoAndPlay( "over" );
					EWBase.trackInteraction("ViewInformation");
					break;
			}
		}
		private function onBtnOut( e:MouseEvent ):void
		{
			var btn:MovieClip = e.currentTarget as MovieClip;
			btn.gotoAndPlay( "out" );
			
			var which:String = btn.name;
			switch ( which )
			{
				case "viewInfo":
					infoMC.gotoAndPlay( "out" );
					break;
			}
		}
		
		// *******************************************************
		// VIDEO
		// *******************************************************
		// called when you click replay-
		private function clearVid():void
		{
			trace(this, "clearVid!");
			// Clear all vid listener
			//removeVidListener();
			if ( vid ) if ( vid.video_ew ) vid.video_ew.stopVideo(); //pauseVideo
			EWVideo.stopAll();
			
			if ( vid )
			{
				TweenLite.delayedCall( .4, removeTempBg ); 
			}
		}
		
		private function removeTempBg( ):void
		{
			if ( vid )
			{
				EWVideo.stopAll( true );
				vid.gotoAndStop( 1 );
			}
		}
		
		private function playVid():void
		{
			vid.gotoAndPlay( 2 );
		}
		
		// called from fla
		public function vidInit():void 
		{
			trace(this, "vidInit - called from fla");
			if( !vid.video_ew.hasEventListener( "playbackStart" ) ) 	vid.video_ew.addEventListener( "playbackStart", onPlayBackStarted );
			if( !vid.video_ew.hasEventListener( "onVidStarted" ) ) 		vid.video_ew.addEventListener( "onVidStarted", 	onVidStarted );
			vid.video_ew.mouseChildren = vid.video_ew.mouseEnabled = false;
		}
		
		private function resetTopContainer():void
		{
			if ( topContainer.numChildren == 0 ) return;
			if ( topContainer.getChildAt( 0 ).numChildren == 0 ) return;
			
			trace("assetChild : " + assetChild );
			
			if ( assetChild )
			{
				assetContainer.y = 0;
				assetChild.gotoAndStop( "idle" );
			}
		}
		
		private function onPlayBackStarted(e:Event):void
		{
			trace("onPlayBackStarted : ");
			
			if ( !EW.isExpanded || puzzlePlaying )
			{
				//removeVidListener();
				if ( vid ) if ( vid.video_ew ) vid.video_ew.stopVideo( true );
				EWVideo.stopAll();	
				return;
			}
		}
		
		private function onVidStarted(e:Event):void
		{
			removeLoader();
			
			if ( !EW.isExpanded || puzzlePlaying )
			{
				//removeVidListener();
				if ( vid ) if ( vid.video_ew ) vid.video_ew.stopVideo( true );
				EWVideo.stopAll();
				return;
			}
			
			// CALL TOP CONTAINER ( CUBE ) TO PLAY OUTRO ANIM
			var expandChild:IPriusExpandable = topContainer.getChildAt( 0 ).getChildAt( 0 ) as IPriusExpandable;
			expandChild.cubePlayOutro();
			
		}

		private function removeVidListener():void
		{
			EWVideo.stopAll( true );
			
			if ( !vid ) return;
			if ( !vid.video_ew ) return;
			
			if ( vid.video_ew.hasEventListener( "playbackStart" ) ) vid.video_ew.removeEventListener( "playbackStart", 	onPlayBackStarted);
			if ( vid.video_ew.hasEventListener( "onVidStarted" ) ) 	vid.video_ew.removeEventListener( "onVidStarted", 	onVidStarted);
			
			vid.video_ew.stopVideo( true );
		}
		
		private function get puzzlePlaying():Boolean 
		{
			var expandChild:IPriusExpandable = topContainer.getChildAt( 0 ).getChildAt( 0 ) as IPriusExpandable;
			var puzzlePlaying:Boolean = EW.isExpanded && ( expandChild.puzzleState != PuzzleState.SOLVED && expandChild.puzzleState != PuzzleState.OUTRO && expandChild.puzzleState != PuzzleState.OUTRO_DONE );
			return puzzlePlaying;
		}
		
		// *******************************************************
		// EYE WONDER UI
		// *******************************************************

		//Our mouseout functionality.
		private function onMouseOut(evt:Event = null, force:Boolean=false ):void
		{
			if (adExpansion)
			{
				if ( !force ) 
				{
					// CHECK - is Puzzle or Video playing
					if ( !vid ) return;
					if ( !vid.video_ew ) return;
					if ( topContainer.numChildren > 0 ) {
						var expandChild:IPriusExpandable = topContainer.getChildAt( 0 ).getChildAt( 0 ) as IPriusExpandable;
						trace( this, "puzzleState: " + expandChild.puzzleState )
						if ( ( expandChild.puzzleState != PuzzleState.OUTRO && expandChild.puzzleState != PuzzleState.OUTRO_DONE ) ) return;
					}
				}
			
				//Remove the event listeners.
				EWBase.removeEventListener("clickthru", onMouseOut);
				
				if(EXPAND_ON_OVER){
					//Only remove the mouseOut listener if the ad expands on rollover, otherwise the mouseOut eventListener won't exist
					EWBase.removeEventListener("mouseOut", onMouseOut);
				}
				
				//Since the ad is now contracting, adExpansion is false
				adExpansion = false;
				
				//If EWPanel.expand got called, contract the ad, otherwise, do nothing since the ad never expanded
				if (EWPanel.isExpanded) 
				{
					onContract();
				}
			}
		}

		//Our rollover functionality.
		private function onPlayClick(evt:Event = null):void
		{	
			//If the ad isn't already expanded
			if (!adExpansion)
			{
				//Check to see if the user is using Safari or Chrome
				if(EWBase.browserEngine == "webkit" && EXPAND_ON_OVER && (typeof btnPlay == "movieclip")){
					//Go into the expandState when the user rolls over after checking for mouse motion to avoid errors in Safari/Chrome
					btnPlay.addEventListener(MouseEvent.MOUSE_MOVE, expandState);
					
				//Otherwise, expand regardless of motion
				}else{
					expandState();
				}
			}
		}
		
		private function hotspotTimerStart():void 
		{
			var delay:Number = autoExpand && firstEndAnim ? .5 : 2.5;
			var timer:Timer = new Timer(delay * 1000, 1);
			timer.addEventListener("timer", hotspotTimerHandler);
			timer.start();
		}

		private function hotspotTimerHandler(event:TimerEvent):void 
		{
			enableHotSpot();
		}
		
		// *******************************************************
		// EXPAND / CONTRACT
		// *******************************************************
		
		// CONTRACT
		private function onContract():void
		{
			trace(this, "onContract : ");
			
			//removeVidListener();
			if ( vid ) if ( vid.video_ew ) vid.video_ew.stopVideo( true );
			EWVideo.stopAll();
				
			gotoAndPlay("contract");
			logoMC.gotoAndPlay("contract");
					
			removeLoader();
			resetTopContainer();
			if ( assetChild ) assetChild.gotoAndStop( "idle" );
			
			if ( clickthruMC ) clickthruMC.y = 0;
			
			if ( topContainer.numChildren > 0 ) 
			{
				var expandChild:IPriusExpandable = topContainer.getChildAt( 0 ).getChildAt( 0 ) as IPriusExpandable;
				expandChild.cubeStop();
			}
			
			// --> replaced from timelineEventHandler!
			// EWPanel.contract() will clip the stage area so that only the contracted area is visible, but we only want to call EWPanel.contract() if the EWPanel.expand was actually called
			if (EWPanel.isExpanded)
			{
				var interactionType:String 	= autoClose ? "event" : "interaction";
				var actionType:String 		= autoClose ? "A" : "C";
				autoClose = false;
				EWPanel.contract( "EW.panelName", interactionType, actionType );
			}
			
			trace("//onContract : ");
		}
		
		// EXPANDED
		private function expand():void
		{
			trace("//expand : " + expand);
			this.addFrameScript( this.currentFrame-1, null );

			close_mc.gotoAndStop( "up" );
			logoMC.logoPriusGoes.mc.gotoAndStop( 2 );
			logoMC.logoToyota.mc.gotoAndStop( 2 );
			
			resetTopContainer();
			removeLoader();
			
			vid.gotoAndStop( 1 );
			
			var expandChild:IPriusExpandable = topContainer.getChildAt( 0 ).getChildAt( 0 ) as IPriusExpandable;
			expandChild.solved.add( playVid );
			expandChild.replay.add( clearVid );
			expandChild.clickthru.add( onClickthru );
			
			if ( clickthruMC ) clickthruMC.y = -100;
			
			if ( autoExpand && firstExpand )
			{
				TweenLite.delayedCall( autoCollapseT, onBtnClick, [null, "close_mc", true ] );
				stage.addEventListener( MouseEvent.MOUSE_UP, onUserInteraction );
			}
				
			trace("//\\expand : " + expand);
		}
		
		//Setup the contract state.
		private function contractState():void
		{
			//Since the ad is contracted again, adExpansion is false
			adExpansion = false;
			
			//If UNLOAD_CONTRACT is set to true, unload the external content
			if(UNLOAD_CONTRACT){
				//Uncomment this line when using external files on expand
				if( topContainer.numChildren > 0 ) EWExternal.unloadContent(topContainer);//**
			}
			
			//Enable rollover after a half second delay, to avoid accidental re-expansion in IE7
			hotspotTimerStart();
			removeLoader();
			
			if ( logoMC )
			{
				logoMC.logoPriusGoes.mc.gotoAndStop( 1 );
				logoMC.logoToyota.mc.gotoAndStop( 1 );
			}
			
			if ( clickthruMC ) clickthruMC.y = 0;
		}
		

		//Setup the expand state.
		private function expandState(e:Event = null):void
		{
			TweenLite.killDelayedCallsTo( autoEndAnim );
			
			if( !autoExpand )
			{
				var target:MovieClip = assetChild.getChildAt( 0 );
				TweenLite.killTweensOf( target );
			}
			
			//Disable rollover.
			btnPlay.visible = false;
			
			if(EXPAND_ON_OVER){
				if(btnPlay.hasEventListener(MouseEvent.MOUSE_MOVE)) btnPlay.removeEventListener(MouseEvent.MOUSE_MOVE, expandState);
				if(btnPlay.hasEventListener(MouseEvent.MOUSE_OVER)) btnPlay.removeEventListener(MouseEvent.MOUSE_OVER, onPlayClick);
				
			}else{
				if(btnPlay.hasEventListener(MouseEvent.CLICK)) btnPlay.removeEventListener(MouseEvent.CLICK, onPlayClick);
			}
			
			//Since the ad is expanding, adExpansion is true
			adExpansion = true;	
			
			//Contract the ad if the user mouses off it.
			//This will play the contract animation and finally contract the ad.
			if(EXPAND_ON_OVER)
				EWBase.addEventListener("mouseOut", onMouseOut);
			
			//When the banner is expanded and the user clicks through, the panel should contract:
			EWBase.addEventListener("clickthru", onMouseOut);
			
			//If external expand & WAIT_TO_EXPAND are both set to true, and the external content isn't already loaded, load it and then call quickOutTest()
			if (EXTERNAL_EXPAND && WAIT_TO_EXPAND && !alreadyLoaded) {
				//Uncomment this line when using external files on expand
				EWExternal.loadContent(topContainer, expandLoadUrl, quickOutTest);//**
				addLoader();
					
			//Else if EXTERNAL_EXPAND is set to true and the external content isn't already loaded, load it and call quickOutTest simultaneously
			}else if(EXTERNAL_EXPAND && !alreadyLoaded){
				//Uncomment this line when using external files on expand
				//EWExternal.loadContent(topContainer, EXPAND_FILE);
				quickOutTest();
				
			//Otherwise, just call quickOutTest and don't load anythng
			}else{
				quickOutTest();
			}
		}

		// **************************************************
		

		private function quickOutTest(evt:Event = null)
		{
			// If the ad is contracting, or no longer expanded, trace 'Quick Out' and enter the contract state. 
			// This catches fast mouse over/out issues that can otherwise cause the ad to stick open
			if (!adExpansion)
			{
				EWBase.sendToPanel("Quick Out");
				contractState();
				
			}else {
				
				var panelName:String 		= ( autoExpand && firstExpand ) ? "Auto_Panel" : "Main Panel";
				var interactionType:String 	= ( autoExpand && firstExpand ) ? "event" : "interaction";
				var actionType:String 		= ( autoExpand && firstExpand ) ? "A" : "C";
				
				// EWPanel.expand() allows the entire stage area to become visible
				// The string "Main Panel" can be changed to better fit your naming conventions. This string is what will show up in our reporting system, so make sure to use something meaningful and intuitive.
				EWPanel.expand( panelName, interactionType, actionType );//
			
				//Play the expand animation
				gotoAndPlay("expand");
				logoMC.gotoAndPlay("expand");
				this.addFrameScript( this.currentFrame-1, expand );
				
			}
			//If the UNLOAD_CONTRACT is set to false, set alreadyLoaded to true, so that it doesn't reload the content anymore
			if(!UNLOAD_CONTRACT){
				alreadyLoaded = true;
			}
		}
			
		//This function re-enables the hotspot, and is called on a half second delay by contractState()
		private function enableHotSpot()
		{	
			if ( !firstEndAnim ) 
			{
				btnPlay.visible = true;
				btnPlay.alpha = 0;
				btnPlay.y = 3;
				btnPlay.x = 900;
			
				TweenLite.killTweensOf( btnPlay );
				TweenLite.to( btnPlay, .7, { alpha:1, x:854, ease:Back.easeOut } );
			}
			
			if(EXPAND_ON_OVER){
				//If the ad expands on rollover, enable the onRollOver listener for the hotspot
				if( !btnPlay.hasEventListener( MouseEvent.MOUSE_OVER ) ) btnPlay.addEventListener(MouseEvent.MOUSE_OVER, onPlayClick);
			
			}else{
				//Otherwise, enable the click listener
				if( !btnPlay.hasEventListener( MouseEvent.CLICK ) )btnPlay.addEventListener(MouseEvent.CLICK, onPlayClick);
			}
			
			if( !btnPlay.hasEventListener( MouseEvent.ROLL_OVER ) ) btnPlay.addEventListener(MouseEvent.ROLL_OVER, onExpandOver);
			if( !btnPlay.hasEventListener( MouseEvent.ROLL_OUT ) )  btnPlay.addEventListener(MouseEvent.ROLL_OUT, onExpandOut);
		}

		private function onExpandOver( e:MouseEvent ):void
		{
			btnPlay.gotoAndStop( "over" );
		}
		
		private function onExpandOut( e:MouseEvent ):void
		{
			btnPlay.gotoAndStop( "out" );
		}
		
		private function onClickthru():void
		{
			onBtnClick( null, "clickthruMC" );
		}
		
		// *******************************************************
		// POLITE LOADER
		// *******************************************************
		
		private function addLoader():void
		{
			if ( !this.getChildByName( "loaderCircle" ) )
			{
				var loader:MovieClip =  new loaderCircle() as MovieClip;
				this.addChild( loader );
				loader.name = "loaderCircle";
				loader.x = btnPlay.x + 64;
				loader.y = btnPlay.y + 11;
				firstLoad = false;
			}
		}
		
		private function removeLoader():void
		{
			if ( this.getChildByName( "loaderCircle" ) )
			{
				var loader:MovieClip =  this.getChildByName( "loaderCircle" ) as MovieClip;
				loader.stop();
				this.removeChild( loader );
			}
		}
		
		// *******************************************************
		// PLAY END ANIM
		// *******************************************************
		
		private function autoEndAnim():void
		{
			TweenLite.killDelayedCallsTo( autoEndAnim );
			
			btnPlay.mouseEnabled = false;
			
			var target:MovieClip = assetChild.getChildAt( 0 );
			
			TweenLite.to( target, 	   .75,	{ alpha:0, ease:Sine.easeOut, delay:.3, onComplete:playEndAnim } );
			TweenLite.to( target.copy1,.5,	{ alpha:0, ease:Sine.easeIn } );
			
			TweenLite.to( btnPlay, .5,	{ alpha:0, ease:Sine.easeIn } );
		}
		
		private function playEndAnim():void
		{
			if ( adExpansion ) return;
			
			var label:String = autoExpand && firstEndAnim ? "endAnimShort" : "endAnim";
			if ( firstEndAnim ) firstEndAnim = false;
				
			if ( !autoExpand )
			{
				var target:MovieClip = assetChild.getChildAt( 0 );
				TweenLite.killTweensOf( target );
			}
				
			assetChild.alpha = 1;
			assetChild.gotoAndStop( label );
			
			btnPlay.mouseEnabled = true;
			btnPlay.y = 3;
			btnPlay.x = 900;
			TweenLite.killTweensOf( btnPlay );
			TweenLite.to( btnPlay, .7, { alpha:1, x:854, ease:Back.easeOut } );
			
			trace( "PLAY END ANIM " + (debugT - getTimer()) / 1000 );
		}
		
		// *******************************************************
		// AUTO - USER INTERACTION 
		// *******************************************************
		private function onUserInteraction( e:MouseEvent ):void
		{
			trace("onUserInteraction : " + onUserInteraction);
			if ( autoExpand )
			{
				autoExpand = false;
				autoClose = false;
				TweenLite.killDelayedCallsTo( onBtnClick );
				TweenLite.killDelayedCallsTo( autoEndAnim );
			}
		}
		
		// *******************************************************
		// TimelineWatcher
		// *******************************************************
		
		private function timelineEventHandler(e:TimelineEvent):void 
		{
			if ( !e.currentLabel ) return;
			
			var curLabel:String = e.currentLabel;
			
			switch ( curLabel )
			{
				case "contracted":
					/*
					// EWPanel.contract() will clip the stage area so that only the contracted area is visible, but we only want to call EWPanel.contract() if the EWPanel.expand was actually called
					if (EWPanel.isExpanded)
					{
						var interactionType:String 	= autoClose ? "event" : "interaction";
						var actionType:String 		= autoClose ? "A" : "C";
						autoClose = false;
					
						EWPanel.contract( "EW.panelName", interactionType, actionType );
					}
					*/
					// We're back in the contracted state so we set it up again.
					contractState();
					
					playEndAnim();
					
					break;
			}
		}
		
		private function removeTimelineWatcher():void
		{
			if ( timelineWatcher )
			{
				timelineWatcher.removeEventListener(TimelineEvent.LABEL_REACHED, timelineEventHandler);
				timelineWatcher.dispose();
				timelineWatcher = null;
			}
		}
	}

}