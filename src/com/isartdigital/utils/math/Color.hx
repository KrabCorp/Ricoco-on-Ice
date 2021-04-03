package com.isartdigital.utils.math;
import com.isartdigital.utils.math.MathTools;

/**
 * Classe utilitaire de couleur rgb
 * @author Chadi Husser
 */
class Color
{
	
	public var r:UInt;
	public var g:UInt;
	public var b:UInt;

	public function new(pR:UInt, pG:UInt, pB:UInt) {
		r = pR;
		g = pG;
		b = pB;
	}
	
	public function toHex() : UInt {
		return rgbToHex(this);
	}
	
	public static function rgbToHex(pRGB:Color) : UInt {
		return pRGB.r << 16 | pRGB.g << 8 | pRGB.b;
	}
	
	public static function hexToRgb(pHex:UInt) : Color {
		return new Color((pHex >> 16) & 0xFF, (pHex >>  8) & 0xFF, pHex & 0xFF);
	}
	
	public static function lerpHex(pA:UInt, pB:UInt, pRatio:Float) : UInt {
		return lerp(hexToRgb(pA), hexToRgb(pB), pRatio).toHex();
	}
	
	public static function lerp(pA:Color, pB:Color, pRatio:Float) : Color {
		
		return new Color(Std.int(MathTools.lerp(pA.r, pB.r, pRatio)),
						 Std.int(MathTools.lerp(pA.g, pB.g, pRatio)),
						 Std.int(MathTools.lerp(pA.b, pB.b, pRatio)));
		
	}
}