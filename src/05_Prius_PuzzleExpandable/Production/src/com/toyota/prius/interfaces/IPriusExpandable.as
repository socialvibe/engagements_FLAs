package com.toyota.prius.interfaces 
{
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author ...
	 */
	public interface IPriusExpandable 
	{
		function cubePlayOutro():void;
		function cubeStop():void;
		function get solved():Signal;
		function get replay():Signal;
		function get clickthru():Signal;
		function get puzzleState():String;
	}
}