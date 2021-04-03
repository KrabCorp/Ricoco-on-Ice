package com.isartdigital.sokoban.game.hud;

import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.ui.Hud;
import com.isartdigital.sokoban.game.sprites.movingobject.MovingObject;
import openfl.geom.Point;
import com.isartdigital.sokoban.game.sprites.movingobject.Player;
import com.isartdigital.sokoban.ui.Hud;

/**
 * ...
 * @author DELCENSERIE Kalvin
 */

typedef Actions =
{
	var object:MovingObject;
	var movement:Point;
}

class UndoRedo
{

	private static var undoArray:Array<Array<Actions>>;
	private static var redoArray:Array<Array<Actions>>;

	private function new()
	{

	}

	public static function init():Void
	{
		undoArray = new Array<Array<Actions>>();
		redoArray = new Array<Array<Actions>>();
		addActionContainer();
	}

	private static function addActionContainer():Void
	{
		undoArray.push(new Array<Actions>());
	}

	public static function lengthCheck():Void
	{
		if (undoArray[undoArray.length - 1].length == 0) return;

		addActionContainer();
	}
	private static function reverse(lPoint:Point):Point
	{
		return new Point(lPoint.x * -1, lPoint.y *-1);
	}
	public static function addAction(pAction:Actions):Void
	{
		undoArray[undoArray.length - 1].push(pAction);

	}

	public static function undo():Void
	{
		if (undoArray.length <= 1) return;

		var lArray:Array<Actions> = undoArray[undoArray.length - 2];
		for (action in lArray)
		{
			action.object.safeMove(reverse(action.movement), true);
		}
		
		LevelManager.score -= 2;
		Hud.getInstance().updateScore(LevelManager.score);
		Hud.getInstance().updateStars(true);
		undoArray.remove(lArray);
		redoArray.push(lArray);
	}
	public static function redo():Void
	{
		if (redoArray.length <= 0) return;

		var lArray:Array<Actions> = redoArray[redoArray.length - 1];
		for (action in lArray)
		{
			action.object.safeMove(action.movement);
		}
		redoArray.remove(lArray);
	}

	public static function resetRedoArray():Void
	{
		for (a in redoArray)
		{
			redoArray.remove(a);
		}
	}
}