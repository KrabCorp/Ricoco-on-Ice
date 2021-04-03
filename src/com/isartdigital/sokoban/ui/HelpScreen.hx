package com.isartdigital.sokoban.ui;

import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.UIPositionable;
import openfl.events.MouseEvent;

/**
 * ...
 * @author DELCENSERIE Kalvin
 */
class HelpScreen extends ScreenTranslate
{

	/**
	 * instance unique de la classe HelpScreen
	 */
	private static var instance: HelpScreen;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): HelpScreen
	{
		if (instance == null) instance = new HelpScreen();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new(?pLibrary:String="ui")
	{
		super(pLibrary);

		content.getChildByName("btnBack").addEventListener(MouseEvent.CLICK, onClickBack);

		//var lPositionnable:UIPositionable = { item:content.getChildByName("btnBack"), align:AlignType.BOTTOM, offsetY:450};
		//positionables.push(lPositionnable);
		//lPositionnable = { item:content.getChildByName("background"), align:AlignType.FIT_SCREEN};
		//positionables.push(lPositionnable);

	}

	private function onClickBack(pEvent:MouseEvent):Void
	{
		Sound.playSoundClick();
		UIManager.addScreen(TitleCard.getInstance());
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		instance = null;
		content.getChildByName("btnBack").removeEventListener(MouseEvent.CLICK, onClickBack);
		super.destroy();
	}

}