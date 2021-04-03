package com.isartdigital.sokoban.ui;

import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.utils.game.GameStage;
import openfl.events.Event;
import openfl.events.MouseEvent;
import org.zamedev.particles.ParticleSystem;
import org.zamedev.particles.loaders.ParticleLoader;
import org.zamedev.particles.renderers.DefaultParticleRenderer;
import org.zamedev.particles.renderers.ParticleSystemRenderer;

/**
 * ...
 * @author Jean VIDREQUIN
 */
class WinFinalScreen extends ScreenTranslate
{

	/**
	 * instance unique de la classe WinFinalScreen
	 */
	private static var instance: WinFinalScreen;
	private static var particleSystem :ParticleSystem;
	private static var particleSystem1 :ParticleSystem;
	private static var particleSystem2 :ParticleSystem;
	public static var particleRenderer :ParticleSystemRenderer;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): WinFinalScreen
	{
		if (instance == null) instance = new WinFinalScreen();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(?pLibrary:String="ui")
	{
		super(pLibrary);

	}

	override function init(pEvent:Event):Void
	{
		UIManager.closeHud();
		super.init(pEvent);
		
		particleRenderer = DefaultParticleRenderer.createInstance();
		GameStage.getInstance().getGameContainer().addChild(cast particleRenderer);
		content.getChildByName("btnMenu").addEventListener(MouseEvent.CLICK, onClickMenu);
		content.getChildByName("btnHigh").addEventListener(MouseEvent.CLICK, onClickHighScore);
		content.getChildByName("btnBack").addEventListener(MouseEvent.CLICK, onClickBack);
		
		particleSystem = ParticleLoader.load("assets/particles/confettis1.pex");
		particleSystem1 = ParticleLoader.load("assets/particles/confettis1.pex");
		particleSystem2 = ParticleLoader.load("assets/particles/confettis1.pex");
		
		particleRenderer.addParticleSystem(particleSystem);
		particleRenderer.addParticleSystem(particleSystem1);
		particleRenderer.addParticleSystem(particleSystem2);
			
		particleSystem.emit(-1300,-500);
		particleSystem1.emit(600, -500);
		particleSystem2.emit( -200, -500);
	}

	function onClickBack(e:MouseEvent):Void
	{
		Sound.fadeOutMainTheme();
		Sound.fadeOutWinTheme();
		Sound.fadeInMenuTheme();
		LevelManager.resetLevel();
		UIManager.addScreen(SelectLevelScreen.getInstance());
		Sound.playSoundClick();
		removeParticle();
	}
	
	public static function removeParticle():Void
	{
		particleRenderer.removeParticleSystem(particleSystem);
		particleRenderer.removeParticleSystem(particleSystem1);
		particleRenderer.removeParticleSystem(particleSystem2);
		
		particleRenderer = DefaultParticleRenderer.createInstance();
	}
	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */

	private function onClickMenu(pEvent:MouseEvent):Void
	{
		Sound.fadeOutWinTheme();
		Sound.fadeInMenuTheme();
		LevelManager.resetLevel();
		UIManager.addScreen(SelectLevelScreen.getInstance());
		Sound.playSoundClick();
		removeParticle();
	}

	private function onClickHighScore(pEvent:MouseEvent):Void
	{
		Sound.fadeOutWinTheme();
		Sound.fadeInMenuTheme();
		LevelManager.resetLevel();
		UIManager.addScreen(HighscoresScreen.getInstance());
		Sound.playSoundClick();
		removeParticle();
	}

	override public function destroy (): Void
	{
		instance = null;
		content.getChildByName("btnMenu").removeEventListener(MouseEvent.CLICK, onClickMenu);
		content.getChildByName("btnHigh").removeEventListener(MouseEvent.CLICK, onClickHighScore);
		super.destroy();
	}
}