package com.isartdigital.sokoban.game;
import animateAtlasPlayer.core.Animation;
import com.isartdigital.sokoban.game.sprites.movingobject.Player;
import openfl.geom.Point;

/**
 * ...
 * @author Jean VIDREQUIN
 */
class PathFinding 
{
	public static var end : Point;
	public static var listAllPoint : Array<ChainPoint>;
	public static var direction:Point;
	
	public static function pathFinding (pStart : Point, pEnd : Point) : Array<Point>
	{
		
		listAllPoint = [{coord : pStart, previous : null}];
		end = pEnd;
		var lIndex : Int = 0;
		var lObjectivePoint : ChainPoint;
		while (lIndex < listAllPoint.length) 
		{
			lObjectivePoint = lookAround(listAllPoint[lIndex++]);
			if (lObjectivePoint != null) return constructWay(lObjectivePoint);	
		}
		
		return null;
	}
	
	private static function  lookAround(pPos : ChainPoint) : ChainPoint 
	{
		var lList : Array<Point> = [
			new Point(pPos.coord.x - 1, pPos.coord.y),
			new Point(pPos.coord.x + 1, pPos.coord.y),
			new Point(pPos.coord.x , pPos.coord.y -1),
			new Point(pPos.coord.x , pPos.coord.y +1)
		];
		
		var lUp:Point = new Point (0, -1);
		var lDown:Point = new Point (0, 1);
		var lLeft:Point = new Point ( -1, 0);
		var lRight:Point = new Point (1, 0);
		
		for (lPoint in lList) 
		{
			var lTested : Bool = false;
			for (i in listAllPoint) 
			{
				if (lPoint.equals(i.coord))
				{
					lTested = true;
					break;
				}
			}
			if (lTested) continue;
			if (lPoint.x == pPos.coord.x - 1) {
				direction = lLeft;
			}
			if (lPoint.x == pPos.coord.x + 1) {
				direction = lRight;
			}
			if (lPoint.y == pPos.coord.y - 1) {
				direction = lUp;
			}
			if (lPoint.y == pPos.coord.y + 1) {
				direction = lDown;
			}
			//trace (direction);
			if (!Player.getInstance().unableToMoveObject(lPoint,direction)) continue;
			if (lPoint.equals(end)) return {coord : lPoint, previous : pPos};
			listAllPoint.push({coord : lPoint, previous : pPos});
			
		}
		return null;
	}
	
	private static function constructWay (pEnd : ChainPoint) : Array<Point>
	{
		var lCurrent : ChainPoint = pEnd;
		var lWay : Array<Point> = [lCurrent.coord];
		while (lCurrent.previous != null) 
		{
			lCurrent = lCurrent.previous;
			lWay.unshift(lCurrent.coord);
			
		}
		return lWay;
	}
	
}