package com.isartdigital.utils.extensions;

/**
 * ...
 * @author Chadi Husser
 */
class ArrayExtender
{

	public static function shuffle<T>(pArray:Array<T>) : Void{
		var n:Int = pArray.length;
		var r:Int;
		var t:T;
		
        for (i in 0...(n-1))
        {
            r = i + Math.floor(Math.random() * (n - i));
            t = pArray[r];
            pArray[r] = pArray[i];
            pArray[i] = t;
        }
	}
}