package com.isartdigital.sokoban.game.sprites.movingobject;
import com.isartdigital.sokoban.game.level.Blocks;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.game.mvp.ViewManager;
import com.isartdigital.sokoban.game.sprites.iso.IsoBox;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.grids.iso.IsoManager;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author AnaelleMncs
 */
class Box extends MovingObject
{
	public static var list:Array<Box> = new Array<Box>();

	public static var nextTile:Point;
	public var isInContinuousMovement:Bool;

	public function new()
	{
		super();

		if (list == null) list = new Array<Box>();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init (pEvent:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		list.push(this);
		iso = new IsoBox();
		type = Blocks.BOX;
		addChild(iso);
		isInContinuousMovement = false;
		setModeNormal();
		setMoveToTile();
	}

	override public function conditionOfPossibilityToMove(pNextIndex:Point, ?pNextTile:Point):Bool
	{
		if (!super.conditionOfPossibilityToMove(pNextIndex, pNextTile)) return false;

		var lCellOfNextIndex:Array<Blocks> = LevelManager.levelInProgress[Std.int(pNextIndex.y)][Std.int(pNextIndex.x)];
		var lLength:UInt = lCellOfNextIndex.length;

		if (lLength >= 2)
		{
			if (lCellOfNextIndex[lLength - 1] == Blocks.BOX || lCellOfNextIndex[lLength - 1] == Blocks.CART || lCellOfNextIndex[lLength - 1] == Blocks.PLAYER)
				return false;
		}
		
		nextTile = pNextTile;
		isInContinuousMovement = true;
		addEventListener(Event.ENTER_FRAME, gameLoop);
		
		return true;
	}

	override public function doActionNormal():Void 
	{
		if (!isInContinuousMovement)
		{
			removeEventListener(Event.ENTER_FRAME, gameLoop);
			return;
		}
		
		if (!LevelManager.updateLevelInProgress(this, nextTile, false)) isInContinuousMovement = false;
		
	}
	
	public function gameLoop(pEvent:Event):Void
	{
		doAction();
	}

	public function removeBoxAt():Void
	{
		list.splice(list.indexOf(this), 1);
		radar.parent.removeChild(radar);
		parent.removeChild(this);
	}
	
	public static function destroy():Void
	{
		list = null;
	}
}