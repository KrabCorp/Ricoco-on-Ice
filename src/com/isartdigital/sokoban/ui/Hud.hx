package com.isartdigital.sokoban.ui;

import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.sokoban.game.level.Level;
import com.isartdigital.sokoban.game.mvp.GameManager;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.game.hud.UndoRedo;
import com.isartdigital.sokoban.game.mvp.ViewManager;
import com.isartdigital.sokoban.game.sprites.Target;
import com.isartdigital.sokoban.game.sprites.movingobject.Player;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Localization;
import com.isartdigital.utils.ui.UIPositionable;
import js.html.svg.Number;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Bounce;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import com.isartdigital.sokoban.game.sprites.movingobject.Cart;
import com.isartdigital.sokoban.game.sprites.movingobject.Box;

/**
 * ...
 * @author Chadi Husser
 */
class Hud extends ScreenTranslate
{
	private static var instance : Hud;

	private static var SCORE_PREFIX : String;
	private static var undoTrad : String;
	private static var redoTrad : String;
	private static var par:Int;
	private static var textScore : MovieClip;
	private static var textScoreTextField : TextField;
	private var btnUndoChildren:Array<TextField>;
	private var btnRedoChildren:Array<TextField>;
	
	public static function getInstance() : Hud
	{
		if (instance == null) instance = new Hud();
		return instance;
	}

	public function new()
	{
		super();
	}

	override public function init(pEvent:Event):Void
	{
		if (!Localization.english)
		{
			SCORE_PREFIX = "Steps : ";
			undoTrad = "Undo";
			redoTrad = "Redo";
		}
		else {
			SCORE_PREFIX = "Pas : ";
			undoTrad = "Annuler";
			redoTrad = "Refaire";
		}

		textScore = cast(content.getChildByName("txtScore"), MovieClip);
		textScoreTextField = cast(textScore.getChildAt(1), TextField);
		textScoreTextField.text = "";
		textScoreTextField.text += SCORE_PREFIX + LevelManager.score;

		var lBtnBack:DisplayObject = content.getChildByName("btnBack");
		var lBtnRedo:DisplayObject = content.getChildByName("btnRedo");
		var lBtnUndo:DisplayObject = content.getChildByName("btnUndo");
		var lBtnRetry:DisplayObject = content.getChildByName("btnRetry");
		var lStar1:DisplayObject = content.getChildByName("star1");
		var lStar2:DisplayObject = content.getChildByName("star2");
		var lStar3:DisplayObject = content.getChildByName("star3");
		var lNoStar1:DisplayObject = content.getChildByName("noStar1");
		var lNoStar2:DisplayObject = content.getChildByName("noStar2");
		var lNoStar3:DisplayObject = content.getChildByName("noStar3");
		
		
		var lLevelPar : Level = LevelManager.levelDesign[SelectLevelScreen.nextLevel];
		var lParsin : Int = lLevelPar.par;
		
		
		var lparMovie : MovieClip = cast(content.getChildByName("mcPar"), MovieClip);
		var lParTexT : TextField = cast(lparMovie.getChildAt(0), TextField);
		lParTexT.text = "PAR " + lParsin;
		
		var lPar : DisplayObject = content.getChildByName("mcPar");
		
		var totalDuration : Float = 2.75;
		lBtnBack.addEventListener(MouseEvent.CLICK, onBack);
		lBtnRedo.addEventListener(MouseEvent.CLICK, onRedo);
		lBtnUndo.addEventListener(MouseEvent.CLICK, onUndo);
		lBtnRetry.addEventListener(MouseEvent.CLICK, onRetry);

		updateScore(LevelManager.score);
		updateStars(true);

		lBtnBack.alpha = 0;
		lBtnRedo.alpha = 0;
		lBtnUndo.alpha = 0;
		lBtnRetry.alpha = 0;
		textScore.alpha = 0;

		lStar1.alpha = 0;
		lStar2.alpha = 0;
		lStar3.alpha = 0;
		//ViewManager.radarContainer.alpha = 0;

		lNoStar1.alpha = 0;
		lNoStar2.alpha = 0;
		lNoStar3.alpha = 0;
	
		lPar.x = 1104.9;
		lPar.y = 2229;
		Actuate.tween(lPar, 1.5, {y : GameStage.getInstance().height / 2}).ease(Back.easeOut);
		Actuate.tween(lPar, 2.75, {x : GameStage.getInstance().width * 3 }).delay(totalDuration);
		Actuate.tween(lBtnBack, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lBtnRedo, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lBtnUndo, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lBtnRetry, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(textScore, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lNoStar1, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lNoStar2, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lNoStar3, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lStar1, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lStar2, 2, {alpha: 1}).delay(2.5);
		Actuate.tween(lStar3, 2, {alpha: 1}).delay(2.5);

	}

	private function onBack(pEvent:MouseEvent):Void
	{
		Sound.fadeOutMainTheme();
		Sound.fadeInMenuTheme();
		UIManager.closeHud();
		resetLevel();
		GameManager.destroy();
		LevelManager.resetLevel();
		updateStars(true);
		UIManager.addScreen(SelectLevelScreen.getInstance());
		Sound.playSoundClick();
	}

	private function onRetry(pEvent:MouseEvent):Void
	{
		LevelManager.resetLevel();
		GameManager.destroy();
		resetLevel();
		updateStars(true);
		LevelManager.score = 0;
		launchNextLevel(true);
		Sound.playSoundClick();
	}

	public function resetLevel():Void
	{
		allDestroyCalled();
		updateScore(LevelManager.score);
	}

	public function launchNextLevel(?pIsRetry:Bool = false):Void
	{
		updateScore(LevelManager.score);
		updateStars(true);
		LevelManager.updateCurrentLevel(SelectLevelScreen.nextLevel);
		GameManager.restart(pIsRetry);
		ViewManager.isoContainer.addChild(cast GameManager.particleRenderer);
	}

	private function allDestroyCalled():Void
	{
		Player.getInstance().destroy();
		Box.destroy();
		Cart.destroy();
		Target.destroy();
	}

	public function updateScore(pScore:Int):Void
	{
		textScoreTextField.text = "";
		textScoreTextField.text += SCORE_PREFIX + pScore;
	}

	public function updateStars(pFromUndo:Bool = false):Void
	{

		var lStar:Int = calculStar(LevelManager.score);
		if (!pFromUndo)
		{
			if (lStar == 2)
			{
				Actuate.tween(content.getChildByName("star3"), 2, { y: 280, alpha: 0}, false);
			}
			else if (lStar == 1)
			{
				Actuate.tween(content.getChildByName("star2"), 2, { y: 280, alpha: 0}, false);

			}
		}
		else {

			if (lStar == 3)
			{
				Actuate.tween(content.getChildByName("star3"), 0.001, { y: 215});
				Actuate.tween(content.getChildByName("star2"), 0.001, { y: 215});
			}
			else if (lStar == 2)
			{
				Actuate.tween(content.getChildByName("star2"), 0.001, { y: 215});
			}
		}
	}

	private function onUndo(pEvent:MouseEvent):Void
	{
		UndoRedo.undo();
	}

	private function onRedo(pEvent:MouseEvent):Void
	{
		UndoRedo.redo();
	}

	private function  calculStar(pScore : Int) : Int
	{
		var lLevelPar : Level = LevelManager.levelDesign[SelectLevelScreen.nextLevel];
		var lPar : Int = lLevelPar.par;
		par = lPar;
		var star : UInt = 0;
		if (pScore <= lPar)
		{
			star = 3;
		}
		else if ((1.5*lPar) >= pScore && pScore>lPar)
		{
			star = 2;
		}
		else
		{
			star = 1;
		}
		return star;
	}

	override public function destroy():Void
	{
		instance = null;
		content.getChildByName("btnBack").removeEventListener(MouseEvent.CLICK, onBack);
		content.getChildByName("btnRedo").removeEventListener(MouseEvent.CLICK, onRedo);
		content.getChildByName("btnUndo").removeEventListener(MouseEvent.CLICK, onUndo);
		content.getChildByName("btnRetry").removeEventListener(MouseEvent.CLICK, onRetry);
		super.destroy();
	}
}