package com.isartdigital.sokoban.game.save;
import com.isartdigital.sokoban.game.mvp.GameManager;
import com.isartdigital.sokoban.ui.SelectLevelScreen;
import com.isartdigital.sokoban.game.mvp.LevelManager;
import com.isartdigital.sokoban.ui.LoginScreen;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import js.Browser;
import js.html.Storage;
import openfl.net.SharedObject;

/**
 * ...
 * @author DELCENSERIE Kalvin
 */
class Session {
	
	public static var storage : Storage;
	public static var starsArray : Array<Int> = new Array<Int>();
	public static var lScore : Int;
	public static var poeutscore:UInt = 0;
	public static var verification : Bool = false;
	public static var playerHighScore : Array<Dynamic> = new Array<Dynamic>();
	public static var name : String;
	public static var totalscore : Int;
	public static var stars : Array<Int>;
	public static var level : Int;
	public static var lObject : Dynamic;
	public function new() {
		
	}
	public static function nicknameVerification (pString : String) : Bool
	{
		for (i in 0...storage.length) 
		{
			
			if (pString == storage.key(i)) 
			{
				return true;
			}
		}
		return false;
	}
	public static  function loading (pString : String) : Void
	{
		
		storage = Browser.getLocalStorage();
		var lJson : String;
		
		if (nicknameVerification(pString)) {
			lJson = storage.getItem(pString); 
		}
		else 
		{
			lJson = GameLoader.getText("assets/session.json");
			storage.setItem(pString, lJson );
		}
		
		lObject = Json.parse(lJson);
		name = lObject.name;
		totalscore = lObject.totalscore;
		stars = lObject.stars;
		level = lObject.level;
	}
	
	public static function update() :Void
	{
		lScore = calculPlayerScore();
		Reflect.setField(lObject, "name", LoginScreen.nickname);
		Reflect.setField(lObject, "totalscore", lScore);
		Reflect.setField(lObject, "stars", stars);
		Reflect.setField(lObject, "level", level);
		storage.setItem(LoginScreen.nickname, Json.stringify(lObject));
	}
	
	public static function ranking () : Void
	{
		for (i in 0...storage.length) 
		{
			var lparse : Dynamic = Json.parse(storage.getItem(storage.key(i)));
			playerHighScore.push(lparse);
		}
	}
	
	
	public static function  calculPlayerScore() : Int 
	{
		poeutscore += SelectLevelScreen.stars;
		return poeutscore;
	}
}