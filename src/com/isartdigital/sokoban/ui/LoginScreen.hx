package com.isartdigital.sokoban.ui;
import com.isartdigital.sokoban.game.save.Session;
import com.isartdigital.sokoban.ui.Hud;
import com.isartdigital.sokoban.game.Sound;
import com.isartdigital.utils.ui.AlignType;
import com.isartdigital.utils.ui.UIPositionable;
import haxe.ds.Map;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.events.MouseEvent;
import openfl.net.SharedObject;
import openfl.text.TextField;
import openfl.ui.Keyboard;

/**
 * ...
 * @author DELCENSERIE Kalvin
 */
class LoginScreen extends ScreenTranslate
{
	public static inline var PREFIX_PSEUDO:String = "%RicocoOnIce%";
	/**
	 * instance unique de la classe LoginScreen
	 */
	private static var instance: LoginScreen;
	public static var nickname:String;
	private var loginText:DisplayObject;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): LoginScreen
	{
		if (instance == null) instance = new LoginScreen();
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
		content.getChildByName("btnNext").addEventListener(MouseEvent.CLICK, onClickNext);
		loginText = content.getChildByName("txtZone");
		var lPositionnable:UIPositionable = { item:content.getChildByName("btnNext"), align:AlignType.BOTTOM, offsetY:250};
		positionables.push(lPositionnable);
		lPositionnable = { item:content.getChildByName("background"), align:AlignType.FIT_SCREEN};
		positionables.push(lPositionnable);
	
		loginText.addEventListener(MouseEvent.CLICK, onClick);
		loginText.addEventListener(KeyboardEvent.KEY_UP, onEnter);
	}
	
	private function onClick(pEvent:MouseEvent):Void 
	{
		cast(loginText, TextField).text = "";
	}
	
	private function goToSelectLevel():Void
	{
		var lText:String = cast(loginText, TextField).text;
		
		if (lText == "" || lText == "Enter your username") return;
		
		var r = ~/[^a-zA-Z0-9]/g;		
		nickname = PREFIX_PSEUDO + r.replace(lText, "");
		
		UIManager.addScreen(TitleCard.getInstance());
		Sound.playSoundClick();
		Session.loading(nickname);
	}
	
	private function onEnter(pEvent:KeyboardEvent):Void
	{
		if (pEvent.keyCode == Keyboard.ENTER) goToSelectLevel();
		
	}

	private function onClickNext(pEvent:MouseEvent):Void
	{
		goToSelectLevel();
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		instance = null;
		content.getChildByName("btnNext").removeEventListener(MouseEvent.CLICK, onClickNext);
		loginText.removeEventListener(MouseEvent.CLICK, onClick);
		loginText.removeEventListener(KeyboardEvent.KEY_UP, onEnter);
		super.destroy();
	}
}