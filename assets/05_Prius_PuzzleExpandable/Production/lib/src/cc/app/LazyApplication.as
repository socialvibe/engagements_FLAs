package cc.app
{
	import cc.commands.*;
	import cc.proxies.*;
	import cc.views.*;
	import cc.core.*;
	
	/**
	 * LazyApplication.
	 * 
	 * Basic Application setup utilizing a Glossary,
	 * 'load' state and a InitCommand.
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class LazyApplication extends AbstractApplication
	{
		
		public function LazyApplication()
		{
			super();
			
			state.add('root','load');
			
			control.add('init', 	new InitCommand());
			
			proxy.add('glossary',	new GlossaryProxy());
			
			view.add(new LoadView());
			
			// init
			control.run('init');
			
		}
		
		override public function toString():String
		{
			return '[LazyApplication]';
		}
		
	}

}

