package com.isartdigital.sokoban.game.mvp;
import com.isartdigital.sokoban.controller.KeyboardController;
import com.isartdigital.sokoban.game.hud.UndoRedo;
import com.isartdigital.sokoban.game.mvp.ViewManager;
import com.isartdigital.sokoban.game.sprites.movingobject.Player;
import com.isartdigital.sokoban.game.sprites.Template;
import com.isartdigital.sokoban.ui.HighscoresScreen;
import com.isartdigital.sokoban.ui.UIManager;
import com.isartdigital.sokoban.ui.Hud;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.sokoban.ui.WinLevelScreen;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.system.Monitor;
import haxe.Json;
import motion.Actuate;
import motion.easing.Sine;
import openfl.Lib;
import openfl.display.DisplayObject;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
import org.zamedev.particles.renderers.ParticleSystemRenderer;

import org.zamedev.particles.ParticleSystem;

/**
 * ...
 * @author Chadi Husserv
 */
class GameManager
{
	private static inline var MAX_FRAMES_BEFORE_DESTROY_ALL_VIEWS:UInt = 100;
	private static inline var END_COUNTER = 550;

	private static var particleSystem :ParticleSystem;
	private static var particleSystem1 :ParticleSystem;
	private static var particleSystem2 :ParticleSystem;
	public static var particleRenderer :ParticleSystemRenderer;
	
	public static var controller:KeyboardController;
	public static var lastLevelUnlocked:UInt = 0;
	private static var counter:UInt;
	private static var beginCounter: UInt;

	public static var doAction:Void->Void;

	public static function start() : Void
	{
		controller = new KeyboardController();
		var lJson:Dynamic = Json.parse(GameLoader.getText("assets/settings/player.json"));
		Monitor.setSettings(lJson, Template.getInstance());
		
		//var fields : Array<MonitorField> = [{name:"smoothing", onChange:onChange}, {name:"x", step:1}, {name:"y", step:100}];
		//Monitor.start(Template.getInstance(), fields, lJson);

		//var lRect :Rectangle = DeviceCapabilities.getScreenRect(GameStage.getInstance());

		particleRenderer = DefaultParticleRenderer.createInstance();
		particleSystem = ParticleLoader.load("assets/particles/particle.pex");
		particleSystem1 = ParticleLoader.load("assets/particles/particle.pex");
		particleSystem2 = ParticleLoader.load("assets/particles/particle.pex");
	
		
	}

	public static function restart(?pIsRetry:Bool = false):Void
	{
		Sound.fadeOutMenuTheme();
		UIManager.closeScreens();
		UIManager.openHud();

		GameStage.getInstance().stage.addEventListener(MouseEvent.CLICK, onClick);

		resumeGame();
		UndoRedo.init();
		ViewManager.init();

		if (!pIsRetry)
		{
			ViewManager.isoContainer.addChild(cast particleRenderer);
			
			particleRenderer.addParticleSystem(particleSystem);
			particleRenderer.addParticleSystem(particleSystem1);
			particleRenderer.addParticleSystem(particleSystem2);
			
			particleSystem.emit(-1300,-100);
			particleSystem1.emit(600, -100);
			particleSystem2.emit( -200, 0);
		}

		Lib.current.stage.addEventListener(Event.ENTER_FRAME, gameLoop);
		Lib.current.stage.focus = Lib.current.stage;

		!pIsRetry ? setLevel() : setLevelInProgress();
		counter = 0;
		beginCounter = 0;
	}

	public static function resumeGame() : Void
	{
		Sound.fadeInMainTheme();
	}

	private static function onClick(pEvent:MouseEvent) : Void
	{

	}

	private static function onChange(pValue:Bool) : Void
	{
		trace(pValue);
	}

	public static function pauseGame() : Void
	{

	}

	private static function endLevel():Void
	{
		if (counter < MAX_FRAMES_BEFORE_DESTROY_ALL_VIEWS)
			counter++;
		else
		{
			Sound.fadeOutMainTheme();
			Sound.playJingleWin();
			Hud.getInstance().resetLevel();
			UIManager.closeHud();
			ViewManager.destroyViews();
			UIManager.addScreen(WinLevelScreen.getInstance());
			destroy();
		}
	}

	private static function beginLevel(): Void
	{
		if (beginCounter++ < END_COUNTER)
		{
			beginCounter++;
			
			if (beginCounter == 490) Actuate.tween(cast particleRenderer, 1, {x: 2000}).ease(Sine.easeOut).onComplete(removeParticle);
		}
		else
			setLevelInProgress();
	}

	public static function removeParticle():Void
	{
		particleRenderer.removeParticleSystem(particleSystem);
		particleRenderer.removeParticleSystem(particleSystem1);
		particleRenderer.removeParticleSystem(particleSystem2);
		
		particleRenderer = DefaultParticleRenderer.createInstance();
	}

	public static function setLevel () : Void
	{
		doAction = beginLevel;
	}

	public static function setEndLevel():Void
	{
		doAction = endLevel;
	}

	private static function levelInProgress():Void
	{
		Player.getInstance().doAction();
		UndoRedo.lengthCheck();
	}

	public static function setLevelInProgress():Void
	{
		doAction = levelInProgress;
	}

	private static function gameLoop(pEvent:Event):Void
	{
		doAction();
	}

	public static function destroy():Void
	{
		Lib.current.stage.removeEventListener(Event.ENTER_FRAME, gameLoop);
	}
}