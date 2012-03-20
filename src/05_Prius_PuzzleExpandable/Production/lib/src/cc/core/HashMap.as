package cc.core
{
	
	import cc.utils.StringUtils;
	
	/**
  	 * Hash Map 
	 * Core component of the cc framework
	 * 
	 * @langversion ActionScript 3
	 * @playerversion Flash 10.0.0
	 * 
	 * @author Carl Calderon (carl.calderon@gmail.com)
	 * @since  14.01.2011
	 */
	public class HashMap
	{
		
		/**
		 * Key holder
		 */
		private var keys	:Vector.<String>;
		
		/**
		 * Value holder
		 */
		private var values	:Array;
	
////////////////////////////////////////////////////////
//
//	Constructor
//
////////////////////////////////////////////////////////
	
		/**
		 * @constructor
		 * Creates a new HashMap object
		 * 
		 * HashMaps are design to be used as traditional AS objects
		 * but more alike the PHP key array prototype. The HashMap
		 * has a length and may contain any value. Every value has
		 * an identifier called a 'key'. The key may be used to
		 * trace down the value connected.
		 * 
		 * @see #add()
		 * @see #get()
		 */
		public function HashMap()
		{
			super();
			keys 	= new Vector.<String>();
			values 	= [];
		}
		
////////////////////////////////////////////////////////
//
//	Public Methods
//
////////////////////////////////////////////////////////

		/**
		 *	Adds an item to the map
		 * 
		 * 	@param key String	Key name (item name)
		 *	@param value *		Key value (item value)
		 *	@return Boolean		Success
		 */
		public function add(key:String,value:*):Boolean
		{
			if(has(key)) return false;
			keys.push(key);
			values.push(value);
			return true;
		}
		
		/**
		 *	Adds an item to a spcific index in the map
		 * 
		 * 	@param key String	Key name (item name)
		 *	@param value *		Key value (item value)
		 *	@param index int	Map index
		 *	@return Boolean		Success
		 */
		public function addAt(key:String,value:*,index:int):Boolean
		{
			if(has(key)) return false;
			try
			{
				keys.splice(index,0,key);
				values.splice(index,0,value);
			}
			catch(e:Error)
			{
				return false;
			}
			return true;
		}
		
		/**
		 *	Retrieves the value that match the provieded key.
		 * 
		 *	@return Key Value
		 */
		public function get(key:String):*
		{
			return values[keys.indexOf(key)] || null;
		}
		
		/**
		 *	Retrievs a value defined by the map index
		 * 
		 *	@return Index Value
		 */
		public function getAt(index:int):*
		{
			return values[index] || null;
		}
		
		/**
		 *	Retrieves both the Key and the Value at the 
		 * 	provided index.
		 * 
		 * 	@param index int	Map index
		 *	@return Object		Hash {key,value}
		 */
		public function getHashAt(index:int):Object
		{
			return {key:keys[index],value:values[index]};
		}
		
		/**
		 *	Check is the provided key exists or not
		 * 
		 * 	@param key String	Key name
		 *	@return Boolean		Existance
		 */
		public function has(key:String):Boolean
		{
			return (keys.indexOf(key) > -1);
		}
		
		/**
		 *	@copy #has()
		 */
		public function exist(key:String):Boolean
		{
			return has(key);
		}
		
		/**
		 *	Returns the index of the specified key or value.
		 * 	Keys are prioritized.
		 * 
		 *  @see #indexOfKey()
		 *  @see #indexOfValue()
		 * 	@param keyOrValue *
		 *	@return int
		 */
		public function indexOf(keyOrValue:*):int
		{
			var idx:int = -1;
			if(keyOrValue is String)
			// prioritize keys
			{
				idx = indexOfKey(keyOrValue);
			}
			if(idx == -1)
			// no key found, proceed with values
			{
				idx = indexOfValue(keyOrValue);
			}
			return idx;
		}
		
		/**
		 *	Returns the index of the specified key
		 * 
		 * 	@param key String
		 *	@return int
		 */
		public function indexOfKey(key:String):int
		{
			return keys.indexOf(key);
		}
		
		/**
		 *	Returns the index of the specified value
		 * 
		 * 	@param value *
		 *	@return int
		 */
		public function indexOfValue(value:*):int
		{
			return values.indexOf(value);
		}
		
		/**
		 *	Removed the provided key and it's value.
		 * 
		 * 	@param key String
		 *  @return Success
		 */
		public function remove(key:String):Boolean
		{
			if(!exist(key)) return false;
			var idx:int = keys.indexOf(key);
			removeAt(idx);
			return true;
		}
		
		/**
		 *	Removed the key and value at the provided index.
		 * 
		 * 	@param index int
		 *  @return Success
		 */
		public function removeAt(index:int):Boolean
		{
			if(length>0 && index < length && index > -1)
			{
				keys.splice(index,1)
				values.splice(index,1);
				return true;
			}
			return false;
		}
		
		/**
		 *	Returns a clone of the current HashMap
		 * 
		 *	@return HashMap Clone
		 */
		public function clone():HashMap
		{
			var map:HashMap = new HashMap();
			for (var i:int = 0; i < length; i++)
				map.add(keys[i],values[i]);
			return map;
		}
		
		/**
		 * 	Checks if the values in the HashMap
		 *	are alike based on AS3's 'typeof'.
		 * 	Note that most classes share the 'object'
		 * 	typeof. This might cause different classes
		 * 	in the HashMap return this method as true.
		 * 	Use with care. An empty HashMap is 
		 * 	considered as consistent.
		 * 
		 * 	@return Boolean	Consistency
		 */
		public function consistent():Boolean
		{
			if(length>0)
			{
				var c:* = typeof values[0];
				for (var i:int = 1; i < length; i++)
					if(c != typeof values[i])
						return false;
			}
			return true;
		}
		
		/**
		 *	Removes duplicates of the specified value or
		 * 	all duplicates.
		 * 	Clears all but the first reference.
		 * 
		 * 	@param value *	Value
		 *	@return int		Number of removed keys or duplicated keys
		 */
		public function removeDuplicates(value:*=null):int
		{
			var count:int = 0;
			if(value)
			{
				var src:int = values.indexOf(value);
				var idx:int = values.indexOf(value,src);
				while(idx > -1)
				{
					count++;
					removeAt(idx);
					idx = values.indexOf(value,src);
				}
			}
			else
			{
				var i:int = -1;
				while(++i<length)
				{
					count++
					removeDuplicates(values[i]);
				}
			}
			return count;
		}
		
		/**
		 *	Reverses the hash order
		 */
		public function reverse():void
		{
			keys.reverse();
			values.reverse();
		}
		
		/**
		 *	Randomizes the Hash Map. Values will
		 * 	switch index but keys remain.
		 */
		public function randomize():void
		{
			var newValues:Array = new Array()
			for (var i:int = 0; i <	length; i++)
			{
				newValues.splice(Math.floor(Math.random()*newValues.length),0,values[i]);
			}
			values = newValues;
		}
		
		/**
		 *	Randomizes the HashMap. Values and
		 * 	keys will remain connected.
		 */
		public function randomizeOrder():void
		{
			
			var newValues:Array = new Array()
			var newKeys:Vector.<String> = new Vector.<String>()
			var idx:int = -1;
			for (var i:int = 0; i < length; i++)
			{
				idx = Math.floor(Math.random()*newKeys.length);
				newValues.splice(idx,0,values[i]);
				newKeys.splice(idx,0,keys[i]);
			}
			values 	= newValues;
			keys 	= newKeys;
		}
		
		/**
		 *	Removes all keys and values in the HashMap.
		 *  Execute prior to System#gc()
		 */
		public function dispose():void
		{
			for (var i:int = 0; i < length; i++)
			{
				keys[i] 	= null;
				values[i] 	= null;
			}
			keys 	= null;
			values 	= null;
		}
		
		/**
		 *	Sorts all keys
		 * 
		 * @param order Use as Array ordering such
		 * 				as Array.DESCENDING
		 */
		public function sort(order:*=null):void
		{
			var org:HashMap = clone();
			keys.sort(order || Array.DESCENDING);
			for (var i:int = 0; i < length; i++)
				values[i] = org.get(keys[i]);
			org.dispose();
			org = null;
		}
		
		/**
		 *	Executes the provided function for each key and 
		 * 	value pair in the HashMap.
		 * 	The function must include the following arguments:
		 * 	key:String, value:*, index:int
		 * 	The function must return a Boolean which tells if the
		 * 	current item in the hash map should stay (true) or be
		 * 	removed (false). Note that the index of the next item
		 * 	might be the same as the one before if the item was
		 * 	removed.
		 * 	Example:
		 * 	function myFunc(key:String,value:*,index:int):Boolean 
		 * 	{ 
		 * 		return true;
		 * 	}
		 *	@param func Function	Executed for every item.
		 */
		public function forEach(func:Function):void
		{
			var hash:Object;
			for (var i:int = 0; i < keys.length; i++)
			{
				hash = getHashAt(i);
				var s:Boolean = func(hash.key, hash.value, i);
				if(!s)
				{
					removeAt(i);
					i--;
				}
			}
		}

////////////////////////////////////////////////////////
//
//	Getter Setters
//
////////////////////////////////////////////////////////

		/**
		 * Map length (num keys)
		 */
		public function get length():int
		{
			return keys.length;
		}
		
		/**
		 *	String representation of the current HashMap
		 */
		public function toString():String
		{
			return StringUtils.formatToString(this,'length');
		}
	
	}

}

