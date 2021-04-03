package com.isartdigital.sokoban.game.mvp;
import animateAtlasPlayer.core.Animation;
import com.isartdigital.sokoban.game.level.Blocks;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.game.sprites.Target;
import com.isartdigital.sokoban.game.sprites.movingobject.Box;
import com.isartdigital.sokoban.game.sprites.movingobject.Cart;
import com.isartdigital.sokoban.game.sprites.movingobject.MovingObject;
import com.isartdigital.sokoban.game.sprites.movingobject.Player;
import com.isartdigital.utils.extensions.DisplayObjectContainerExtender;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.grids.iso.IsoManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import motion.Actuate;
import motion.easing.Back;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.Sprite;
import openfl.events.KeyboardEvent;
import openfl.geom.Point;
import openfl.geom.Rectangle;
import openfl.ui.Keyboard;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
import org.zamedev.particles.renderers.ParticleSystemRenderer;

/**
 * ...
 * @author Jean VIDREQUIN
 */
class ViewManager
{
	private static var nColumn:Int = 9;
	private static var nRow:Int = 9;
	public static var cellSize:Float = 100;
	private static var hidden:Bool = true;
	public static var currentLevel(default, null):Array<Array<Array<MovieClip>>>;
	public static var radarContainer:Sprite;
	public static var isoContainer:Sprite;
	public static var zSortList : Array<MovieClip>;
	public static var playerIndex:Point;
	public static var counter:Int = 0;
	private static var instance: WinFinalScreen;
	private static var particleSystem :ParticleSystem;
	private static var particleSystem1 :ParticleSystem;
	private static var particleSystem2 :ParticleSystem;
	public static var particleRenderer :ParticleSystemRenderer;

	public static function  init():Void
	{
		initView();
		hidden = true;
		particleRenderer = DefaultParticleRenderer.createInstance();
		particleSystem = ParticleLoader.load("assets/particles/oui.pex");
		particleSystem1 = ParticleLoader.load("assets/particles/oui.pex");
		particleSystem2 = ParticleLoader.load("assets/particles/oui.pex");
		

		GameStage.getInstance().getGameContainer().stage.addEventListener(KeyboardEvent.KEY_UP, radarHide);
	}

	static function radarHide(e:KeyboardEvent):Void
	{
		var lRectangle : Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());

		if (e.keyCode == Keyboard.SPACE && hidden)
		{
			radarContainer.x = lRectangle.left + lRectangle.width / 2 - radarContainer.width + 50;
			radarContainer.y = lRectangle.top + lRectangle.height / 2 - radarContainer.height + 100;
			radarContainer.alpha = 0;
			radarContainer.scaleY = 0;
			radarContainer.scaleX = 1;
			Actuate.tween(radarContainer, 1, {scaleY:1, alpha:1}).ease(Back.easeOut);
			Actuate.tween(isoContainer, 1, {scaleY:0, alpha:0}).ease(Back.easeIn);
		}
		else if (e.keyCode == Keyboard.SPACE && !hidden)
		{
			radarContainer.alpha = 0;
			radarContainer.scaleY = 0;
			radarContainer.scaleX = 0.6;
			Actuate.tween(radarContainer, 1, {scaleY:0.6, alpha:1}).ease(Back.easeOut);
			Actuate.tween(isoContainer, 1, {scaleY:0.9, alpha:1}).ease(Back.easeOut);
			radarContainer.x = lRectangle.left+ 25;
			radarContainer.y = lRectangle.top + 25;

		}
		if (e.keyCode == Keyboard.SPACE) hidden = !hidden;
	}

	private static function initView():Void
	{

		if (radarContainer != null) GameStage.getInstance().getGameContainer().removeChild(radarContainer);
		if (isoContainer != null) GameStage.getInstance().getGameContainer().removeChild(isoContainer);

		currentLevel = new Array<Array<Array<MovieClip>>>();

		radarContainer = new Sprite();
		radarContainer.scaleX = radarContainer.scaleY =0.60;
		isoContainer = new Sprite();

		var lRectangle : Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());

		radarContainer.x = lRectangle.left+ 25;
		radarContainer.y = lRectangle.top + 25;
		isoContainer.scaleX = isoContainer.scaleY = 0.9;
		isoContainer.x = lRectangle.left + lRectangle.width/2;
		isoContainer.y = lRectangle.top + lRectangle.height/5;
		
		GameStage.getInstance().getGameContainer().addChild(isoContainer);
		GameStage.getInstance().getGameContainer().addChild(radarContainer);
		
		var lPoint:Point;

		for (y in 0...nRow)
		{
			currentLevel.push(new Array<Array<MovieClip>>());

			for (x in 0...nColumn)
			{
				lPoint = new Point(x, y);
				initIsoView(lPoint);
				initRadarView(lPoint);
			}
		}
	}

	private static function initRadarView(pModelPos:Point):Void
	{
		if (!isPosValid(pModelPos)) return;

		var length:Int = LevelManager.currentLevel[Std.int(pModelPos.y)][Std.int(pModelPos.x)].length;
		var lBlock:MovieClip = new MovieClip();

		for (a in 0...length)
		{
			switch (LevelManager.currentLevel[Std.int(pModelPos.y)][Std.int(pModelPos.x)][a])
			{
				case Blocks.GROUND : lBlock = new RadarFloor();
				case Blocks.PLAYER : lBlock = new RadarPlayer();
					Player.getInstance().radar = lBlock;
				case Blocks.WALL : lBlock = new RadarWall();
				case Blocks.CART : lBlock = new RadarCart();
					var lLength: UInt = Cart.list.length;

					for (i in 0...lLength)
					{
						if (Cart.list[i].radar == null)
						{
							Cart.list[i].radar = lBlock;
							break;
						}
					}
				case Blocks.RAILHORIZONTAL : lBlock = new RadarRailHorizontal();
				case Blocks.RAILVERTICAL : lBlock = new RadarRailVertical();
				case Blocks.TARGET : lBlock = new RadarGoal();
					var lLength:UInt = Target.list.length;

					for (i in 0...lLength)
					{
						if (Target.list[i].radar == null)
						{
							Target.list[i].radar = lBlock;
							break;
						}
					}
				case Blocks.BOX : lBlock = new RadarBox();
					var lLength:UInt = Box.list.length;

					for (i in 0...lLength)
					{
						if (Box.list[i].radar == null)
						{
							Box.list[i].radar = lBlock;
							break;
						}
					}
				case Blocks.TURNINGRAILBOTTOMLEFT : lBlock = new RadarTurningRailBottomLeft();
				case Blocks.TURNINGRAILTOPLEFT : lBlock = new RadarTurningRailTopLeft();
				case Blocks.TURNINGRAILBOTTOMRIGHT : lBlock = new RadarTurningRailBottomRight();
				case Blocks.TURNINGRAILTOPRIGHT : lBlock = new RadarTurningRailTopRight();
				case Blocks.TRIPLERAIL : lBlock = new RadarTripleRailVertical();
				default : lBlock = new RadarFloor();
			}

			updatePosOnRadarView(lBlock, pModelPos);
		}
	}

	public static function updatePosOnRadarView(pBlock:DisplayObject, pModelPos:Point):Void
	{
		var lModelpos : Point = modelToView(pModelPos);
		pBlock.x = lModelpos.x;
		pBlock.y = lModelpos.y;
		radarContainer.addChild(pBlock);
	}

	public static function updateRadarView(pBlock:MovingObject, pModelPos:Point, pInitialIndex:Point):Void
	{
		updatePosOnRadarView(pBlock.radar, pModelPos);

		var lLength:Int = currentLevel[Std.int(pInitialIndex.y)][Std.int(pInitialIndex.x)].length;
		var lObject:Array<MovieClip> = new Array<MovieClip>();

		for (a in 0...lLength)
		{
			if (pBlock == currentLevel[Std.int(pInitialIndex.y)][Std.int(pInitialIndex.x)][a])
			{
				lObject = currentLevel[Std.int(pInitialIndex.y)][Std.int(pInitialIndex.x)].splice(a, 1);
				break;
			}
		}

		currentLevel[Std.int(pModelPos.y)][Std.int(pModelPos.x)].push(lObject[0]);
	}

	public static function removeParticle():Void
	{
		particleRenderer.removeParticleSystem(particleSystem);
		particleRenderer.removeParticleSystem(particleSystem1);
		particleRenderer.removeParticleSystem(particleSystem2);

		particleRenderer = DefaultParticleRenderer.createInstance();
		
	}

	public static function completeTarget(pFloor:Floor, pModelPos:Point):Void
	{
		currentLevel[Std.int(pModelPos.y)][Std.int(pModelPos.x)].splice(0, 2);
		currentLevel[Std.int(pModelPos.y)][Std.int(pModelPos.x)][0] = pFloor;
		GameStage.getInstance().getGameContainer().addChild(cast particleRenderer);
		particleRenderer.addParticleSystem(particleSystem);
		particleRenderer.addParticleSystem(particleSystem1);
		particleRenderer.addParticleSystem(particleSystem2);
		var point:Point = IsoManager.modelToIsoView(pModelPos);
		point = isoContainer.localToGlobal(point);
		point = GameStage.getInstance().getGameContainer().globalToLocal(point);
		
		particleSystem.emit(point.x, point.y);
		particleSystem.particleLifespan = 0.3;
		particleSystem1.emit(point.x, point.y);
		particleSystem1.particleLifespan = 0.3;
		particleSystem2.emit(point.x, point.y);
		particleSystem2.particleLifespan = 0.3;
		
		Actuate.tween(particleSystem2, 1, {alpha:0}).onComplete(removeParticle);
		updatePosOnRadarView(new RadarFloor(), pModelPos);
	}

	private static function  initIsoView (pModelPos:Point):Void
	{
		var length : Int = LevelManager.currentLevel[Std.int(pModelPos.y)][Std.int(pModelPos.x)].length;
		var lBlock : MovieClip = new MovieClip();
		var lCell:Array<MovieClip> = new Array<MovieClip>();
		zSortList = new Array<MovieClip>();
		for (a in 0...length)
		{
			switch (LevelManager.currentLevel[Std.int(pModelPos.y)][Std.int(pModelPos.x)][a])
			{
				case Blocks.GROUND : lBlock = new Floor();
				case Blocks.PLAYER : lBlock = Player.getInstance();
				case Blocks.WALL : var random:Int = Math.floor(Math.random() * 25);
					if (random == 0) lBlock = new Wall();
					else if (random == 1) lBlock = new Wall3();
					else if (random == 3) lBlock = new Wall4();
					else if (random == 5) lBlock = new Wall5();
					else if (random == 7) lBlock = new Wall2();
					else lBlock = new Wall6();
				case Blocks.CART : lBlock = new Cart();
				case Blocks.RAILHORIZONTAL : lBlock = new RailHorizontal();
				case Blocks.RAILVERTICAL : lBlock = new RailVertical();
				case Blocks.TARGET : lBlock = new Target();
				case Blocks.BOX : lBlock = new Box();
				case Blocks.TURNINGRAILBOTTOMLEFT : lBlock = new TurningRailBottomLeft();
				case Blocks.TURNINGRAILTOPLEFT : lBlock = new TurningRailTopLeft();
				case Blocks.TURNINGRAILBOTTOMRIGHT : lBlock = new TurningRailBottomRight();
				case Blocks.TURNINGRAILTOPRIGHT : lBlock = new TurningRailTopRight();
				case Blocks.TRIPLERAIL : lBlock = new TripleRail();
				default : lBlock = new Floor();
			}

			updateIsoView(lBlock, pModelPos, false);
			lCell.push(lBlock);
		}

		currentLevel[currentLevel.length - 1].push(lCell);
	}

	public static function updateIsoView(pBlock: MovieClip, pModelPos:Point, pZSort:Bool = true):Void
	{
		var lIsoPoint:Point;
		lIsoPoint = IsoManager.modelToIsoView(pModelPos);

		pBlock.x = lIsoPoint.x;
		pBlock.y = lIsoPoint.y;
		isoContainer.addChild(pBlock);
		if (pZSort) zSorting();
	}

	public static function zSorting():Void
	{
		for (row in 0...currentLevel.length)
		{
			for (cell in 0...currentLevel[row].length )
			{
				for (object in currentLevel[row][cell] )
				{
					IsoManager.zSort(currentLevel[row][cell]);
					object.parent.addChild(object);

				}
			}
		}
	}

	public static function modelToView(pModelPos:Point):Point
	{
		return new Point(pModelPos.x * cellSize, pModelPos.y * cellSize);
	}

	private static function isPosValid(pPos:Point):Bool
	{
		return pPos.x >= 0 &&  pPos.y >= 0 && pPos.x < nColumn && pPos.y < nRow;
	}

	public static function destroyViews():Void
	{
		isoContainer.parent.removeChild(isoContainer);
		radarContainer.parent.removeChild(radarContainer);
		isoContainer = null;
		radarContainer = null;
	}

}