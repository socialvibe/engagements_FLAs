﻿package  { 	import com.google.analytics.AnalyticsTracker; 	import com.google.analytics.GATracker; 	import flash.display.MovieClip;		public class Config extends MovieClip {		public static var GA_UID:String = "UA-27292767-1";						public static var AMF_GATE:String = "";		public static var XML_FILE:String = "";		public static var CACHE_BUSTER_REVISION_NUM:String = "";				public static var xmlLoaded:Boolean = false;				public static var boxNum:String = "";				public static var finishFlag:String = "";				public static var played:String = "";				public static var currentCorrect:Number = -1;				public static var isTournament:Boolean = false;				public function Config() {						XML_FILE = FlashVars.getFV("xmlFile");			if (!XML_FILE) XML_FILE = "http://edge.channel4.com/BankJobFlashAds/data.xml";						CACHE_BUSTER_REVISION_NUM = FlashVars.getFV("cacheRevisionNum");			if (!CACHE_BUSTER_REVISION_NUM) CACHE_BUSTER_REVISION_NUM = "";					}				// stage width		/*public static function get stageWidth():Number {						//return Stager.getStage().stageWidth;					}				// stage height		public static function get stageHeight():Number {						//return Stager.getStage().stageHeight;					}*/					}	}