package com.socialvibe.core.utils
{
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Orientation3D;
	import flash.geom.Point;
	
	import com.greensock.TweenLite;
	import com.greensock.easing.Bounce;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Elastic;
	
	public class SVTransistions
	{
		static public const LEFT:String = "left";
		static public const RIGHT:String = "right";
		
		static public const END_EVENT:String = 'TransitionHasEnded';
		
		public function SVTransistions() { }
		
		static public function CenterCameraAt(target:DisplayObject):void
		{
			
		}
		
		static public function FLIP (start_display:DisplayObject, end_display:DisplayObject, rotateFromCenter:Boolean = true, time:Number = 2, direction:String = RIGHT, centerProjection:Boolean = true):void
		{
			var parent:DisplayObjectContainer;
			var restoreXY:Array = [];
			
			parent = start_display.parent;
			
			if (centerProjection) {
				var originalProjectCenter:Point = parent.root.transform.perspectiveProjection.projectionCenter;
				var desiredProjectCenter:Point = parent.localToGlobal(new Point(start_display.x, start_display.y));
				parent.root.transform.perspectiveProjection.projectionCenter = new Point(desiredProjectCenter.x + start_display.width/2, desiredProjectCenter.y + start_display.height/2);
			}
			
			var holder1:Sprite = new Sprite();
			restoreXY[0] = start_display.x;
			restoreXY[1] = start_display.y;
			restoreXY[2] = parent.getChildIndex(start_display);
			
			if (rotateFromCenter) {
				holder1.x = start_display.x + start_display.width/2;
				holder1.y = start_display.y + start_display.height/2;
				
				start_display.x = -start_display.width/2;
				start_display.y = -start_display.height/2;
			} else {
				holder1.x = start_display.x;
				holder1.y = start_display.y;
				start_display.x = 0;
				start_display.y = 0;
			}
			
			parent.addChild(holder1);
			parent.removeChild(start_display);
			holder1.addChild(start_display);
			
			if (direction == RIGHT) {
				TweenLite.to(holder1, time/2, {rotationY:90, ease:Linear.easeNone});
			} else {
				TweenLite.to(holder1, time/2, {rotationY:-90, ease:Linear.easeNone});
			}
			
			var holder2:Sprite = new Sprite();
			restoreXY[3] = end_display.x;
			restoreXY[4] = end_display.y;
			restoreXY[5] = parent.getChildIndex(end_display);
			
			if (rotateFromCenter) {
				holder2.x = end_display.x + end_display.width/2;
				holder2.y = end_display.y + end_display.height/2;
			
				end_display.x = -end_display.width/2;
				end_display.y = -end_display.height/2;
			} else {
				holder2.x = end_display.x;
				holder2.y = end_display.y;
				end_display.x = 0;
				end_display.y = 0;
			}
			
			parent.addChild(holder2);
			parent.removeChild(end_display);
			holder2.addChild(end_display);
			
			if (direction == RIGHT) {
				holder2.rotationY = -90;	
			} else {
				holder2.rotationY = 90;
			}
			
			
			end_display.visible = false;
			
			TweenLite.to(holder2, time/2, {delay:time/2, rotationY:0, ease: Linear.easeNone,
				onStart: function():void {start_display.visible = false, end_display.visible = true},
				onComplete: function():void {
					//Restore XY
					start_display.x = restoreXY[0];
					start_display.y = restoreXY[1];
					end_display.x = restoreXY[3];
					end_display.y = restoreXY[4];
					//Switch Depth Layers
					parent.addChildAt(start_display, restoreXY[5]);
					parent.addChildAt(end_display, restoreXY[2]);
					//Fixing Project center
					if (centerProjection) {
						parent.root.transform.perspectiveProjection.projectionCenter = originalProjectCenter;
					}
					//CleanUp
					parent.removeChild(holder1);
					parent.removeChild(holder2);
					//FINISH event dispatch
					parent.dispatchEvent(new Event(END_EVENT, true, false)); }
			});
			
			
		}
		
		static public function NONE(start_display:DisplayObject, end_display:DisplayObject):void
		{
			if (start_display.parent.contains(start_display))
				start_display.parent.removeChild(start_display);
		}
		
		static public function BLUR2D(start_display:DisplayObject, end_display:DisplayObject, time:Number = 0.5):void
		{
			end_display.alpha = 0;
			TweenLite.to(start_display, time, {alpha:0, blurFilter:{blurX:50}, onComplete:function():void {
				start_display.parent.removeChild(start_display);
				TweenLite.to(end_display, time, {alpha:1, blurFilter:{blurX:0}, onComplete:function():void {
					end_display.filters = [];
				}});
			}});
			TweenLite.to(end_display, 0.1, {alpha:0, blurFilter:{blurX:50}});
		}
		
		static public function FADE(start_display:DisplayObject, end_display:DisplayObject, time:Number = 0.5):void
		{
			end_display.alpha = 0;
			TweenLite.to(start_display, time, {alpha:0, onComplete:function():void {
				start_display.parent.removeChild(start_display);
				TweenLite.to(end_display, time, {alpha:1});
			}});
		}
		
		static public function ZOOM_FADE_3D(start_display:DisplayObject, end_display:DisplayObject, time:Number = 2, direction:String = RIGHT):void
		{
			
		}
		
		static public function BLOOP_IN(target:DisplayObject, time:Number = 1):void
		{
			var target_parent:DisplayObjectContainer = target.parent;
			var originalTargetX:Number = target.x;
			var originalTargetY:Number = target.y;
			
			//Setup Container and move it, then add it to the target's parent at the same spot.
			var container:Sprite = new Sprite();
			container.x = target.x +target.width/2;
			container.y = target.y +target.height/2;
			target_parent.addChild(container);
			
			//Remove current target from it's parent
			target_parent.removeChild(target);
			
			//add the target to the container, it should now be back where it was 
			target.x = -target.width/2;
			target.y = -target.height/2;
			container.addChild(target);
			
			//Restore..
			container.scaleX = container.scaleY = .1;
			TweenLite.to(container, time, {scaleX:1, scaleY:1, ease:Elastic.easeOut, onComplete:function():void
				{
					container.removeChild(target);	
					target_parent.removeChild(container);
					target.x = originalTargetX;
					target.y = originalTargetY;
					target_parent.addChild(target);
					
				}
			});
			
			
			
		}
	}
}