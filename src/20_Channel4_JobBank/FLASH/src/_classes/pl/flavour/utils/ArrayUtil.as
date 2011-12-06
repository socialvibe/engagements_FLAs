package pl.flavour.utils {

	public class ArrayUtil {

		public static function shuffle(arr:Array) {
			
			var arr2:Array = [];
			
			while (arr.length > 0) {
			arr2.push(arr.splice(Math.round(Math.random() * (arr.length - 1)), 1)[0]);
			}			
			
			return arr2;
			
		}


	public static function countValues(arr) {
	var z, ix = arr.length, c = false, a = [], d = [];
	while (ix--)
	{
		z = 0;
		while (z < ix)
		{
			if (arr[ix] == arr[z])
			{
				c = true;
				d.push (arr[ix]);
				break;
			}
			z++;
		}
		if (!c) a.push ([arr[ix], 1]);
		else c = false;
	}
	var y = a.length;
	while (y--)
	{
		var q = 0;
		while (q < d.length)
		{
			if (a[y][0] == d[q]) a[y][1]++;
			q++;
		}
	}
	return a;
}


	}

}
