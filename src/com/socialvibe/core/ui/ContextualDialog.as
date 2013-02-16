package com.socialvibe.core.ui
{
	import com.socialvibe.core.config.*;
	import com.socialvibe.core.ui.controls.SVText;
	
	import flash.display.*;
	import flash.events.*;

	public class ContextualDialog extends Sprite
	{
		public static const CONFIRM : String = 'confirm';
		public static const CANCEL : String = 'cancel';
		
		public static const MAX_WIDTH : Number = 350
		
		private var _width : Number = MAX_WIDTH;
		private var _height : Number;
		
		private var _addingSprite : Sprite;
		private var _holdingSprite : Sprite;
		
		private var _arrowPosPercent : Number;
		
		public function ContextualDialog( title:String, body:String, confirmText:String = "Okay", cancelText:String = null, arrowPositionInPercent:Number = 0.25)
		{
			name = "contextualDialog";
			_arrowPosPercent = arrowPositionInPercent
	
			// handle question title and text			
			var titleText:SVText = new SVText( title, 5, 5, 11, true, 0x252525);
			var bodyText:SVText = new SVText( body, 5, 25, 11, false, 0x252525);
			
			var maxTextWidth:Number = Math.max( bodyText.width, titleText.width );
			
			if (maxTextWidth > MAX_WIDTH){
				titleText = new SVText( title, 10, 10, 11, true, 0x252525, _width - 25);
				titleText.multiline = true;
				bodyText = new SVText( body, 10, 30, 11, false, 0x252525, _width - 25);
				bodyText.multiline = true;
			} else {
				_width = (maxTextWidth + 25) < 100 ? 100 : (maxTextWidth + 25);
			}
			
			var combinedText:SVText
			
			addChild(titleText)
			addChild(bodyText);
			
			
			// add buttons
			var cancelButtonWidth:Number = 0;
			var cancelButtonX:Number = _width;
			
			if (cancelText){
				var cancelButton:BoringFBButton = new BoringFBButton(cancelText, CANCEL);
				cancelButton.x = _width - cancelButton.width - 10;
				cancelButton.y = bodyText.y + bodyText.height + 4;

				cancelButtonX = cancelButton.x;
				cancelButtonWidth = cancelButton.width;
				
				cancelButton.addEventListener(MouseEvent.CLICK, onCancel);
				addChild(cancelButton);
			}
			var confirmButton:BoringFBButton = new BoringFBButton(confirmText, CONFIRM);

			_width = ( cancelButtonWidth + confirmButton.width + 40 ) > _width ? ( cancelButtonWidth + confirmButton.width + 40 ) : _width;
			
			confirmButton.x = cancelButtonX - 10 - confirmButton.width;
			confirmButton.y = bodyText.y + bodyText.height + 4;
			confirmButton.addEventListener(MouseEvent.CLICK, onConfirm);
			addChild(confirmButton);


			// readjust height			
			_height = confirmButton.y + confirmButton.height + 10;			
			
			// draw background
			var g:Graphics = this.graphics;
			g.lineStyle(1, 0xb7b7b7);
			g.beginFill(FacebookConstants.LIGHT_GRAY, 1);
			g.lineTo(0, _height);
			g.lineTo(_width, _height);
			g.lineTo(_width, 0);
			
			if (_arrowPosPercent < .50){
				g.lineTo(_width*_arrowPosPercent + 12, 0);
				g.lineTo(_width*_arrowPosPercent, -12);
				g.lineTo(_width*_arrowPosPercent, 0);
			} else {
				g.lineTo(_width*_arrowPosPercent, 0);
				g.lineTo(_width*_arrowPosPercent, -12);
				g.lineTo(_width*_arrowPosPercent - 12, 0);
			}
			
			g.lineTo(0,0);			
			
			g.lineStyle(2, FacebookConstants.FB_BLUE);
			g.moveTo(1, _height);
			g.lineTo(_width-1, _height);
		}
		
		public function display( _dispObj:Sprite ):void
		{
			_addingSprite = _dispObj;
			
			var dispObj:Sprite = _addingSprite;
			var translatedX:Number = this.x;
			var translatedY:Number = this.y;
			
			while ( dispObj.parent != null && dispObj.parent as Sprite != null){
				translatedX += dispObj.x;
				translatedY += dispObj.y
				dispObj = dispObj.parent as Sprite;
			}
			
			super.x = translatedX;
			super.y = translatedY;

			_holdingSprite = dispObj;			
			if (_holdingSprite.getChildByName( this.name )){
				_holdingSprite.removeChild( _holdingSprite.getChildByName( this.name ) );
			}
			_holdingSprite.addChild( this );
			


			_addingSprite.addEventListener(Event.REMOVED_FROM_STAGE, onParentRemoved);
		}
		
		public function hide():void
		{
			_addingSprite.removeEventListener(Event.REMOVED_FROM_STAGE, onParentRemoved);
			
			if ( _holdingSprite.contains(this) ){
				_holdingSprite.removeChild(this);
			}
		}
		
		private function onCancel(e:Event):void
		{
			this.hide();
			dispatchEvent( new Event(CANCEL, true) );			
		}
		
		private function onConfirm(e:Event):void
		{
			this.hide();
			dispatchEvent( new Event(CONFIRM, true) );
		}
		
		private function onParentRemoved(e:Event):void
		{			
			_addingSprite.removeEventListener(Event.REMOVED, onParentRemoved);
			
			if ( _holdingSprite.contains(this) ){
				_holdingSprite.removeChild(this);
			}
		}
		
		override public function set x( n:Number ):void
		{
			super.x = - (_width*_arrowPosPercent); 
			super.x = super.x + n;
		}
		
		override public function set y( n:Number ):void
		{
			super.y = n + 12;
		}
	}
}

import com.socialvibe.core.config.*;
import com.socialvibe.core.ui.controls.*;

import flash.display.*;
import flash.events.*;

internal class BoringFBButton extends Sprite {

	public function BoringFBButton( text:String, linkEvent:String ){
		var buttonText:SVText = new SVText( text, 15, 3, 11, false, 0xffffff );
		addChild(buttonText);
		
		var g:Graphics = this.graphics;
		g.beginFill(0xD9DFEA, 1);
		g.drawRect(0, 0, buttonText.width + 29, buttonText.height + 5);
		g.drawRect(1, 1, buttonText.width + 28, buttonText.height + 4);
		
		g.beginFill(0x0E1F5B, 1);
		g.drawRect(1, 1, buttonText.width + 28, buttonText.height + 4);
		g.drawRect(1, 1, buttonText.width + 27, buttonText.height + 3);
		
		g.beginFill(0x3b5998, 1);
		g.drawRect(1, 1, buttonText.width + 27, buttonText.height + 3);
		
		this.buttonMode = true;
		this.useHandCursor = true;
	}

}