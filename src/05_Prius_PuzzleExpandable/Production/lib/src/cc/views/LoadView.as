package cc.views
{
	import cc.core.AbstractView;
	import cc.core.Glossary;
	import cc.events.StateEvent;
	import cc.text.Text;
	
	public class LoadView extends AbstractView
	{
		
		private var _text:Text;
		
		public function LoadView()
		{
			super();
		}
		
		override protected function setup():void
		{
			super.setup();
			
			listen('load',StateEvent.ENTER, onStateEnter);
			listen('load',StateEvent.EXIT, 	onStateExit);
			
			_text = new Text(null,'loading',1);
			addChild(_text);
						
		}
		
		override protected function language():void
		{ 
			_text.text = Glossary.getTerm('load::loading_percent',0,'Still loading...');
		}
		
		override protected function position():void
		{
			_text.x = (stage.stageWidth-_text.width)/2;
			_text.y = (stage.stageHeight-_text.height)/2;
		}
		
		override protected function populate():void
		{
			super.populate();
		}
		
		override protected function desert():void
		{
			super.desert();
		}
		
		override public function toString():String
		{
			return '[LoadView]';
		}
		
	}

}