package com.isartdigital.utils.extensions;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;

/**
 * ...
 * @author Chadi Husser
 */
class DisplayObjectContainerExtender
{
	
	static public function findChildrenRecursively(pParent:DisplayObjectContainer):Array<DisplayObject> {
		var lChildren:Array<DisplayObject> = new Array<DisplayObject>();
		var lChild:DisplayObject;

		for (i in 0...pParent.numChildren) {
			var lChild = pParent.getChildAt(i);
			lChildren.push(lChild);
			
			if (Std.is(lChild, DisplayObjectContainer)) lChildren = lChildren.concat(findChildrenRecursively(cast(lChild, DisplayObjectContainer)));
		}
		
		return lChildren;
	}

}