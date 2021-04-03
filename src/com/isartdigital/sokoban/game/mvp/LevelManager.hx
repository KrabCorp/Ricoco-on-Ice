package com.isartdigital.sokoban.game.mvp;
import com.isartdigital.sokoban.game.hud.UndoRedo;
import com.isartdigital.sokoban.game.level.Blocks;
import com.isartdigital.sokoban.game.level.Level;
import com.isartdigital.sokoban.game.sprites.movingobject.MovingObject;
import com.isartdigital.sokoban.game.sprites.movingobject.Player;
import com.isartdigital.utils.game.grids.CellDef;
import com.isartdigital.utils.game.grids.iso.IsoManager;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import motion.Actuate;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.geom.Point;
import com.isartdigital.sokoban.ui.Hud;
import com.isartdigital.sokoban.game.sprites.movingobject.Box;
import com.isartdigital.sokoban.game.sprites.Target;

/**
 * ...
 * @author DELCENSERIE Kalvin
 */

class LevelManager
{

	public static var currentLevel(default, null):Array<Array<Array<Blocks>>>;
	public static var allLevels(default, null):Array<Array<Array<Array<Blocks>>>>;
	public static var levelInProgress(default, null):Array<Array<Array<Blocks>>>;
	public static var positions(default, null):Array<CellDef>;

	public static var levelDesign:Array<Level>;
	public static var score:UInt = 0;
	static public var counter2:Int = 0;
	private static var counter:UInt = 0;

	public function new() { }

	public static function init():Void
	{
		var levelData:String = GameLoader.getText("assets/levels/leveldesign.json");
		var levelObject:Dynamic = Json.parse(levelData);
		levelDesign = Reflect.field(levelObject, "levelDesign");
		IsoManager.init(256, 128);
		resetLevel();
	}

	public static function resetLevel():Void
	{
		currentLevel = new Array<Array<Array<Blocks>>>();
		levelInProgress = new Array<Array<Array<Blocks>>>();
		allLevels = new Array<Array<Array<Array<Blocks>>>>();
		positions = new Array<CellDef>();

		for (level in levelDesign)
		{
			for (row in level.map)
			{
				currentLevel.push(new Array<Array<Blocks>>());

				for (char in row.split(""))
				{
					switch char
				{

					case " ": currentLevel[currentLevel.length - 1].push([Blocks.GROUND]);
						case "#": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.PLAYER]);
						case ".": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.BOX]);
						case "$": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.WALL]);
						case "@": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.RAILVERTICAL]);
						case "&": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.RAILHORIZONTAL]);
						case "a": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILTOPLEFT]);
						case "z": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILTOPRIGHT]);
						case "e": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILBOTTOMLEFT]);
						case "r": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILBOTTOMRIGHT]);
						case "t": currentLevel[currentLevel.length - 1].push([Blocks.TARGET]);
						case "y": currentLevel[currentLevel.length - 1].push([Blocks.CART]);
						case "u": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.RAILVERTICAL, Blocks.CART]);
						case "i": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.RAILHORIZONTAL, Blocks.CART]);
						case "o": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILTOPLEFT, Blocks.CART]);
						case "p": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILTOPRIGHT, Blocks.CART]);
						case "q": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILBOTTOMLEFT, Blocks.CART]);
						case "s": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILBOTTOMRIGHT, Blocks.CART]);
						case "d": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.RAILVERTICAL, Blocks.PLAYER]);
						case "f": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.RAILHORIZONTAL, Blocks.PLAYER]);
						case "g": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILTOPLEFT, Blocks.PLAYER]);
						case "h": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILTOPRIGHT, Blocks.PLAYER]);
						case "j": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILBOTTOMLEFT, Blocks.PLAYER]);
						case "k": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILBOTTOMRIGHT, Blocks.PLAYER]);
						case "l": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.RAILVERTICAL, Blocks.BOX]);
						case "m": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.RAILHORIZONTAL, Blocks.BOX]);
						case "w": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILTOPLEFT, Blocks.BOX]);
						case "x": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILTOPRIGHT, Blocks.BOX]);
						case "c": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILBOTTOMLEFT, Blocks.BOX]);
						case "v": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TURNINGRAILBOTTOMRIGHT, Blocks.BOX]);
						case "n": currentLevel[currentLevel.length - 1].push([Blocks.GROUND, Blocks.TRIPLERAIL]);
					}
				}
			}

			allLevels.push(currentLevel);
			currentLevel = new Array<Array<Array<Blocks>>>();
		}
	}

	public static function updateCurrentLevel(pIndex:UInt):Void
	{
		currentLevel = allLevels[pIndex];
		levelInProgress = currentLevel;
	}

	/**
	 *
	 * @param	pObject, objet qui effectue un déplacement
	 * @param	pNextTile, indique la direction du déplacement
	 * @param	pFromUndo, indique si le déplacement provient d'un Undo ou non
	 * @return	false si le mouvement de pObject indiqué par pDirection ne peut pas se réaliser
	 */
	public static function updateLevelInProgress(pObject:MovieClip, pNextTile:Point, pFromUndo:Bool = false):Bool
	{
		var lIndex:Point		= IsoManager.isoViewToModel(new Point(pObject.x, pObject.y));
		var lIsoIndex:Point = IsoManager.isoViewToModel(new Point(cast(pObject, MovingObject).iso.x, cast(pObject, MovingObject).iso.y));
		var lIndexCopy:Point	= new Point(lIndex.x, lIndex.y);
		var lIndexBlocks:Int	= levelInProgress[Std.int(lIndex.y)][Std.int(lIndex.x)].length;
		var lObject:Array<Blocks> = new Array<Blocks>();

		//On récupère l'enum correspondant à l'objet dans le levelInProgress
		for (i in 0...lIndexBlocks)
		{
			if (cast(pObject, MovingObject).type == levelInProgress[Std.int(lIndex.y)][Std.int(lIndex.x)][i])
			{
				lObject = levelInProgress[Std.int(lIndex.y)][Std.int(lIndex.x)].splice(i, 1);
				positions.push({gridX : cast(lIndex.x, UInt), gridY : cast(lIndex.y, UInt)});
				break;
			}
		}

		var lLenghtX:Int = levelInProgress[Std.int(lIndex.x)].length;
		var lLenghtY:Int = levelInProgress[Std.int(lIndex.y)].length;

		//On calcule le nouvel index de pObject en fonction de pNextTile
		//

		if (lIndex.x + pNextTile.x  > -1 && lIndex.x + pNextTile.x < lLenghtX && lIndex.y + pNextTile.y  > -1 && lIndex.y + pNextTile.y < lLenghtY)
		{
			lIndex.setTo(lIndex.x + pNextTile.x, lIndex.y + pNextTile.y);

		}
		else
		{
			levelInProgress[Std.int(lIndexCopy.y)][Std.int(lIndexCopy.x)].push(lObject[0]);
			return false;
		}

		testMovementBox(pObject, pFromUndo);
		//Si le déplacement est impossible, on remet l'enum correspondant à l'objet à son index de base et on return false
		if (!cast(pObject, MovingObject).checkConditions(lIndex, pNextTile))
		{
			levelInProgress[Std.int(lIndexCopy.y)][Std.int(lIndexCopy.x)].push(lObject[0]);
			return false;
		}
		//
		//Si le déplacement est possible, on ajoute l'enum correspondant à l'objet au nouvel index calculé précédement
		levelInProgress[Std.int(lIndex.y)][Std.int(lIndex.x)].push(lObject[0]);

		if (!pFromUndo && cast(pObject, MovingObject).type == Blocks.BOX)
		{
			if (counter == 0 && cast(pObject, Box).isInContinuousMovement)
			{
				counter++;
				UndoRedo.addAction({object : cast(pObject, MovingObject), movement : pNextTile});
			}
		}
		if (!pFromUndo && cast(pObject, MovingObject).type != Blocks.BOX)
		{
			UndoRedo.addAction({object : cast(pObject, MovingObject), movement : pNextTile});
		}

		if (pObject == Player.getInstance())
		{
			score++;
			Hud.getInstance().updateScore(score);
			Hud.getInstance().updateStars(pFromUndo);
		}

		//On update graphiquement les nouvelles positions
		cast(pObject, MovingObject).updatePositionOnRadarView(lIndex, lIndexCopy);
		ViewManager.updateIsoView(pObject, lIndex,true);

		//counter2 = 0;
		//On vérifie s'il y a un complétion d'objectif
		if (cast(pObject, MovingObject).type == Blocks.BOX) completeTarget(pObject, lIndex);

		return true;
	}

	public static function checkNextBlock(pObject:MovieClip, pNextTile:Point, pFromUndo:Bool = false):Bool
	{
		var lIndex:Point		= IsoManager.isoViewToModel(new Point(pObject.x, pObject.y));
		var lIndexCopy:Point	= new Point(lIndex.x, lIndex.y);
		var lObject:Array<Blocks> = new Array<Blocks>();

		if (!cast(pObject, MovingObject).conditionOfPossibilityToMove(lIndex, pNextTile))
		{
			levelInProgress[Std.int(lIndexCopy.y)][Std.int(lIndexCopy.x)].push(lObject[0]);
			return false;
		}
		//
		//Si le déplacement est possible, on ajoute l'enum correspondant à l'objet au nouvel index calculé précédement
		levelInProgress[Std.int(lIndex.y)][Std.int(lIndex.x)].push(lObject[0]);

		if (pFromUndo == false) UndoRedo.addAction({object : cast(pObject, MovingObject), movement : pNextTile});

		if (pObject == Player.getInstance())
		{
			score++;
			Hud.getInstance().updateScore(score);
			Hud.getInstance().updateStars(pFromUndo);
		}

		//On update graphiquement les nouvelles positions
		cast(pObject, MovingObject).updatePositionOnRadarView(lIndex, lIndexCopy);
		ViewManager.updateIsoView(pObject, lIndex, true);
				ViewManager.updateIsoView(pObject, lIndex, true);


		//On vérifie s'il y a un complétion d'objectif
		if (cast(pObject, MovingObject).type == Blocks.BOX) completeTarget(pObject, lIndex);
		return true;
	}
	public static function testMovementBox(pObject:MovieClip, pFromUndo:Bool):Void
	{
		if (cast(pObject, MovingObject).type == Blocks.BOX && !pFromUndo)
		{
			if (!cast(pObject, Box).isInContinuousMovement) counter = 0;
		}
	}

	public static function completeTarget(pObject:MovieClip, pIndex:Point):Void
	{
		var lCell:Array<Blocks> = levelInProgress[Std.int(pIndex.y)][Std.int(pIndex.x)];

		if (!(lCell[0] == Blocks.TARGET && lCell[1] == Blocks.BOX)) return;

		cast(pObject, Box).isInContinuousMovement = false;
		cast(pObject, Box).removeBoxAt();
		cast(ViewManager.currentLevel[Std.int(pIndex.y)][Std.int(pIndex.x)][0], Target).removeGoalAt();

		levelInProgress[Std.int(pIndex.y)][Std.int(pIndex.x)] = [Blocks.GROUND];

		var lFloor:Floor = new Floor();

		ViewManager.completeTarget(lFloor, pIndex);
		ViewManager.updateIsoView(lFloor, pIndex, true);

	}

}