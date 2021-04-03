package com.isartdigital.sokoban.ui;

import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.sokoban.game.mvp.GameManager;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Localization;
import com.isartdigital.utils.ui.UIPositionable;
import js.html.svg.Number;
import motion.Actuate;
import motion.actuators.SimpleActuator;
import motion.easing.Back;
import motion.easing.Quart;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;
import openfl.text.TextField;

/**
 * ...
 * @author AnaelleMncs
 */
class SelectLevelScreen extends ScreenTranslate
{
	public static inline var MAX_LEVEL:Int	= 12;
	public static var nextLevel:Int;

	private static var instance:SelectLevelScreen;

	private static inline var BTN_BACK:String		= "btnBack";
	private static inline var BTN_UNLOCK:String		= "btnUnlock";
	private static inline var MC_LEVEL:String		= "mcLevel_";
	private static var PREFIX:String;

	private static inline var BTN_OFFSET_X:Float	= 400;
	private static inline var BTN_OFFSET_Y:Float	= 200;
	private static inline var TITLE_OFFSET_Y:Float	= 100;
	private static inline var TUTO_OFFSET_Y:Float	= 500;
	private static inline var LEVEL_ROW1_OFFSET_Y:Float	= 800;
	private static inline var LEVEL_ROW2_OFFSET_Y:Float	= 1100;
	public static var stars:Int;
	public static var buttonsLevel:Array<DisplayObject>;

	private static var unlockMode:Bool = false;
	private var btnLevelChildren:Array<MovieClip>;
	private var btnUnlockChildren:Array<MovieClip>;
	private var btnLevelText:Array<TextField>;
	private var lLevel:Int;
	private function new()
	{
		super();
	}

	override function init(pEvent:Event):Void
	{
		LevelManager.score = 0;
		if (Localization.english) PREFIX = "Niveau ";
		else PREFIX = "Level ";
		stopAllMovieClips();
		buttonsLevel = new Array<DisplayObject>();
		btnLevelChildren = new Array<MovieClip>();
		btnUnlockChildren = new Array<MovieClip>();
		btnLevelText = new Array<TextField>();
		content.getChildByName(BTN_BACK).addEventListener(MouseEvent.MOUSE_UP, onBack);
		content.getChildByName(BTN_UNLOCK).addEventListener(MouseEvent.MOUSE_UP, onUnlock);

		var lLength:UInt = LevelManager.allLevels.length;
		
		var lCoord:Point			= new Point();
		var lDuration:Float			= 0.47;
		var lTotalDuration:Float	= lDuration * 2;
		var lCoordY:Float			= - GameStage.getInstance().safeZone.height;

		for (i in 0...lLength)
		{
			var lButton:DisplayObject = content.getChildByName(MC_LEVEL + i);
			
			lCoord.setTo(lButton.x, lButton.y);
			lButton.y = lCoordY;
			
			lLevel = i + 1;
			getTextLevel(lButton);
			getChildrenOfLevelButton(lButton);
			buttonsLevel.push(lButton);

			lButton.addEventListener(MouseEvent.CLICK, onClick);
			
			if (i == 3) lTotalDuration -= lDuration;
			
			if (i == 8) lTotalDuration = 0;
			
			Actuate.tween(lButton, lDuration, {y: lCoord.y}).ease(Back.easeOut).delay(lTotalDuration);
		}
		
		getChildrenOfUnlockButton(content.getChildByName(BTN_UNLOCK));
		
		if (unlockMode) {
			for (b in btnUnlockChildren)
			{
				b.gotoAndStop(1);
			}
		}
		else {
			for (b in btnUnlockChildren)
			{
				b.gotoAndStop(2);
			}
		}
		
		var count:Int;
		var count2:Int;
		for (i in 0...buttonsLevel.length)
		{
			count2 = i - 2;
			if (!LevelManager.levelDesign[i].locked)
			{
				count = i + 1;
				
				btnLevelChildren[count*3 -1].gotoAndStop(1);
				btnLevelChildren[count*3-2].gotoAndStop(1);
				btnLevelChildren[count * 3 - 3].gotoAndStop(1);
				btnLevelText = null;
				btnLevelText = new Array<TextField>();
				getTextLevel(buttonsLevel[i]);
				if (i <= 2) {
					btnLevelText[3 - 1].text = "Tuto " + (count);
					btnLevelText[3 - 2].text = "Tuto " + (count);
					btnLevelText[3 - 3].text = "Tuto " + (count);
				} else {
					btnLevelText[3 - 1].text = PREFIX + count2;
					btnLevelText[3 - 2].text = PREFIX + count2;
					btnLevelText[3 - 3].text = PREFIX + count2;
				}
			}
			if (LevelManager.levelDesign[i].locked)
			{
				count = i + 1;
				
				btnLevelChildren[count*3 -1].gotoAndStop(5);
				btnLevelChildren[count*3-2].gotoAndStop(5);
				btnLevelChildren[count * 3 - 3].gotoAndStop(5);
				btnLevelText = null;
				btnLevelText = new Array<TextField>();
				getTextLevel(buttonsLevel[i]);
				if (i <= 2) {
					btnLevelText[3 - 1].text = "Tuto " + (count);
					btnLevelText[3 - 2].text = "Tuto " + (count);
					btnLevelText[3 - 3].text = "Tuto " + (count);
				} else {
					btnLevelText[3 - 1].text = PREFIX + count2;
					btnLevelText[3 - 2].text = PREFIX + count2;
					btnLevelText[3 - 3].text = PREFIX + count2;
				}
			}
			else if (LevelManager.levelDesign[i].stars == "1")
			{
				count = i + 1;
				
				btnLevelChildren[count*3 -1].gotoAndStop(2);
				btnLevelChildren[count*3-2].gotoAndStop(2);
				btnLevelChildren[count * 3 - 3].gotoAndStop(2);
				btnLevelText = null;
				btnLevelText = new Array<TextField>();
				getTextLevel(buttonsLevel[i]);
				if (i <= 2) {
					btnLevelText[3 - 1].text = "Tuto " + (count);
					btnLevelText[3 - 2].text = "Tuto " + (count);
					btnLevelText[3 - 3].text = "Tuto " + (count);
				} else {
					btnLevelText[3 - 1].text = "Level " + count2;
					btnLevelText[3 - 2].text = "Level " + count2;
					btnLevelText[3 - 3].text = "Level " + count2;
				}
			}
			else if (LevelManager.levelDesign[i].stars == "2")
			{
				count = i + 1;
				
				btnLevelChildren[count*3 -1].gotoAndStop(3);
				btnLevelChildren[count*3-2].gotoAndStop(3);
				btnLevelChildren[count * 3 - 3].gotoAndStop(3);
				btnLevelText = null;
				btnLevelText = new Array<TextField>();
				getTextLevel(buttonsLevel[i]);
				if (i <= 2) {
					btnLevelText[3 - 1].text = "Tuto " + (count);
					btnLevelText[3 - 2].text = "Tuto " + (count);
					btnLevelText[3 - 3].text = "Tuto " + (count);
				} else {
					btnLevelText[3 - 1].text = "Level " + count2;
					btnLevelText[3 - 2].text = "Level " + count2;
					btnLevelText[3 - 3].text = "Level " + count2;
				}
			}
			else if (LevelManager.levelDesign[i].stars == "3")
			{
				count = i + 1;
				
				btnLevelChildren[count*3 -1].gotoAndStop(4);
				btnLevelChildren[count*3-2].gotoAndStop(4);
				btnLevelChildren[count * 3 - 3].gotoAndStop(4);
				btnLevelText = null;
				btnLevelText = new Array<TextField>();
				getTextLevel(buttonsLevel[i]);
				if (i <= 2) {
					btnLevelText[3 - 1].text = "Tuto " + (count);
					btnLevelText[3 - 2].text = "Tuto " + (count);
					btnLevelText[3 - 3].text = "Tuto " + (count);
				} else {
					btnLevelText[3 - 1].text = "Level " + count2;
					btnLevelText[3 - 2].text = "Level " + count2;
					btnLevelText[3 - 3].text = "Level " + count2;
				}
			}

		}
		
		super.init(pEvent);
	}

	public static function getInstance():SelectLevelScreen
	{
		if (instance == null) instance = new SelectLevelScreen();
		return instance;
	}

	public function levelComplete():Void
	{
		nextLevel++;
	}

	private function onBack(pEvent:MouseEvent):Void
	{
		UIManager.addScreen(TitleCard.getInstance());
		Sound.playSoundClick();
	}

	private function onUnlock(pEvent:MouseEvent):Void
	{
		unlockMode = !unlockMode;

		var lLength:UInt = LevelManager.levelDesign.length;

		if (unlockMode)
		{
			for (i in 0...lLength) LevelManager.levelDesign[i].locked = false;
			for (b in btnUnlockChildren)
			{
				b.gotoAndStop(1);
			}
		}
		else {
			for (i in GameManager.lastLevelUnlocked + 1...lLength) LevelManager.levelDesign[i].locked = true;
			for (b in btnUnlockChildren)
			{
				b.gotoAndStop(2);
			}
		}

		UIManager.closeScreens();
		UIManager.addScreen(getInstance());
		Sound.playSoundClick();
	}

	private function onClick(pEvent:MouseEvent):Void
	{
		var lLength:UInt = buttonsLevel.length;
		
		for (i in 0...lLength)
		{
			if (pEvent.target == buttonsLevel[i] && !LevelManager.levelDesign[i].locked)
			{
				nextLevel = i;
				LevelManager.updateCurrentLevel(i);
				LevelManager.score = 0;
				GameManager.restart();
				Hud.getInstance().updateScore(LevelManager.score);
				Sound.playSoundClick();
				break;
			}
		}

	}
	private function getTextLevel(pSimpleButton:DisplayObject):Void
	{
		var lButtonClass:SimpleButton = cast(pSimpleButton, SimpleButton);
		var lContainer: DisplayObjectContainer;
		var lContainer2: DisplayObjectContainer;
		var lText : TextField;
		
		var lState:Int = 3;

		for (i in 0...lState)
		{
			switch i
		{
			case 0:

				lContainer = cast(lButtonClass.upState, DisplayObjectContainer);
					lContainer2 = cast(lContainer.getChildAt(0), DisplayObjectContainer);
					lText = cast(lContainer2.getChildByName("txtLevel"), TextField);
					btnLevelText.push(lText);
				case 1:
					lContainer = cast(lButtonClass.downState, DisplayObjectContainer);
					lContainer2 = cast(lContainer.getChildAt(0), DisplayObjectContainer);

					lText = cast(lContainer2.getChildByName("txtLevel"), TextField);
					btnLevelText.push(lText);

				case 2:

					lContainer = cast(lButtonClass.overState, DisplayObjectContainer);
					lContainer2 = cast(lContainer.getChildAt(0), DisplayObjectContainer);

					lText = cast(lContainer2.getChildByName("txtLevel"), TextField);
					btnLevelText.push(lText);
			}
		}
	}
	private function getChildrenOfLevelButton(pSimpleButton: DisplayObject): Void
	{
		var lButtonClass: SimpleButton = cast(pSimpleButton, SimpleButton);
		var lContainer: DisplayObjectContainer;
		var lChild: MovieClip;

		var lState:Int = 3;

		for (i in 0...lState)
		{
			switch i
		{
			case 0:

				lContainer = cast(lButtonClass.upState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnLevelChildren.push(lChild);

				case 1:

					lContainer = cast(lButtonClass.downState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnLevelChildren.push(lChild);

				case 2:

					lContainer = cast(lButtonClass.overState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnLevelChildren.push(lChild);
			}
		}
	}
	private function getChildrenOfUnlockButton(pSimpleButton: DisplayObject): Void
	{

		var lButtonClass: SimpleButton = cast(pSimpleButton, SimpleButton);
		var lContainer: DisplayObjectContainer;
		var lChild: MovieClip;

		var lState:Int = 3;

		for (i in 0...lState)
		{
			switch i
		{
			case 0:

				lContainer = cast(lButtonClass.upState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnUnlockChildren.push(lChild);

				case 1:

					lContainer = cast(lButtonClass.downState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnUnlockChildren.push(lChild);

				case 2:

					lContainer = cast(lButtonClass.overState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnUnlockChildren.push(lChild);
			}
		}
	}

	override public function destroy():Void
	{
		instance = null;

		var lLength:UInt = buttonsLevel.length - 1;

		for (i in 0...lLength) buttonsLevel[i].removeEventListener(MouseEvent.CLICK, onClick);

		content.getChildByName(BTN_BACK).removeEventListener(MouseEvent.CLICK, onBack);
		content.getChildByName(BTN_UNLOCK).removeEventListener(MouseEvent.CLICK, onUnlock);

		super.destroy();
	}
}