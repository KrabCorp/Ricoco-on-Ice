package com.isartdigital.sokoban.ui;

import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.sokoban.game.sprites.movingobject.Player;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.Localization;
import js.html.svg.Number;
import motion.Actuate;
import motion.easing.Back;
import motion.easing.Quart;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.geom.Point;

/**
 * ...
 * @author Chadi Husser
 */
class TitleCard extends ScreenTranslate
{
	static var instance : TitleCard;
	private static var isMute:Bool = false;
	private var btnSoundChildren:Array<MovieClip>;
	private var btnLocaChildren:Array<MovieClip>;

	private function new()
	{
		super();
		Sound.fadeInMenuTheme();
	}

	override function init(pEvent:Event):Void
	{

		super.init(pEvent);
		var lBtnSound:DisplayObject = content.getChildByName("btnSound");
		var lBtnLoca:DisplayObject = content.getChildByName("btnLoca");
		var lBtnPlay:DisplayObject = content.getChildByName("btnPlay");
		var lBtnHelp:DisplayObject = content.getChildByName("btnHelp");
		var lBtnHigh:DisplayObject = content.getChildByName("btnHigh");
		var lBtnSkin:DisplayObject = content.getChildByName("btnSkin");
		
		lBtnSkin.addEventListener(MouseEvent.CLICK, onClickSkin);
		lBtnPlay.addEventListener(MouseEvent.CLICK, onClickPlay);
		lBtnHelp.addEventListener(MouseEvent.CLICK, onClickHelp);
		lBtnHigh.addEventListener(MouseEvent.CLICK, onClickHigh);
		lBtnLoca.addEventListener(MouseEvent.CLICK, onClickLoca);
		lBtnSound.addEventListener(MouseEvent.CLICK, onClickSound);

		//var lPositionnable:UIPositionable = { item:content.getChildByName("btnPlay"), align:AlignType.BOTTOM, offsetY:550};
		//positionables.push(lPositionnable);
		//lPositionnable = { item:content.getChildByName("background"), align:AlignType.FIT_SCREEN};
		//positionables.push(lPositionnable);
		
		var lCoordY:Float		= - GameStage.getInstance().safeZone.height / 1.3;
		var lCoordYBis:Float	= GameStage.getInstance().safeZone.width / 1.1;
		
		var lDuration:Float = 0.47;
		var lTotalDuration:Float = 0;
		
		var lCoord:Point = new Point(lBtnSound.x, lBtnSound.y);
		lBtnSound.y = lCoordY;
		lBtnLoca.y = lBtnSound.y;
		lBtnSkin.alpha = 0;
		Actuate.tween(lBtnSkin, lDuration, {alpha:1});
		Actuate.tween(lBtnSound, lDuration, {x: lCoord.x, y: lCoord.y}).ease(Back.easeOut);
		
		lCoord.x = lBtnLoca.x;
		Actuate.tween(lBtnLoca, lDuration, {x: lCoord.x, y: lCoord.y}).ease(Back.easeOut);
		lTotalDuration += lDuration;
		
		lCoord.setTo(lBtnPlay.x, lBtnPlay.y);
		lBtnPlay.y = lCoordY;
		Actuate.tween(lBtnPlay, lDuration, {x: lCoord.x, y: lCoord.y}).ease(Back.easeOut).delay(lTotalDuration);
		
		lCoord.setTo(lBtnHigh.x, lBtnHigh.y);
		lBtnHigh.x = - lCoordYBis;
		Actuate.tween(lBtnHigh, lDuration, {x: lCoord.x, y: lCoord.y}).ease(Back.easeOut).delay(lTotalDuration);
		lCoord.x = lBtnHelp.x;
		lBtnHelp.x = lCoordYBis;
		Actuate.tween(lBtnHelp, lDuration, {x: lCoord.x, y: lCoord.y}).ease(Back.easeOut).delay(lTotalDuration);
		lCoord.setTo(lBtnSkin.x, lBtnSkin.y);
		lBtnSkin.y = lCoordY;
		Actuate.tween(lBtnSkin,lDuration,{x: lCoord.x, y: lCoord.y}).ease(Back.easeOut).delay(lTotalDuration);
		getChildrenOfSoundButton(lBtnSound);
		getChildrenOfLocaButton(lBtnLoca);
		
		if (Localization.english)
		{
			for (b in btnLocaChildren)
			{
				b.gotoAndStop(2);
			}
		}
		else
		{
			for (b in btnLocaChildren)
			{
				b.gotoAndStop(1);
			}
		}
		
		if (isMute)
		{
			for (a in btnSoundChildren)
			{
				a.gotoAndStop(2);
			}
		}
		else
		{
			for (a in btnSoundChildren)
			{
				a.gotoAndStop(1);
			}
		}


	}

	private function onClickSkin(e:MouseEvent):Void 
	{
		UIManager.addScreen(SelectSkinScreen.getInstance());
		Sound.playSoundClick();
	}

	public static function getInstance() : TitleCard
	{
		if (instance == null) instance = new TitleCard();
		return instance;
	}

	private function onClickPlay(pEvent:MouseEvent) : Void
	{
		UIManager.addScreen(SelectLevelScreen.getInstance());
		Sound.playSoundClick();
	}

	private function onClickHelp(pEvent:MouseEvent):Void
	{
		Sound.playSoundClick();
		UIManager.addScreen(HelpScreen.getInstance());
	}

	private function onClickHigh(pEvent:MouseEvent):Void
	{
		Sound.playSoundClick();
		UIManager.addScreen(HighscoresScreen.getInstance());
	}

	private function onClickLoca(pEvent:MouseEvent):Void
	{
		Localization.english = !Localization.english;
		UIManager.closeScreens();
		UIManager.addScreen(getInstance());
		
		Sound.playSoundClick();

	}
	private function onClickSound(pEvent:MouseEvent):Void
	{
		
		stopAllMovieClips();
		isMute = !isMute;
		
		if (isMute)
		{
			for (a in btnSoundChildren)
			{
				a.gotoAndStop(2);
			}
			Sound.fadeOutMenuTheme();
			SoundManager.mainVolume = 0;
		}
		else
		{
			for (a in btnSoundChildren)
			{
				a.gotoAndStop(1);
			}
			SoundManager.mainVolume = 1;
			Sound.fadeInMenuTheme();
		}
	}

	private function getChildrenOfSoundButton(pSimpleButton: DisplayObject): Void
	{
		btnSoundChildren = new Array<MovieClip>();
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
					btnSoundChildren.push(lChild);

				case 1:

					lContainer = cast(lButtonClass.downState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnSoundChildren.push(lChild);

				case 2:

					lContainer = cast(lButtonClass.overState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnSoundChildren.push(lChild);
			}
		}
	}
	
	private function getChildrenOfLocaButton(pSimpleButton: DisplayObject): Void
	{
		btnLocaChildren = new Array<MovieClip>();
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
					btnLocaChildren.push(lChild);

				case 1:

					lContainer = cast(lButtonClass.downState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnLocaChildren.push(lChild);

				case 2:

					lContainer = cast(lButtonClass.overState, DisplayObjectContainer);
					lChild = cast(lContainer.getChildAt(0), MovieClip);
					btnLocaChildren.push(lChild);
			}
		}
	}
	override public function destroy():Void
	{
		instance = null;
		content.getChildByName("btnPlay").removeEventListener(MouseEvent.CLICK, onClickPlay);
		content.getChildByName("btnHelp").removeEventListener(MouseEvent.CLICK, onClickHelp);
		content.getChildByName("btnHigh").removeEventListener(MouseEvent.CLICK, onClickHigh);
		content.getChildByName("btnLoca").removeEventListener(MouseEvent.CLICK, onClickLoca);
		content.getChildByName("btnSound").removeEventListener(MouseEvent.CLICK, onClickSound);
		super.destroy();
	}
}