package com.isartdigital.utils.system;

import com.isartdigital.utils.game.GameStage;
import openfl.Lib;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import openfl.geom.Rectangle;

#if html5
	import js.Browser;
#end


/**
 * Classe Utilitaire donnant accès à des propriétés du périphérique cible
 * Tous les périphériques ne se comportant pas comme on l'attend, DeviceCapabilities permet de
 * masquer les comportement différents et présenter une facade unique au reste du code
 * @version 0.5.0
 * @author Mathieu ANTHOINE
 * @author Chadi Husser
 */
class DeviceCapabilities
{
	/**
	  * hauteur de la fenetre
	  */
	public static var height (get, never) : UInt;

	private static function get_height ()
	{
		return Lib.current.stage.stageHeight;
	}

	/**
	  * largeur de la fenetre
	  */
	public static var width (get, never) : UInt;

	private static function get_width ()
	{
		return Lib.current.stage.stageWidth;
	}

	/**
	 * Système d'exploitation du Device
	 */
	public static var system (get, never) : System;

	private static var TEXTURE_NO_SCALE(default, never): String = "";
	private static var TEXTURE_HD(default, never): String = "hd";
	private static var TEXTURE_MD(default, never): String = "md";
	private static var TEXTURE_LD(default, never): String = "ld";
	
	public static var textureRatio (default,null):Float = 1;
	public static var textureType (default,null):String = TEXTURE_NO_SCALE;	

	private static function get_system( )
	{

		#if html5

		if ( ~/IEMobile/i.match(Browser.navigator.userAgent)) return System.WINDOWS_MOBILE;
		else if ( ~/iPhone|iPad|iPod/i.match(Browser.navigator.userAgent)) return System.I_OS;
		else if ( ~/BlackBerry/i.match(Browser.navigator.userAgent)) return System.BLACK_BERRY;
		else if ( ~/PlayBook/i.match(Browser.navigator.userAgent)) return System.BB_PLAYBOOK;
		else if ( ~/Android/i.match(Browser.navigator.userAgent)) return System.ANDROID;
		else return System.DESKTOP;

		#elseif android

		return System.ANDROID;

		#elseif ios

		return System.I_OS;

		#else

		return System.DESKTOP;

		#end
	}

	/**
	 * Calcul la dimension idéale du bouton en fonction du device
	 * @return fullscreen ideal size
	 */
	public static function getSizeFactor ():Float
	{
		var lSize:Float=Math.floor(Math.min(width,height));
		if (system == System.DESKTOP) lSize /= 3;
		return lSize;
	}

	/**
	 * retourne un objet Rectangle correspondant aux dimensions de l'écran dans le repère du DisplayObject passé en paramètre
	 * @param pTarget repère cible
	 * @return objet Rectangle
	 */
	public static function getScreenRect(pTarget:DisplayObject):Rectangle
	{

		var lTopLeft:Point = new Point (0, 0);
		var lBottomRight:Point = new Point (width, height);

		lTopLeft = pTarget.globalToLocal(lTopLeft);
		lBottomRight = pTarget.globalToLocal(lBottomRight);

		return new Rectangle(lTopLeft.x, lTopLeft.y, lBottomRight.x - lTopLeft.x, lBottomRight.y - lTopLeft.y);
	}

	private static var texturesRatios : Map<String, Float>;

	/**
	* Défini les ratios de texture
	* @param	pHd ratio texture pour HD
	* @param	pMd ratio texture pour MD
	* @param	pLd ratio texture pour LD
	*/
	public static function init(?pHd:Float = 1, ?pMd:Float = 0.5, ?pLd:Float = 0.25):Void
	{
		texturesRatios = new Map<String, Float>();
		texturesRatios[TEXTURE_HD]= pHd;
		texturesRatios[TEXTURE_MD]= pMd;
		texturesRatios[TEXTURE_LD] = pLd;

		if (Config.data.texture != null && Config.data.texture!="") textureType = Config.data.texture;
		else {
			var lBW:Float = Math.max (Lib.application.window.width, Lib.application.window.height);
			var lBH:Float = Math.min (Lib.application.window.width, Lib.application.window.height);
			var lW:Float = Math.max (GameStage.getInstance().safeZone.width,GameStage.getInstance().safeZone.height);
			var lH:Float = Math.min (GameStage.getInstance().safeZone.width,GameStage.getInstance().safeZone.height);

			var lRatio:Float = Math.min(lBW * Lib.application.window.scale  / lW, lBH * Lib.application.window.scale / lH);

			if (lRatio <= pLd) textureType = TEXTURE_LD;
			else if (lRatio <= pMd) textureType = TEXTURE_MD;
			else textureType = TEXTURE_HD;

		}
		textureRatio = texturesRatios[textureType];

	}

}