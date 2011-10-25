package cc.utils
{
	
	public class ArrayUtils
	{
		
		/**
		 * Checks if all items in array1 are the same in array2.
		 * Different length of the arrays will result in 'false'.
		 * 
		 * @return Boolean	equality
		 */
		public static function equals(array1:Array,array2:Array):Boolean
		{
			if(array1.length == array2.length)
			{
				return has(array1,array2);
			}
			return false;
		}
		
		/**
		 * Checks if all items in array1 can be found in array2.
		 * Note that array2 may contain more items than array1.
		 * 
		 * @return Boolean	true if all items are found.
		 */
		public static function has(array1:Array,array2:Array):Boolean
		{
			for each (var item:* in array1)
			{
				if(array2.indexOf(item) == -1)
					return false;
			}
			return true;
		}
		
		/**
		 * Checks if the two provided arrays are identical by 
		 * content, ordering and length.
		 * 
		 * @return Boolean	identical or not
		 */
		public static function identical(array1:Array,array2:Array):Boolean
		{
			if(array1.length == array2.length)
			{
				var len:uint = array1.length;
				for (var i:int = 0; i < len; i++)
				{
					if(array1[i] != array2[i])
						return false;
				}
				return true;
			}
			return false;
		}
		
	}

}

