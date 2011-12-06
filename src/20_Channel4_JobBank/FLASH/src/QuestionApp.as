package { 
	
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.text.TextField;
	import com.greensock.*; 
	import com.greensock.easing.*;
	import com.greensock.loading.LoaderMax;
	import org.casalib.util.ArrayUtil;


	public class QuestionApp extends MovieClip {

	
		private var _xmlExternal;
		
		public static var instance:MovieClip;
		
		public function QuestionApp() {
			
			instance = this;
			
			
			TweenMax.from(this, .25, { autoAlpha:0 } );
		
		
			calcQuiz();
			
		}
		
		public function calcQuiz() {
			
			var xmlIndex:Number = 0;
			
			if (Config.xmlLoaded) {
			
			_xmlExternal = LoaderMax.getContent(Config.XML_FILE);
			
			Config.played = _xmlExternal.people.played.text();
			
			}
			
			if (ConfigData.curr >= ConfigData.total) {
				
				MainApp.instance.gotoAndPlay("finish");
				
			} else {
				
				
				var xml = ConfigData.xml;
			
				
			var xml_item = xml.question[ConfigData.idx[ConfigData.curr]];
			
			Config.currentCorrect = Number(xml_item.@correct);
			
			mytf_quest.text = xml_item.desc.text();
			
			button1.mytf.text = xml_item.answer[0].text();
			button2.mytf.text = xml_item.answer[1].text();
			button3.mytf.text = xml_item.answer[2].text();
			
			/*
			button2.mytf.text = tournament.quiz.question[quest_random].answer[1].text();
			button3.mytf.text = tournament.quiz.question[quest_random].answer[2].text();
			*/
				
				
			}
			
			ConfigData.curr++;
			
			
			/*
			var tournament = ConfigData.xml;
			
			var quest_num = tournament.quiz.question.length();
			
			var quest_random = Math.floor(Math.random() * quest_num);
			
			
			*/
			
		}
		
	}
	
	
}