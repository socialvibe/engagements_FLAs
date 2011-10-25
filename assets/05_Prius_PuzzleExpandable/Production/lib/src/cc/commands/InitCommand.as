package cc.commands
{
	import cc.core.Glossary;
	import cc.core.AbstractCommand;
	import cc.proxies.GlossaryProxy;
	
	import flash.events.Event;
	
	public class InitCommand extends AbstractCommand
	{
		
		private var _proxy	:GlossaryProxy;
		
		public function InitCommand()
		{
			super();
		}
		
		override public function execute():void
		{
			_proxy = getProxy('glossary') as GlossaryProxy;
			_proxy.addEventListener(Event.COMPLETE, onGlossayComplete);
			_proxy.load('lang/lang.xml');
		}
		
		private function onGlossayComplete(e:Event):void
		{
			setState('load');
		}
		
		override public function toString():String
		{
			return '[InitCommand]';
		}
		
	}

}