package com.isartdigital.utils.math;
import openfl.geom.Point;

/**
 * Classe statique utilitaire pour les opérations mathématiques usuelles
 * @author Chadi Husser
 */
class MathTools 
{
	/*
	 * Facteur multiplicateur pour passer de degrés en radians 
	*/
	public static var DEG_TO_RAD (default, never) : Float = Math.PI / 180;
	
	/**
	 * Facteur multiplicateur pour passer de radians en degrés
	 */
	public static var RAD_TO_DEG (default, never) : Float = 180 / Math.PI;
		
	/**
	 * Petite valeur de float 
	 */
	public static var EPSILON (default,never) : Float = 0.00001;
	
	/**
	 * Retourne un nombre aléatoire entre pMin et pMax
	 * @param	pMin
	 * @param	pMax
	 * @return
	 */	
	public static inline function randomRange(pMin:Float, pMax:Float): Float {
		return Math.random() * (pMax - pMin) + pMin;
	}
	
	/**
	 * Retourne le résultat de l'interpolation linéaire de pMin et pMax en fonction du coefficient pCoeff
	 * @param	pMin
	 * @param	pMax
	 * @param	pCoeff (entre 0 et 1)
	 * @return
	 */		 
	public static inline function lerp(pMin:Float, pMax:Float, pCoeff:Float) : Float {
		pCoeff = clamp(pCoeff, 0, 1);
		return pMin * (1 - pCoeff) + pMax * pCoeff;
	}
	
	/**
	 * Retourne pNumber restreint aux bornes pMin et pMax
	 * @param	pNumber
	 * @param	pMin
	 * @param	pMax
	 * @return
	 */
	public static inline function clamp(pValue:Float, pMin:Float, pMax:Float) : Float {
		return Math.min(Math.max(pValue, pMin), pMax);
	}
	
	/**
	 * Retourne un point positionné aléatoirement sur le périmètre d'un cercle de rayon pRadius
	 * @param	pRadius
	 * @return
	 */
	public static inline function randomInsideCircle(pRadius: Float) : Point {
		var lAngle : Float = Math.random() * Math.PI * 2;
		return new Point(pRadius * Math.cos(lAngle), pRadius * Math.sin(lAngle));
	}
	
	/**
	 * Retourne un point positionné aléatoirement dans un cercle de rayon pRadius
	 * @param	pRadius
	 * @return
	 */
	public static inline function randomInsideDisk(pRadius:Float) : Point {
		return randomInsideCircle(Math.random() * pRadius);
	}
}