﻿package mirrorbanners.fx.dust {	import mirrorbanners.fx.dust.Speck;		public class SpeckPool	{		private var _arrayLength		:int;		private var _callback			:Function;		private var _pool				:Array = new Array();		private var _currentIndex		:int = 0;						public function SpeckPool( $count:int = 300, $callback:Function = null )		{			_arrayLength = $count;			for (var i:int = 0; i < _arrayLength; ++ i )			{				_pool.push( new Speck() );			}			if ( $callback != null )				$callback();		}				public function getNext():Speck		{			//trace( "current index is " + _currentIndex );			++_currentIndex;			_currentIndex = _currentIndex < _arrayLength ? _currentIndex : 0;			return _pool[ _currentIndex ];					}			}}