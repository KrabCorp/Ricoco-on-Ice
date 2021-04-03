package com.isartdigital.sokoban.game.sprites.movingobject;
import com.isartdigital.sokoban.game.level.Blocks;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.game.mvp.ViewManager;
import com.isartdigital.sokoban.game.sprites.iso.IsoCart;
import com.isartdigital.utils.game.GameStage;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * ...
 * @author AnaelleMncs
 */

class Cart extends MovingObject
{
	public static var list:Array<Cart> = new Array<Cart>();

	public function new() 
	{
		super();

		if (list == null) list = new Array<Cart>();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}

	private function init (pEvent:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		list.push(this);
		iso = new IsoCart();
		type = Blocks.CART;
		addChild(iso);
		setMoveToTile();
	}

	override public function conditionOfPossibilityToMove(pNextIndex:Point, ?pNextTile:Point):Bool
	{
		if (!super.conditionOfPossibilityToMove(pNextIndex)) return false;

		var lLength:UInt = LevelManager.levelInProgress[Std.int(pNextIndex.y)][Std.int(pNextIndex.x)].length;

		//Si la length de la cellule est inférieure à 2, elle ne peut pas contenir de rails, 
		//et si la length est supérieure ou égal à 3, il y a un objet qui bloque le déplacement, donc return false
		if (lLength < 2) return false;

		var lBlock:Blocks = LevelManager.currentLevel[Std.int(pNextIndex.y)][Std.int(pNextIndex.x)][1];
		var lBlock2:Blocks = LevelManager.currentLevel[Std.int(pNextIndex.y)][Std.int(pNextIndex.x)][2];
		if (pNextTile.x == -1 && pNextTile.y == 0) 
		{
			if (lBlock2 == Blocks.BOX || lBlock2 == Blocks.CART) return false;
			if (lBlock != Blocks.RAILHORIZONTAL
			&& lBlock != Blocks.TURNINGRAILBOTTOMRIGHT
			&& lBlock != Blocks.TURNINGRAILTOPRIGHT
			&& lBlock != Blocks.TRIPLERAIL)
				return false;
		}

		if (pNextTile.x == 1 && pNextTile.y == 0)
		{
			if (lBlock2 == Blocks.BOX || lBlock2 == Blocks.CART) return false;
			if (lBlock != Blocks.RAILHORIZONTAL
			&& lBlock != Blocks.TURNINGRAILBOTTOMLEFT
			&& lBlock != Blocks.TURNINGRAILTOPLEFT
			&& lBlock != Blocks.TRIPLERAIL)
				return false;
		}

		if (pNextTile.x == 0 && pNextTile.y == -1)
		{
			if (lBlock2 == Blocks.BOX || lBlock2 == Blocks.CART) return false;
			if (lBlock != Blocks.RAILVERTICAL
			&& lBlock != Blocks.TURNINGRAILTOPLEFT
			&& lBlock != Blocks.TURNINGRAILTOPRIGHT
			&& lBlock != Blocks.TRIPLERAIL)
				return false;	
		}

		if (pNextTile.x == 0 && pNextTile.y == 1)
		{
			if (lBlock2 == Blocks.BOX || lBlock2 == Blocks.CART) return false;
			if (lBlock != Blocks.RAILVERTICAL
			&& lBlock != Blocks.TURNINGRAILBOTTOMRIGHT
			&& lBlock != Blocks.TURNINGRAILBOTTOMLEFT
			&& lBlock != Blocks.TRIPLERAIL)
				return false;
		}
		
		Sound.playCartSound();
		
		return true;
	}

	public static function destroy():Void
	{
		list = null;
	}
}