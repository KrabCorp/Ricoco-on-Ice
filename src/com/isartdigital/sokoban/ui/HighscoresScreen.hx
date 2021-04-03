package com.isartdigital.sokoban.ui;

import animateAtlasPlayer.core.MovieBehavior;
import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.sokoban.game.save.Saves;
import com.isartdigital.sokoban.game.save.Session;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.UIPositionable;
import haxe.ds.ArraySort;
import openfl.display.MovieClip;
import openfl.events.Event;
import openfl.events.MouseEvent;
import openfl.text.TextField;

/**
 * ...
 * @author DELCENSERIE Kalvin
 */
class HighscoresScreen extends ScreenTranslate
{

	/**
	 * instance unique de la classe HighscoresScreen
	 */
	private static var instance: HighscoresScreen;
	private static var lMovie : MovieClip;
	private static var lChild : TextField;
	public static var playerStats : Array<Int>;
	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): HighscoresScreen
	{
		if (instance == null) instance = new HighscoresScreen();
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
		content.getChildByName("btnBack").addEventListener(MouseEvent.CLICK, onClickBack);
		var lPositionnable:UIPositionable = { item:content.getChildByName("btnBack"), align:AlignType.BOTTOM, offsetY:450};
		positionables.push(lPositionnable);
		
		ranking();
	}
	
	
	public function  ranking () : Void
	{
		Session.ranking();
		for (i in 0...Session.playerHighScore.length) 
		{
			Session.playerHighScore.sort(sortAscendingX);
		}
		
		for (j in 0...9) 
		{
			if (Session.playerHighScore[j] != null) 
			{
				lMovie = cast(content.getChildByName("hs" + j), MovieClip);
				lChild = cast(lMovie.getChildAt(0),TextField);
				lChild.text = Session.playerHighScore[j].name.substr(13) + " : " + Session.playerHighScore[j].totalscore;
			}
		}
	}
	
	private  function sortAscendingX (pA : Dynamic, pB : Dynamic) : Int {
		if ( pA.totalscore > pB.totalscore) return -1;
		if ( pA.totalscore< pB.totalscore) return 1;
		return 0;
	}

	private function onClickBack(pEvent:MouseEvent):Void
	{
		Sound.playSoundClick();
		Sound.fadeOutWinTheme();
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