﻿package { 		import flash.display.MovieClip;	import flash.events.MouseEvent;	import flash.text.TextField;	import com.greensock.*; 	import com.greensock.easing.*;	import flash.display.SimpleButton;	public class ButtonPlayNow extends SimpleButton {	private var _harea;		public function ButtonPlayNow() {					_harea = this;						enable();					}				public function buttonOver(e:MouseEvent = null):void {						e.currentTarget.parent.gotoAndPlay(2);					}				public function buttonOut(e:MouseEvent = null):void {						e.currentTarget.parent.gotoAndPlay(6);					}						public function buttonClick(e:MouseEvent = null):void {						/*on(rollOver){	gotoAndStop(2);}on(rollOut){	gotoAndStop(1);}on(release){	gotoAndStop(3);	_parent._parent.play();	_parent._parent.LED.play();}*/												}		public function enable() {						_harea.buttonMode = true;						if (!_harea.hasEventListener(MouseEvent.ROLL_OVER))			_harea.addEventListener(MouseEvent.ROLL_OVER, buttonOver);						if (!_harea.hasEventListener(MouseEvent.ROLL_OUT))			_harea.addEventListener(MouseEvent.ROLL_OUT, buttonOut);						if (!_harea.hasEventListener(MouseEvent.CLICK))			_harea.addEventListener(MouseEvent.CLICK, buttonClick);					}		public function disable() {						_harea.buttonMode = false;			_harea.removeEventListener(MouseEvent.ROLL_OVER, buttonOver);			_harea.removeEventListener(MouseEvent.ROLL_OUT, buttonOut);			_harea.removeEventListener(MouseEvent.CLICK, buttonClick);					}			}		}