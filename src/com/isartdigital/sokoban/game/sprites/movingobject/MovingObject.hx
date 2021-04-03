package com.isartdigital.sokoban.game.sprites.movingobject;

import com.isartdigital.sokoban.game.level.Blocks;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.game.mvp.ViewManager;
import com.isartdigital.sokoban.game.sprites.iso.Iso;
import com.isartdigital.utils.game.grids.iso.IsoManager;
import motion.Actuate;
import openfl.display.MovieClip;
import openfl.geom.Point;

/**
 * ...
 * @author AnaelleMncs
 */
class MovingObject extends MovieClip
{
	public static inline var LEFT:String	= "left";
	public static inline var RIGHT:String	= "right";
	public static inline var UP:String		= "up";
	public static inline var DOWN:String	= "down";
	public var counter:Int = 0;
	public var iso:Iso;
	public var doAction:Void->Void;
	public var finishLerp:Bool = false;
	public var type:Blocks;
	public var cellByCellMovement:Bool;
	public var radar:MovieClip;
	public var checkConditions : Point->Point->Bool;
	public static var skin:Int;
	public var nextTile1:Point;
	public var index:Point;

	public function new()
	{
		super();

		trace (index);
	}

	/**
	*
	* @param pNextIndex: prochain index potentiel
	* @param pNextTile: utile pour le undo/redo
	* @return true si le déplacement en pNextIndex est POSSIBLE. false, si c'est impossible
	*/

	public function conditionOfPossibilityToMove(pNextIndex:Point, ?pNextTile:Point):Bool
	{
		if (pNextIndex.x < 0 || pNextIndex.x > 8 || pNextIndex.y < 0 || pNextIndex.y > 8) return false;
		return LevelManager.currentLevel[Std.int(pNextIndex.y)][Std.int(pNextIndex.x)][1] != Blocks.WALL;
	}

	public function setMoveToTile ()  : Void
	{
		checkConditions = conditionOfPossibilityToMove;
	}

	public function setUnableToMove ()  : Void
	{
		checkConditions = unableToMoveObject;
	}

	public function unableToMoveObject(pNextIndex:Point, ?pPoint : Point):Bool
	{
		return false;
	}

	public function safeMove(pNextTile:Point, pFromUndo:Bool = false):Void
	{
		LevelManager.updateLevelInProgress(this, pNextTile, pFromUndo);
	}

	public function updatePositionOnRadarView(pNewIndex:Point, pInitialIndex:Point):Void
	{
		ViewManager.updateRadarView(this, pNewIndex, pInitialIndex);
	}
	
	public function setModeNormal():Void
	{
		doAction = doActionNormal;
	}
	


	public function doActionNormal():Void
	{

	}

}