package com.isartdigital.sokoban;

import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.sokoban.game.mvp.GameManager;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.game.save.Session;
import com.isartdigital.sokoban.ui.GraphicLoader;
import com.isartdigital.sokoban.ui.LoginScreen;
import com.isartdigital.sokoban.ui.TitleCard;
import com.isartdigital.sokoban.ui.UIManager;
import com.isartdigital.utils.Config;
import com.isartdigital.utils.debug.Debug;
import com.isartdigital.utils.events.AssetsLoaderEvent;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.game.GameStageScale;
import com.isartdigital.utils.game.StateManager;
import com.isartdigital.utils.loader.GameLoader;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.system.DeviceCapabilities;
import haxe.Json;
import openfl.Assets;
import openfl.display.Sprite;
import openfl.display.StageAlign;
import openfl.display.StageScaleMode;
import openfl.events.Event;

class Main extends Sprite
{

	private static var instance:Main;

	public static function getInstance():Main
	{
		return instance;
	}

	public function new ()
	{
		instance = this;

		super ();
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;

		//SETUP de la config
		Config.init(Json.parse(Assets.getText("assets/config.json")));

		//SETUP du gamestage
		GameStage.getInstance().scaleMode = GameStageScale.SHOW_ALL;
		GameStage.getInstance().init(null, 2160, 1440);

		DeviceCapabilities.init();

		stage.addChild(GameStage.getInstance());
		stage.addEventListener(Event.RESIZE, resize);
		resize();

		//SETUP du debug
		Debug.init();
		
		UIManager.addScreen(GraphicLoader.getInstance());

		//CHARGEMENT
		var lGameLoader:GameLoader = new GameLoader();
		lGameLoader.addEventListener(AssetsLoaderEvent.PROGRESS, onLoadProgress);
		lGameLoader.addEventListener(AssetsLoaderEvent.COMPLETE, onLoadComplete);

		//Chargement des sons
		var soundPaths : Array<String> = SoundManager.setupSoundsData(Json.parse(Assets.getText("assets/sounds/sounds.json")));

		for (soundPath in soundPaths)
		{
			lGameLoader.addSound(soundPath);
		}

		//Chargement des atlas
		lGameLoader.addAtlas("Astronaut");
		lGameLoader.addAtlas("radarAssets");
		lGameLoader.addAtlas("isoAssets");

		//Chargement des settings
		lGameLoader.addText("assets/settings/player.json");
		lGameLoader.addText("assets/levels/leveldesign.json");
		lGameLoader.addText("assets/localisation.json");
		lGameLoader.addText("assets/session.json");

		//Chargement des particules
		lGameLoader.addText("assets/particles/particle.pex");
		lGameLoader.addText("assets/particles/oui.pex");
		lGameLoader.addText("assets/particles/completeTarget.pex");
		lGameLoader.addText("assets/particles/oui.pex");
		lGameLoader.addText("assets/particles/confettis0.pex");
		lGameLoader.addText("assets/particles/confettis1.pex");
		lGameLoader.addBitmapData("assets/particles/oui.png");
		lGameLoader.addBitmapData("assets/particles/texture.png");
		lGameLoader.addBitmapData("assets/particles/stars.png");

		//Chargement des swf
		lGameLoader.addLibrary("assets");
		lGameLoader.addLibrary("radarAssets");
		lGameLoader.addLibrary("isoAssets");

		//Chargement de l'ui
		lGameLoader.addLibrary("ui");

		lGameLoader.addFont("assets/fonts/Unxgala.ttf");

		//Chargement des colliders
		lGameLoader.addText("assets/colliders.json");

		lGameLoader.load();
	}

	private function onLoadProgress (pEvent:AssetsLoaderEvent): Void
	{
		GraphicLoader.getInstance().setProgress(pEvent.filesLoaded / pEvent.nbFiles);
	}

	private function onLoadComplete (pEvent:AssetsLoaderEvent): Void
	{
		//trace("LOAD COMPLETE");
		
		var lGameLoader : GameLoader = cast(pEvent.target, GameLoader);
		lGameLoader.removeEventListener(AssetsLoaderEvent.PROGRESS, onLoadProgress);
		lGameLoader.removeEventListener(AssetsLoaderEvent.COMPLETE, onLoadComplete);

		SoundManager.initSounds();

		//Ajout des colliders des stateObjects
		StateManager.addColliders(Json.parse(GameLoader.getText("assets/colliders.json")));

		UIManager.addScreen(LoginScreen.getInstance());
		LevelManager.init();
		GameManager.start();
		Sound.initPropertySoundFX();
	}

	private static function importClasses() : Void
	{

	}

	public function resize (pEvent:Event = null): Void
	{
		GameStage.getInstance().resize();
	}

}