package com.socialvibe.core.utils
{
	import flash.filters.BlurFilter;	
	import flash.display.MovieClip;
	import flash.utils.getTimer;	
	
	/**
	 * The CPU class benchmarks the clients computer
	 * and provide a number you can use to decide if their cpu
	 * is fast / med / slow, etc.
	 * 
	 * <p>The CPU class does not provide details about how many
	 * CPU's they have, or RAM information.</p>
	 * 
	 * <p>The recommended number ranges for fast / med / slow:</p>
	 * <ul>
	 * <li>fast = (CPU.Speed < 45)</li>
	 * <li>med = (CPU.Speed < 80)</li>
	 * <li>slow = anything greater than the medium benchmark.
	 * </ul>
	 * 
	 * <p>This class is integrated with the base DocumentClass of
	 * the net.guttershark package.</p>
	 * 
	 * @example Benchmarking client CPU:
	 * <listing>	
	 * CPU.calculate();
	 * trace(CPUCalc.Speed);
	 * trace(CPUCalc.Speed == CPUCalc.FAST);
	 * trace(CPUCalc.Speed == CPUCalc.MEDIUM);
	 * trace(CPUCalc.Speed == CPUCalc.SLOW);
	 * trace(CPUCalc.Benchmark);
	 * </listing>
	 * 
	 * @see net.guttershark.control.DocumentController
	 */
	public class CPUCalc
	{
		
		/**
		 * An Identifier for the Speed property of this class.
		 */
		public static const FAST:String = "fast";
		
		/**
		 * An Identifier for the Speed property of this class.
		 */
		public static const MEDIUM:String = "medium";
		
		/**
		 * An Identifier for the Speed property of this class.
		 */
		public static const SLOW:String = "slow";
		
		/**
		 * The actual benchmark number.
		 */
		public static var Benchmark:Number;
		
		/**
		 * The speed identifier. It will be set to one of 
		 * CPUCalc.FAST || CPUCalc.MEDIUM || CPUCalc.SLOW;
		 */
		public static var Speed:String;
		
		/**
		 * Calculate a benchmark time that gives a fairly accurate
		 * number you can use to decide if the client's CPU is
		 * fast / med / slow.
		 * 
		 * @param maxForFast	The maximum benchmark that qualifies the client CPU as FAST.
		 * @param maxForMedium	The maximum benchmark that qualifies the client CPU as MEDIUM.
		 */
		public static function calculate(maxForFast:int = 45, maxForMedium:int = 80):void
		{
			var mc:MovieClip = new MovieClip();
			mc.graphics.beginFill(0xFF0066);
			mc.graphics.drawRect(0, 0, 200, 200);
			mc.graphics.endFill();
			var blurFilter:BlurFilter = new BlurFilter(4,4,1);
			var filters:Array = [];
			var passes:int = 3;
			var t:Number;
			for(var h:int = 0; h < passes; h++)
			{
				t = getTimer();
				for(var i:int = 0; i < ((h+1) * 200); i++)
				{
					filters.push(blurFilter);
					mc.filters = filters;
				}
				Benchmark = (getTimer() - t);
				filters = [];
			}
			if(Benchmark < maxForFast) Speed = CPUCalc.FAST;
			else if(Benchmark < maxForMedium) Speed = CPUCalc.MEDIUM;
			else Speed = CPUCalc.SLOW;
		}
	}
}