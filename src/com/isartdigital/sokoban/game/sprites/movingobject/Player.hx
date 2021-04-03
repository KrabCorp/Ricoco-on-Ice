package com.isartdigital.sokoban.game.sprites.movingobject;

import com.isartdigital.sokoban.controller.KeyboardController;
import com.isartdigital.sokoban.game.hud.UndoRedo;
import com.isartdigital.sokoban.game.level.Blocks;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.game.mvp.ViewManager;
import com.isartdigital.sokoban.game.sprites.iso.IsoPlayer;
import com.isartdigital.sokoban.game.sprites.movingobject.MovingObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.grids.iso.IsoManager;
import openfl.display.Stage;
import openfl.events.MouseEvent;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author DELCENSERIE Kalvin
 */
class Player extends MovingObject
{
	/**
	 * instance unique de la classe Player
	 */
	private static var instance:Player;
	private var wasPressed:Bool = false;
	private var myStage:Stage;

	public static var controller:KeyboardController;
	public static var isMovable:Bool = true;
	public var state:String;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	
	public static var pointArray:Array<Point>;

	public static function getInstance():Player
	{
		if (instance == null) instance = new Player();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	public function new()
	{
		super();

		controller = new KeyboardController();
		type = Blocks.PLAYER;
		cellByCellMovement = true;
		isMovable = true;
		addEventListener(Event.ADDED_TO_STAGE, init);

		setModeNormal();
		setMoveToTile();
	}

	private function init (pEvent:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);
		stopAllMovieClips();
		iso = new IsoPlayer();
		iso.setBehavior(false, false, MovingObject.skin);
		addChild(iso);
		ViewManager.isoContainer.addEventListener(MouseEvent.MOUSE_DOWN, moveOnClick);
	}

	public function move():Void
	{
		if (!wasPressed)
		{
			if (controller.rightDown)
			{
				wasPressed = true;
				safeMove(new Point(1, 0));
				UndoRedo.resetRedoArray();
			}

			if (controller.leftDown)
			{
				wasPressed = true;
				safeMove(new Point( -1, 0));
				UndoRedo.resetRedoArray();
			}

			if (controller.upDown)
			{
				wasPressed = true;
				safeMove(new Point(0, -1));
				UndoRedo.resetRedoArray();
			}

			if (controller.downDown)
			{
				wasPressed = true;
				safeMove(new Point(0, 1));
				UndoRedo.resetRedoArray();
			}
		}

		if (!controller.rightDown && !controller.leftDown && !controller.upDown && !controller.downDown)
		{
			wasPressed = false;
		}
	}
	public function moveOnClick(pEvent:MouseEvent):Void
	{
		var lPos : Point = new Point (x, y);
		var lMousePos : Point = new Point (ViewManager.isoContainer.mouseX, ViewManager.isoContainer.mouseY);
		var lMouseIndex : Point = IsoManager.isoViewToModel(lMousePos);
		var lIndexPlayer : Point = IsoManager.isoViewToModel(lPos);

		PathFinding.listAllPoint = null;
		setMoveToTile();
		if ((lMouseIndex.x == lIndexPlayer.x + 1 && lMouseIndex.y == lIndexPlayer.y)|| (lMouseIndex.x == lIndexPlayer.x - 1 && lMouseIndex.y == lIndexPlayer.y) || (lMouseIndex.x == lIndexPlayer.x && lMouseIndex.y == lIndexPlayer.y + 1) || (lMouseIndex.x == lIndexPlayer.x && lMouseIndex.y == lIndexPlayer.y - 1))
		{
			if (lIndexPlayer.x-1 == lMouseIndex.x)
			{
				safeMove(new Point( -1, 0));
				UndoRedo.resetRedoArray();
				iso.setBehavior(false, false, MovingObject.skin);
			}
			else if (lIndexPlayer.x+1 == lMouseIndex.x)
			{
				safeMove(new Point(1, 0));
				UndoRedo.resetRedoArray();
				iso.setBehavior(false, false, MovingObject.skin);
			}
			else if (lIndexPlayer.y-1 == lMouseIndex.y)
			{
				safeMove(new Point(0, -1));
				UndoRedo.resetRedoArray();
				iso.setBehavior(false, false, MovingObject.skin);
			}
			else if (lIndexPlayer.y+1 == lMouseIndex.y)
			{
				safeMove(new Point(0, 1));
				UndoRedo.resetRedoArray();
				iso.setBehavior(false, false, MovingObject.skin);
			}
		}
		else
		{
			setUnableToMove();
			convertPoint(PathFinding.pathFinding(lIndexPlayer, lMouseIndex));
			for (a in pointArray)
				safeMove(a);
		}
	}

	override public function doActionNormal():Void
	{
		move();
	}

	override public function safeMove(pNextTile:Point, pFromUndo:Bool = false):Void
	{
		super.safeMove(pNextTile, pFromUndo);

		if (pNextTile.x == 1 && pNextTile.y == 0)
		{
			iso.setState("IDLE_RIGHT");
			state = MovingObject.RIGHT;
			iso.setBehavior(false, false, MovingObject.skin);
		}

		if (pNextTile.x == -1 && pNextTile.y == 0)
		{
			iso.setState("IDLE_LEFT");
			state = MovingObject.LEFT;
			iso.setBehavior(false, false, MovingObject.skin);
		}

		if (pNextTile.x == 0 && pNextTile.y == -1)
		{
			iso.setState("IDLE_UP");
			state = MovingObject.UP;
			iso.setBehavior(false, false, MovingObject.skin);
		}

		if (pNextTile.x == 0 && pNextTile.y == 1)
		{
			iso.setState("IDLE_DOWN");
			state = MovingObject.DOWN;
			iso.setBehavior(false, false, MovingObject.skin);
		}
		//counter = 0;
	}

	override public function conditionOfPossibilityToMove(pNextIndex:Point, ?pNextTile:Point):Bool
	{
		if (!super.conditionOfPossibilityToMove(pNextIndex, pNextTile)) return false;

		var lCellOfNextIndex:Array<Blocks> = LevelManager.levelInProgress[Std.int(pNextIndex.y)][Std.int(pNextIndex.x)];

		if (lCellOfNextIndex[0] == Blocks.TARGET) return false;

		var lLength:UInt = lCellOfNextIndex.length;

		if (lLength >= 2)
		{
			var lObject:MovieClip = ViewManager.currentLevel[Std.int(pNextIndex.y)][Std.int(pNextIndex.x)][lLength - 1];

			if (lCellOfNextIndex[lLength - 1] == Blocks.CART && !LevelManager.updateLevelInProgress(lObject, pNextTile/*, index*/))
				return false;
			else if (lCellOfNextIndex[lLength - 1] == Blocks.BOX && !LevelManager.updateLevelInProgress(lObject, pNextTile/*, index*/))
				return false;
		}

		Sound.playRandomSnowSteps();
		return true;
	}

	public static function convertPoint(pArray:Array<Point>):Void
	{
		pointArray = null;
		pointArray = new Array<Point>();
		var lPoint:Point;
		if (pArray == null)
		{
			pointArray.push(new Point (0, 0));
			return;
		}

		for (a in pArray)
		{
			if (pArray.indexOf(a) < pArray.length - 1)
			{
				lPoint = pArray[pArray.indexOf(a) + 1].subtract(a);
				pointArray.push(lPoint);
			}

		}
		trace(pointArray);
	}

	override public function unableToMoveObject(pNextIndex:Point, ?pPoint : Point):Bool
	{
		if (pNextIndex.x < 0 || pNextIndex.x > 8 || pNextIndex.y < 0 || pNextIndex.y > 8) return false;

		var lCellOfNextIndex:Array<Blocks> = LevelManager.levelInProgress[Std.int(pNextIndex.y)][Std.int(pNextIndex.x)];
		var lLength : Int = lCellOfNextIndex.length - 1;

		if (lCellOfNextIndex[lLength] == Blocks.TARGET || lCellOfNextIndex[lLength] == Blocks.CART ||
		lCellOfNextIndex[lLength] == Blocks.BOX || lCellOfNextIndex[lLength] == Blocks.WALL) return false;

		Sound.playRandomSnowSteps();

		return true;
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	public function destroy():Void
	{
		Main.getInstance().stage.removeEventListener(MouseEvent.MOUSE_DOWN, moveOnClick);
		controller.destroy();

		controller	= null;
		instance	= null;
	}

}