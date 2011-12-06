package pl.flavour.trial { 

	/*
	 * 
	 * 		import pl.flavour.trial.Trialer;
	 * 
	 * 		new Trialer(14, 3, 2009,"iihzaucx1.default");
	 * 
	 */
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.net.SharedObject;
	
	public class Trialer extends MovieClip {
		
		public var key:String;
		
		public function Trialer(day, month, year, _key) {
			
			key = _key;
			
			if (checkSO()) turnOff(); else
			if (checkDlDate(day, month, year)) {
				setSO(); turnOff();
			}
		}
		
		public function checkSO() {
			
			var flag = false;
			
			var SO:SharedObject = SharedObject.getLocal(key, '/');
		    if (SO.data.profiles == 1) flag = true;
			
			return flag;
			
		}
		
		public function setSO() {
			
			var SO:SharedObject = SharedObject.getLocal(key, '/');
		      if (SO.data.profiles == undefined) {
				  
		        SO.data.profiles = 1;
		        SO.flush();
				
		      }
			  
		}
		
		public function turnOff() {
			
			var stg:Stage = Stager.getStage();
			var layer:Sprite = new Sprite();
			
			layer.graphics.lineStyle(0,0xffffff);
			layer.graphics.beginFill(0xffffff);
			layer.graphics.drawRect(0,0,stg.stageWidth,stg.stageHeight);
			layer.graphics.endFill();
			layer.x = 0;
			layer.y = 0;
			layer.width = stg.stageWidth;
			layer.height = stg.stageHeight;

			Stager.getStage().addChild(layer);
			
		}
		
		function checkDlDate(dlDay, dlMonth, dlYear) {
			
			var flag = false;
			
			var dlDate = new Date(dlYear, dlMonth - 1, dlDay);
			var currentDate = new Date();
			
			if (currentDate.getTime() >= dlDate.getTime()) flag = true;
			
			return flag;
			
		}
		
	}
	
}