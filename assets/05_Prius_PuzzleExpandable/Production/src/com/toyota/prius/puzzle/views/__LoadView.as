package com.toyota.views
{
	
	import cc.events.StateEvent;
	import cc.core.AbstractView;
	import cc.core.Glossary;

	public class LoadView extends AbstractView
	{

		public function LoadView()
		{
			super();
		}
		
		override protected function setup():void
		{
			super.setup();
			
			listen('load',	StateEvent.ENTER,	onStateEnter);
			listen('load',	StateEvent.EXIT, 	onStateExit);
		}
		
		override protected function language():void
		{ 
		
		}
		
		override protected function position():void
		{

		}
		
		override protected function populate():void
		{
			super.populate();
			
			run('load',{async:true,onComplete:onAssetLoadComplete});
			
		}
		
		override protected function desert():void
		{
			super.desert();
		}
		
		private function onAssetLoadComplete():void
		{
			run('goto',{view:'away'});
		}
		
		override protected function onStateEnter(e:StateEvent):void
		{
			super.onStateEnter(e);
		}		
		
		override protected function onStateExit(e:StateEvent):void
		{
			super.onStateExit(e);
		}

	}

}