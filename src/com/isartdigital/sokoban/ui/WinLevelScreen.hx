package com.isartdigital.sokoban.ui;
import com.isartdigital.sokoban.ui.LoginScreen;
import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.sokoban.game.level.Level;
import com.isartdigital.sokoban.game.mvp.GameManager;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.game.save.Session;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.sokoban.ui.Hud;
import motion.Actuate;
import motion.easing.Back;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;

/**
 * ...
 * @author Jean VIDREQUIN
 */
class WinLevelScreen extends ScreenTranslate
{
	/**
	 * instance unique de la classe WinLevelScreen
	 */
	private static var instance: WinLevelScreen;
	private static var counter:Int;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): WinLevelScreen
	{
		if (instance == null) instance = new WinLevelScreen();
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
		super.init(pEvent);
		if (SelectLevelScreen.nextLevel != SelectLevelScreen.MAX_LEVEL)
			LevelManager.levelDesign[SelectLevelScreen.nextLevel + 1].locked = false;
		counter = 0;
		var lStar : Int = calculStar(LevelManager.score);
		Session.starsArray.push(lStar);
		content.getChildByName("star1").visible = false;
		content.getChildByName("star2").visible = false;
		content.getChildByName("star5").visible = false;
		if (lStar == 1)
		{
			content.getChildByName("star1").scaleX = content.getChildByName("star1").scaleY = 0;
			content.getChildByName("star1").visible = true;
			Actuate.tween(content.getChildByName("star1"), 0.7, {scaleX:3.5, scaleY:3.5}).ease(Back.easeOut);
		}

		else if (lStar == 2)
		{
			content.getChildByName("star1").scaleX = content.getChildByName("star1").scaleY = 0;
			content.getChildByName("star2").scaleX = content.getChildByName("star2").scaleY = 0;
			content.getChildByName("star1").visible = true;
			content.getChildByName("star2").visible = true;
			Actuate.tween(content.getChildByName("star1"), 0.7, {scaleX:3.5, scaleY:3.5}).ease(Back.easeOut);
			Actuate.tween(content.getChildByName("star2"), 0.7, {scaleX:4, scaleY:4}, false).ease(Back.easeOut).delay(0.5);

		}

		else {
			content.getChildByName("star1").scaleX = content.getChildByName("star1").scaleY = 0;
			content.getChildByName("star2").scaleX = content.getChildByName("star2").scaleY = 0;
			content.getChildByName("star5").scaleX = content.getChildByName("star5").scaleY = 0;
			content.getChildByName("star1").visible = true;
			content.getChildByName("star2").visible = true;
			content.getChildByName("star5").visible = true;
			Actuate.tween(content.getChildByName("star1"), 0.7, {scaleX:3.5, scaleY:3.5}).ease(Back.easeOut);
			Actuate.tween(content.getChildByName("star2"), 0.7, {scaleX:4, scaleY:4}, false).ease(Back.easeOut).delay(0.5);
			Actuate.tween(content.getChildByName("star5"), 0.7, {scaleX:3.5, scaleY:3.5}).ease(Back.easeOut).delay(1);

		}

		if (calculStar(LevelManager.score) >= lStar) LevelManager.levelDesign[SelectLevelScreen.nextLevel].stars = "" + lStar;

		content.getChildByName("btnNext").addEventListener(MouseEvent.CLICK, onClickNext);
		content.getChildByName("btnRetry").addEventListener(MouseEvent.CLICK, onClickRetry);
		content.getChildByName("btnBack").addEventListener(MouseEvent.CLICK, onClickBack);
		calculStar(LevelManager.score);
		SelectLevelScreen.stars = calculStar(LevelManager.score);

	}

	function onClickBack(e:MouseEvent):Void
	{
		Session.update();
		Sound.fadeOutMainTheme();
		Sound.fadeInMenuTheme();
		UIManager.closeHud();
		GameManager.destroy();
		LevelManager.resetLevel();
		UIManager.addScreen(SelectLevelScreen.getInstance());
		Sound.playSoundClick();
		Session.update();
	}

	function onClickRetry(e:MouseEvent):Void
	{
		LevelManager.resetLevel();
		GameManager.destroy();
		Hud.getInstance().resetLevel();
		Hud.getInstance().launchNextLevel(true);
		Sound.playSoundClick();
		LevelManager.score = 0;
		Hud.getInstance().updateScore(LevelManager.score);
		Hud.getInstance().updateStars(true);
	}

	private function onClickNext(pEvent:MouseEvent):Void
	{
		Session.update();
		if (SelectLevelScreen.nextLevel == SelectLevelScreen.MAX_LEVEL)
		{
			UIManager.addScreen(HighscoresScreen.getInstance());
			Sound.fadeInWinTheme();
			
			LevelManager.updateCurrentLevel(SelectLevelScreen.nextLevel);
			SelectLevelScreen.getInstance().levelComplete();
			LevelManager.score = 0;
			Hud.getInstance().updateStars(true);
			LevelManager.resetLevel();
			GameManager.destroy();
		}
		else
		{
			LevelManager.updateCurrentLevel(SelectLevelScreen.nextLevel);
			SelectLevelScreen.getInstance().levelComplete();
			LevelManager.score = 0;
			Hud.getInstance().launchNextLevel();
			Hud.getInstance().updateStars(true);
		}
		Sound.playSoundClick();
	}

	private function  calculStar(pScore : Int) : Int
	{
		var lLevelPar : Level = LevelManager.levelDesign[SelectLevelScreen.nextLevel];
		var lPar : Int = lLevelPar.par;
		var lStar : UInt = 0;
		if (pScore <= lPar)
		{
			lStar = 3;
		}
		else if ((1.5*lPar) >= pScore && pScore>lPar)
		{
			lStar = 2;
		}
		else
		{
			lStar = 1;
		}
		return lStar;
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy():Void
	{
		instance = null;
		content.getChildByName("btnNext").removeEventListener(MouseEvent.CLICK, onClickNext);
		super.destroy();
	}
}