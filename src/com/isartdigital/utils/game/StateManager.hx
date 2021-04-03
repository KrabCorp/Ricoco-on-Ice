package com.isartdigital.utils.game;
import com.isartdigital.utils.game.stateObjects.colliders.Collider;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderData;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Manager chargé de gérer des opérations globales sur les StateObjects et les ressources associées
 * @author Mathieu Anthoine
 * @author Chadi Husser
 */
class StateManager 
{
	/**
	 * cache des colliders de tous les StateObject
	 */
	private static var colliders:Map<String, Map<String, ColliderData>> = new Map<String, Map<String, ColliderData>>();
	
	/**
	 * Créer tous les Colliders
	 * @param	pJson Fichier contenant la description des colliders
	 */
	public static function addColliders (pJson:Dynamic): Void {
        var lItem:Dynamic;
		var lObj:ColliderData;
        
		for (lName in Reflect.fields(pJson)) {
			lItem = Reflect.field(pJson, lName);
			colliders[lName] = new Map<String, ColliderData>();			
			
			for (lObjName in Reflect.fields(lItem)) {
				lObj = Reflect.field(lItem, lObjName);
				colliders[lName][lObjName] = lObj;
			}
		}
	}

	/**
	 * Cherche dans le cache général des colliders, celui correspondant au state demandé
	 * @param	pState State de l'instance
	 * @return	le collider correspondant
	 * @return
	 */
	public static function getCollider (pState:String):Map<String, ColliderData> {
		return colliders[pState];
	}
}