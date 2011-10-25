package com.socialvibe.core.ui
{
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.utils.setTimeout;
	import com.socialvibe.core.ui.controls.SVText;
	
	import com.greensock.TimelineLite;
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
				
	public class SVSquareLoader extends Sprite
	{
		private var _box1:Sprite;
		private var _box2:Sprite;
		private var _box3:Sprite;
		private var _box4:Sprite;
		private var _box5:Sprite;
		private var _box6:Sprite;
		private var _box7:Sprite;
		private var _box8:Sprite;
		private var _box9:Sprite;
		
		private var _loadingText:SVText;
		
		private var _boxTimeline:TimelineLite;
		private var _textTimeline:TimelineLite;
		
		public function SVSquareLoader(big:Boolean = true, text:String = null)
		{
			//TimelineLite
			
			_box1 = new Sprite();
			var g:Graphics = _box1.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(0,0,8,8,6,1,1,1);
			g.endFill();
			this.addChild(_box1);
			
			_box2 = new Sprite();
			g = _box2.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(11,0,8,8,1,1,1,1);
			g.endFill();
			this.addChild(_box2);
			
			_box3 = new Sprite();
			g = _box3.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(22,0,8,8,1,6,1,1);
			g.endFill();
			this.addChild(_box3);
			
			_box4 = new Sprite();
			g = _box4.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(0,11,8,8,1,1,1,1);
			g.endFill();
			this.addChild(_box4);
			
			_box5 = new Sprite();
			g = _box5.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(11,11,8,8,1,1,1,1);
			g.endFill();
			this.addChild(_box5);
			
			_box6 = new Sprite();
			g = _box6.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(22,11,8,8,1,1,1,1);
			g.endFill();
			this.addChild(_box6);
			
			_box7 = new Sprite();
			g = _box7.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(0,22,8,8,1,1,6,1);
			g.endFill();
			this.addChild(_box7);
			
			_box8 = new Sprite();
			g = _box8.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(11,22,8,8,1,1,1,1);
			g.endFill();
			this.addChild(_box8);
			
			_box9 = new Sprite();
			g = _box9.graphics;
			g.beginFill(0xFFFFFF, 1);
			g.drawRoundRectComplex(22,22,8,8,1,1,1,6);
			g.endFill();
			this.addChild(_box9);
			
			if (text){
				_loadingText = new SVText(text, 0, 0, 13, false);
				_loadingText.x = (30 - _loadingText.width)/2;
				_loadingText.y = 30 + 2;
				this.addChild(_loadingText);				
			}
			
			scaleX = scaleY = (big ? 1.5 : 1);
			
			_boxTimeline = new TimelineLite();
			_textTimeline = new TimelineLite();
			
			//_timeline.addEventListener(TweenEvent.COMPLETE, restart, false, 0, true);
			TweenPlugin.activate([TintPlugin, RemoveTintPlugin]);
			setupAnimation();
		}
		
		private function setupAnimation():void
		{
			//As soon we update to v11 use this.
			/*_timeline.insert(new TweenLite(_box1, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box1, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box2, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box2, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box3, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box3, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box6, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box6, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box5, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box5, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box4, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box4, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box7, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box7, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box8, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box8, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box9, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box9, 1, {removeTint:true, useFrames:true }));
			
			_timeline.append(new TweenLite(_box6, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box6, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box5, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box5, 1, {removeTint:true, useFrames:true}));
			
			_timeline.append(new TweenLite(_box4, 3, {tint:0xC2C3C4, useFrames:true}));
			_timeline.append(new TweenLite(_box4, 1, {removeTint:true, useFrames:true, onComplete:restart}));*/
			
			_boxTimeline.insert(new TweenLite(_box1, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box1, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box2, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box2, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box3, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box3, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box6, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box6, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box5, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box5, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box4, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box4, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box7, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box7, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box8, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box8, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box9, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box9, .1, {removeTint:true, useFrames:true }));
			
			_boxTimeline.append(new TweenLite(_box6, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box6, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box5, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box5, .1, {removeTint:true, useFrames:true}));
			
			_boxTimeline.append(new TweenLite(_box4, .1, {tint:0xC2C3C4, useFrames:true}));
			_boxTimeline.append(new TweenLite(_box4, .1, {removeTint:true, useFrames:true, onComplete:restart}));
			
			if (_loadingText) {
				_textTimeline.insert( new TweenLite( _loadingText, 2.2, {alpha:0}) );
				_textTimeline.append( new TweenLite( _loadingText, 2.2, {alpha:1, onComplete: restartText}) );
			}			

		}
		
		private function restart():void
		{
			setTimeout(function():void{_boxTimeline.restart();}, 1);			
		}

		private function restartText():void
		{
			setTimeout(function():void{_textTimeline.restart();}, 1);			
		}
		
		private function delayBegin():void
		{
			this.visible = true;
			_boxTimeline.restart();
			
			if (_loadingText)
				_textTimeline.restart();
		}
		
		public function start():void
		{
			this.visible = false;
			
			setTimeout(delayBegin, 250);
		}
		
		public function stop():void
		{
			_boxTimeline.stop();
			
			if (_loadingText)
				_textTimeline.stop();
			
			if (parent && parent.contains(this))
				parent.removeChild(this);
		}
		
		public function get timeline():TimelineLite { return _boxTimeline};
		override public function get width() : Number { return (30*scaleX); };
	}
}