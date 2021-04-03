package com.isartdigital.sokoban.ui;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.ui.Screen;

/**
 * ...
 * @author Chadi Husser
 */
class UIManager
{
	/**
	 * Ajoute un écran dans le conteneur de Screens en s'assurant qu'il n'y en a pas d'autres
	 * @param	pScreen
	 */
	public static function addScreen (pScreen: Screen): Void
	{
		closeScreens();
		GameStage.getInstance().getScreensSprite().addChild(pScreen);
	}

	/**
	 * Supprimer les écrans dans le conteneur de Screens
	 * @param	pScreen
	 */
	public static function closeScreens (): Void
	{
		while (GameStage.getInstance().getScreensSprite().numChildren > 0)
		{
			cast(GameStage.getInstance().getScreensSprite().getChildAt(0), Screen).destroy();
			GameStage.getInstance().getScreensSprite().removeChildAt(0);
		}
	}

	public static function openHud() : Void
	{
		GameStage.getInstance().getHudSprite().addChild(Hud.getInstance());
	}

	public static function closeHud() : Void
	{
		GameStage.getInstance().getHudSprite().removeChild(Hud.getInstance());
	}
}