package com.isartdigital.utils.extensions;
import haxe.ds.Vector;

/**
 * ...
 * @author Chadi Husser
 */
class VectorExtender
{
	public static function shuffle<T>(pArray:Vector<T>) : Void{
		ArrayExtender.shuffle(cast pArray);
	}
}