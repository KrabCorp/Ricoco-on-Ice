package com.isartdigital.sokoban.game;
import com.isartdigital.utils.math.MathTools;
import com.isartdigital.utils.sound.SoundFX;
import com.isartdigital.utils.sound.SoundManager;

/**
 * ...
 * @author AnaelleMncs
 */
class Sound 
{
	private static inline var SPEED_FADEIN:Float = 0.001;
	private static inline var SPEED_FADEOUT:Float = 0.0085;
	private static inline var VOLUME_MAX_MAIN_THEME:Float = 0.2;
	private static inline var VOLUME_MAX_ICE_STEPS:Float = 0.3;
	
	private static var menuTheme:SoundFX;
	private static var mainTheme:SoundFX;
	private static var winTheme:SoundFX;
	
	private static var soundClick:SoundFX;
	private static var jingleWin:SoundFX;
	private static var cartSound:SoundFX;
	
	private static var iceStepsSounds:Array<SoundFX>;
	private static var snowStepsSounds:Array<SoundFX>;
	
	private static var isPlayinhMaintTheme:Bool = false;
	
	public static function initPropertySoundFX():Void
	{
		menuTheme	= SoundManager.getSound("iceCaveMusic");
		mainTheme	= SoundManager.getSound("8bitIceCave");
		winTheme	= SoundManager.getSound("winFinal");
		
		soundClick	= SoundManager.getSound("iceSteps0");
		jingleWin	= SoundManager.getSound("winJingle");
		
		cartSound	= SoundManager.getSound("cart");
		
		iceStepsSounds	= [SoundManager.getSound("iceSteps0"), SoundManager.getSound("iceSteps1"),
						SoundManager.getSound("iceSteps2"), SoundManager.getSound("iceSteps3")];
						
		snowStepsSounds	= [SoundManager.getSound("snowSteps0"), SoundManager.getSound("snowSteps1"),
						SoundManager.getSound("snowSteps2"), SoundManager.getSound("snowSteps3")];
	}
	
	public static function fadeInMenuTheme():Void
	{
		if (isPlayinhMaintTheme) return;
		
		menuTheme.fadeIn(SPEED_FADEIN);
		isPlayinhMaintTheme = true;
	}
	
	public static function fadeOutMenuTheme():Void
	{
		menuTheme.fadeOut(SPEED_FADEOUT);
		isPlayinhMaintTheme = false;		
	}
	
	public static function fadeInMainTheme():Void
	{
		mainTheme.fadeIn(SPEED_FADEIN, VOLUME_MAX_MAIN_THEME);
	}
	
	public static function fadeOutMainTheme():Void
	{
		mainTheme.fadeOut(SPEED_FADEOUT);
	}
	
	public static function fadeInWinTheme():Void
	{
		winTheme.fadeIn(SPEED_FADEIN, VOLUME_MAX_MAIN_THEME);
	}
	
	public static function fadeOutWinTheme():Void
	{
		winTheme.fadeOut(SPEED_FADEOUT);
	}
	
	public static function playJingleWin():Void
	{
		jingleWin.start();
	}
	
	public static function playSoundClick():Void
	{
		soundClick.start();
	}
	
	public static function playCartSound():Void
	{
		cartSound.volume = 1.5;
		cartSound.start();
	}
	
	public static function playRandomIceSteps():Void
	{
		var lRandomIndex:Float	= MathTools.randomRange(0, iceStepsSounds.length);
		var lSound:SoundFX		= iceStepsSounds[Math.floor(lRandomIndex)];
		lSound.start();
		lSound.volume = VOLUME_MAX_ICE_STEPS;
	}
	
	public static function playRandomSnowSteps():Void
	{
		var lRandomIndex:Float	= MathTools.randomRange(0, snowStepsSounds.length);
		var lSound:SoundFX		= snowStepsSounds[Math.floor(lRandomIndex)];
		lSound.start();
		lSound.volume = VOLUME_MAX_ICE_STEPS;
	}
}