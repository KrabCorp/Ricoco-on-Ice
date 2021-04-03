package com.isartdigital.utils.math.geom;
import openfl.geom.Point;

/**
 * Classe abstraite de vecteur qui permet de gérer les operations élémentaires sur les vecteurs
 * @author Chadi Husser
 */
abstract Vector2(Point) from Point to Point 
{
	public var x(get, set):Float;
	public var y(get, set):Float;
	public var magnitude(get, never):Float;
	public var squaredMagnitude(get, never):Float;
	public var normalized(get, never):Vector2;
	
	public  function new(?pX:Float=0, ?pY:Float=0) {
        this = new Point(pX, pY);
    }
	
	
	/**
	 * Vecteur directeur de l'axe des abcisses (1,0)
	 */
	public static var right(get, null):Vector2;
	
	private static inline function get_right():Vector2 {
		return new Vector2(1, 0);
	}
	
	/**
	 * Vecteur directeur de l'axe des abcisses (0,1)
	 */
	public static var down(get, null):Vector2;
	
	private static inline function get_down():Vector2 {
		return new Vector2(0, 1);
	}
	
	
	/**
	 * Normalise le vecteur
	 * @param	pVector le vecteur à normaliser
	 * @return pVector normalisé
	 */
	public static function normalize(pVector:Vector2) :Vector2 {
		pVector /= pVector.magnitude;
		return pVector;
	}
	
	/**
	 * Réfléchis le vecteur en fonction de la normale d'un segment
	 * @param	pVector le vecteur à réfléchir
	 * @param	pNormal la normale du segment
	 * @return le vecteur réfléchis
	 */
	public static inline function reflect(pVector:Vector2, pNormal:Vector2) : Vector2 {
		return pVector - (2 * dotProduct(pVector, pNormal) * pNormal);
	}
	
	/**
	 * Projecte le vecteur sur une droite
	 * @param	pA un point de la droite
	 * @param	pB un point de la droite
	 * @param	pC le point à projecter
	 * @return le point projeté
	 */
	public static function project(pA:Vector2, pB:Vector2, pC:Vector2) : Vector2 {
		var ab : Vector2 = pB - pA;
		var ac : Vector2 = pC - pA;
		return  pA + ab * (dotProduct(ab, ac) / Math.pow(ab.magnitude, 2));
	}
	
	/**
	 * Crée une interpolation entre deux points
	 * @param	pA premier point
	 * @param	pB second point
	 * @param	pCoeff coefficient de l'interpolation
	 * @return le point interpolé
	 */
	public static function lerp(pA:Vector2, pB:Vector2, pCoeff:Float): Vector2 {
		pCoeff = MathTools.clamp(pCoeff, 0, 1);
		var lResult:Vector2 = new Vector2();
		lResult.x = MathTools.lerp(pA.x, pB.x, pCoeff);
		lResult.y = MathTools.lerp(pA.y, pB.y, pCoeff);
		return lResult;
	}
	
	/**
	 * Retourne le produit scalaire entre deux vecteurs
	 * @param	pA premier vecteur
	 * @param	pB second vecteur
	 * @return le produit scalaire
	 */
	public static inline function dotProduct(pA:Vector2, pB:Vector2) : Float {
		return pA.x * pB.x + pA.y * pB.y;
	}
	
	/**
	 * Retourne la distance entre deux points
	 * @param	pA premier point
	 * @param	pB second point
	 * @return la distance
	 */
	public static function distance(pA:Vector2, pB:Vector2) : Float {
		return Math.sqrt((pB.x - pA.x) * (pB.x - pA.x) + (pB.y - pA.y) * (pB.y - pA.y));
	}
	
	/**
	 * Retourne l'angle entre deux vecteurs
	 * @param	pA premier point
	 * @param	pB second point
	 * @return l'angle entre deux vecteurs
	 */
	public static function angleBetween(pA:Vector2, pB:Vector2) : Float {
		return Math.acos(dotProduct(pA.normalized, pB.normalized));
	}
	
	/**
	 * Indique si deux points sont proches
	 * @param	pA premier point
	 * @param	pB second point
	 * @param	pThreshold la distance seuil à dépasser
	 * @return true si la distance est inférieur au seuil et false sinon
	 */
	public static function isClose(pA:Vector2, pB:Vector2, pThreshold:Float = 0.1) : Bool {
		return distance(pA, pB) < pThreshold;
	}
	
	/* Getter se Setter nécessaire à l'abstraction de la classe point */
	
	private inline function get_x():Float {
		return this.x;
	}
	
	private inline function get_y():Float {
		return this.y;
	}
	
	private inline function set_x(value:Float):Float {
		return this.x  = value;
	}
	
	private inline function set_y(value:Float):Float {
		return this.y  = value;
	}
	
	/* Getter de norme de vecteur et vectuer normalisé */ 
	
	private inline function get_normalized():Vector2 {
		return normalize(clone());
	}
	
	private inline function get_magnitude():Float {
		return Math.sqrt(x * x + y * y);
	}
	
	private inline function get_squaredMagnitude():Float {
		return x * x + y * y;
	}
	
	public function clone() : Vector2 {
		return new Vector2(x, y);
	}
	
	public function setTo(pX:Float, pY:Float) : Void {
		x = pX;
		y = pY;
	}
	
	
	/* Surcharge des opérateurs usuels 
	 * Permet :
	 * d'additioner et soustraire 2 vecteurs
	 * de multiplier un vecteur par un scalaire
	 * de simplifier la comparaison de deux vecteurs
	 */
	
	@:op(A += B)
	public static function addAssign(lhs:Vector2, rhs:Vector2):Vector2 {
		lhs.x += rhs.x;
		lhs.y += rhs.y;
		return lhs;
	}
	
	@:op(A -= B)
	public static function substractAssign(lhs:Vector2, rhs:Vector2):Vector2 {
		lhs.x -= rhs.x;
		lhs.y -= rhs.y;
		return lhs;
	}
	
	@:op(A *= B)
	public static function multiplyAssign(lhs:Vector2, rhs:Float):Vector2 {
		lhs.x *= rhs;
		lhs.y *= rhs;
		return lhs;
	}
	
	@:op(A /= B)
	public static function divideAssign(lhs:Vector2, rhs:Float):Vector2 {
		lhs.x /= rhs;
		lhs.y /= rhs;
		return lhs;
	}
	
	 
	@:op(A * B) @:commutative
	public static function multiplyByFloat(lhs:Vector2, rhs: Float) :Vector2 {
		var temp : Vector2 = lhs.clone();
		temp *= rhs;
		return temp;
	}
	
	@:op(A / B) 
	public static function divideByFloat(lhs:Vector2, rhs: Float) :Vector2 {
		var temp : Vector2 = lhs.clone();
		temp /= rhs;
		return temp;
	}
	
	@:op(A + B)
	public static function add(lhs:Vector2, rhs:Vector2):Vector2 {
		var temp:Vector2 = lhs.clone();
		temp += rhs;
		return temp;
    }
	
	@:op(A - B)
	public static function substract(lhs:Vector2, rhs:Vector2):Vector2 {
		var temp:Vector2 = lhs.clone();
		temp -= rhs;
        return temp;
    }
	
	@:op(-A)
	public static inline function negate(value:Vector2):Vector2 {
        return value * -1;
    }
	
	@:op(A == B)
	public static inline function equals(lhs:Vector2, rhs:Vector2) : Bool {
		return (lhs - rhs).squaredMagnitude < MathTools.EPSILON;
	}
	
}