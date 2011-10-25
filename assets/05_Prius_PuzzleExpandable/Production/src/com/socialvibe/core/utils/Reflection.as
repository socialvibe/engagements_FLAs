package com.socialvibe.core.utils
{
    import flash.display.*;
    import flash.events.*;
    import flash.geom.*;
    
    public class Reflection extends Sprite
    {
    	private var _alphaGradientBitmap: BitmapData;
        private var _targetBitmap: BitmapData;
        private var _resultBitmap: BitmapData;
        
        private var _falloff: Number;
        private var _disTarget: DisplayObject;
        
        public function Reflection(set_disTarget:DisplayObject, set_falloff:Number = 0.6, set_alpha:Number = 0.3)
        {
            _falloff = set_falloff;
            target = set_disTarget;
            
            this.alpha = set_alpha;
            this.mouseEnabled = false;
        }
        
        public function set target(set_disTarget:DisplayObject):void
        {
        	_disTarget = set_disTarget;
        	
        	if (_disTarget is EmbeddedImage)
        	{
        		if (!EmbeddedImage(_disTarget).isLoaded())
        		{
        			EmbeddedImage.imagesLoadDispatcher.addEventListener(EmbeddedImage.EMBEDDED_IMAGES_LOADED, onEmbeddedImagesLoaded, false, 0, true);
        			return;
        		}
        	}
        	
        	this.y = 0; // reset y-coord
        	createMyReflection();
        }
        
        private function onEmbeddedImagesLoaded(e:Event):void
        {
        	createMyReflection();
        }
        
        private function createMyReflection():void
        {
        	createBitmaps();
        	
        	var rect: Rectangle = new Rectangle(0, 0, _disTarget.width, _disTarget.height);
                
            // Draw the image of the target component into the target bitmap.
            _targetBitmap.fillRect(rect, 0);
            _targetBitmap.draw(_disTarget, new Matrix());
            
            // Combine the target image with the alpha gradient to produce the reflection image.
            _resultBitmap.fillRect(rect, 0);
            _resultBitmap.copyPixels(_targetBitmap, rect, new Point(), _alphaGradientBitmap);
            
            // Flip the image upside down.
            var transform: Matrix = new Matrix();
            transform.scale(1, -1);
            transform.translate(0, _disTarget.height);
            
            // Finally, copy the resulting bitmap into our own graphic context.
            graphics.clear();
            graphics.beginBitmapFill(_resultBitmap, transform, false);
            graphics.drawRect(0, 0, _disTarget.width, _disTarget.height);
            
            this.y += _disTarget.height;
        }
        
        private function createBitmaps():void
        {
        	destroyBitmaps();
        	
        	_alphaGradientBitmap = new BitmapData(_disTarget.width, _disTarget.height, true, 0);
            var gradientMatrix: Matrix = new Matrix();
            var gradientSprite: Sprite = new Sprite();
            gradientMatrix.createGradientBox(_disTarget.width, _disTarget.height * _falloff, Math.PI/2, 
                    0, _disTarget.height * (1.0 - _falloff));
            gradientSprite.graphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF], 
                    [0, 1], [0, 255], gradientMatrix);
            gradientSprite.graphics.drawRect(0, _disTarget.height * (1.0 - _falloff), 
                    _disTarget.width, _disTarget.height * _falloff);
           	gradientSprite.graphics.endFill();
            _alphaGradientBitmap.draw(gradientSprite, new Matrix());
            
            _targetBitmap = new BitmapData(_disTarget.width, _disTarget.height, true, 0);
            _resultBitmap = new BitmapData(_disTarget.width, _disTarget.height, true, 0);
        }
        
        public function destroyBitmaps():void
        {
        	if (_alphaGradientBitmap)
        		_alphaGradientBitmap.dispose();
        	if (_targetBitmap)
        		_targetBitmap.dispose();
        	if (_resultBitmap)
        		_resultBitmap.dispose();
        }
    }
}