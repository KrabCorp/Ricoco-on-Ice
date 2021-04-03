package com.isartdigital.sokoban.ui;

import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.sokoban.game.sprites.movingobject.MovingObject;
import com.isartdigital.sokoban.game.sprites.movingobject.Player;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.sound.SoundManager;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.Localization;
import com.isartdigital.utils.ui.UIPositionable;
import motion.Actuate;
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
class SelectSkinScreen extends ScreenTranslate
{
	static var instance : SelectSkinScreen;

	private function new()
	{
		super();
	}

	override function init(pEvent:Event):Void
	{

		super.init(pEvent);
		content.getChildByName("btnBlack").addEventListener(MouseEvent.CLICK, black);
		content.getChildByName("btnBlue").addEventListener(MouseEvent.CLICK, blue);
		content.getChildByName("btnGreen").addEventListener(MouseEvent.CLICK, green);
		content.getChildByName("btnPink").addEventListener(MouseEvent.CLICK, pink);
		content.getChildByName("btnBack").addEventListener(MouseEvent.CLICK, onBack);

	}
	
	private function onBack(e:MouseEvent):Void 
	{
		UIManager.addScreen(TitleCard.getInstance());
		Sound.playSoundClick();
	}
	
	private function pink(e:MouseEvent):Void 
	{
		MovingObject.skin = 4;
		UIManager.addScreen(TitleCard.getInstance());
		Sound.playSoundClick();
	}
	
	private function green(e:MouseEvent):Void 
	{
		MovingObject.skin = 3;
		UIManager.addScreen(TitleCard.getInstance());
		Sound.playSoundClick();
	}
	
	private function blue(e:MouseEvent):Void 
	{
		MovingObject.skin = 2;
		UIManager.addScreen(TitleCard.getInstance());
		Sound.playSoundClick();
	}
	
	private function black(e:MouseEvent):Void 
	{
		MovingObject.skin = 1;
		UIManager.addScreen(TitleCard.getInstance());
		Sound.playSoundClick();
	}

	public static function getInstance() : SelectSkinScreen
	{
		if (instance == null) instance = new SelectSkinScreen();
		return instance;
	}

	
	override public function destroy():Void
	{
		instance = null;
		super.destroy();
	}
}