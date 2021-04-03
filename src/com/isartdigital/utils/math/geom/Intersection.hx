package com.isartdigital.utils.math.geom;
import com.isartdigital.utils.math.geom.Circle;
import openfl.geom.Point;
import openfl.geom.Rectangle;


/**
 * Classe utilitaire permettant de tester diverses collisions entre boites, formes et points
 * @author Chadi Husser
 */
class Intersection 
{
	/**
	   teste la collision cercle rectange
	   @param	pCircle
	   @param	pRectangle
	   @return 
	**/
	public static function circleRectangle(pCircle:Circle, pRectangle:Rectangle):Bool 
	{
		var lCircleDistanceX : Float = Math.abs(pCircle.x - pRectangle.x - pRectangle.width / 2);
		if (lCircleDistanceX > pRectangle.width / 2 + pCircle.radius) return false;
		
		var lCircleDistanceY : Float = Math.abs(pCircle.y - pRectangle.y - pRectangle.height / 2);
		if (lCircleDistanceY > pRectangle.height / 2 + pCircle.radius) return false;
		
		if (lCircleDistanceX <= pRectangle.width / 2) return true;
		if (lCircleDistanceY <= pRectangle.height / 2) return true;
		
		var lDX : Float = lCircleDistanceX - pRectangle.width / 2;
		var lDY : Float = lCircleDistanceY - pRectangle.height / 2;
		
		var lCornerDistanceSquared :Float = lDX * lDX + lDY * lDY;
		return lCornerDistanceSquared <= pCircle.radiusSquared;
	}
	
	/**
	   teste la collision point cerlce
	   @param	pPoint
	   @param	pCircle
	   @param	pRadius
	   @return
	**/
	public static function pointCircle(pPoint:Point, pCircle:Point, pRadius:Float) : Bool {
		return Point.distance(pPoint, pCircle) < pRadius;
	}
	
	/**
	   teste la collision cercle cercle
	   @param	pA
	   @param	pRadiusA
	   @param	pB
	   @param	pRadiusB
	   @return
	**/
	public static function circleCircle(pA:Point, pRadiusA:Float, pB:Point, pRadiusB:Float) : Bool {
		return Point.distance(pA, pB) <= (pRadiusA + pRadiusB);
	}
	
	/**
	   teste la collision cercle segment
	   @param	pCircle
	   @param	pRadius
	   @param	pA
	   @param	pB
	   @return
	**/
	public static function circleSegment(pCircle:Point, pRadius:Float, pA:Point, pB:Point) : Bool {			
		var AB : Point = new Point(pB.x - pA.x, pB.y - pA.y);
		var AC : Point = new Point(pCircle.x - pA.x, pCircle.y - pA.y);
		
		var numerator : Float = Math.abs(AB.x * AC.y - AB.y * AC.x);
		var denominator : Float = Math.sqrt(AB.x * AB.x + AB.y * AB.y);
		var distanceCI = numerator / denominator;

		if (distanceCI > pRadius) return false;
		
		var CB : Point = new Point(pB.x - pCircle.x, pB.y - pCircle.y);
		
		if (Vector2.dotProduct(AB, AC) >= 0 && Vector2.dotProduct(AB, CB) >= 0) return true;
		return pointCircle(pA, pCircle, pRadius) || pointCircle(pB, pCircle, pRadius);
	}
}