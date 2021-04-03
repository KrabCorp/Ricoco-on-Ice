package com.isartdigital.utils.game.stateObjects;

import com.isartdigital.utils.game.stateObjects.colliders.Collider;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderData;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.Shape;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Classe de base des objets interactifs ayant plusieurs états graphiques
 * Gère la représentation graphique (renderer) et les conteneurs utiles au gamePlay (collider) qui peuvent être de simples boites de collision ou beaucoup plus
 * suivant l'implémentation faite par le développeur dans les classes filles
 * @author Mathieu ANTHOINE
 * @author Chadi Husser
 * @version 3.0.1
 */
class StateObject<T:DisplayObjectContainer> extends StateMachine
{
	/**
	 * Type de collider utilisé par défaut
	 */
	public static var defaultColliderType:ColliderType = ColliderType.NONE;
	
	/**
	 * Nom par défaut de l'état par défaut
	 */
	public static var defaultStateDefault:String = "";
	
	/**
	 * rendu de l'état courant
	 */
	public var renderer(default,null):T;
	
	/**
	 * Collider de l'état courant
	 */
	public var collider(default,null):DisplayObjectContainer;
	
	/**
	 * suffixe du nom d'export des symboles collider
	 */
	private var COLLIDER_SUFFIX (default,null):String = "collider";	
	
	/**
	 * etat par défaut
	 */
	private var stateDefault(get, never):String;
	
	/**
	 * Nom de l'asset (sert à identifier les textures à utiliser)
	 * Prend le nom de la classe Fille par défaut
	 */
	private var assetName:String;
	
	/**
	 * état en cours
	 */
	private var state:String;
	
	/**
	 * Type de collider
	 * Si colliderType est égal à ColliderType.NONE, aucune collision ne se fait, il n'est pas nécessaire d'avoir une boite de collision définie
	 * Si colliderType est égal à ColliderType.SIMPLE, seul un symbole sert de Collider pour tous les états, son nom d'export etant assetName+"_"+COLLIDER_SUFFIX
	 * Si colliderType est égal à ColliderType.MULTIPLE, chaque state correspond à une boite de collision, chaque state va cherche la boite assetName+"_"+RENDERER_SUFFIX+"_"+COLLIDER_SUFFIX
	 * Si colliderType est égal à ColliderType.SELF, hitBox retourne l'AnimatedSprite renderer
	 */
	private var colliderType(get, never):ColliderType;
	
	/**
	 * l'anim est-elle terminée ?
	 */
	public var isAnimEnded (get, null):Bool;
	
	private function get_isAnimEnded ():Bool {
		return false;
	}
	
	public function new() 
	{
		super();
		setState(stateDefault, true);
	}
	
	/**
	 * défini l'état courant du StateObject
	 * @param	pState nom de l'état (run, walk...)
	 * @param	pLoop l'anim boucle (isAnimEnd sera toujours false) ou pas
	 * @param	pAutoPlay lance l'anim automatiquement
	 * @param	pStart lance l'anim à cette frame
	 */
	public function setState (pState:String, ?pLoop:Bool = false, ?pAutoPlay:Bool=true, ?pStart:UInt = 0): Void {
		
		var lClassName:String = Type.getClassName(Type.getClass(this));
		
		if (state == pState) {
			if (renderer!=null) setBehavior (pLoop,pAutoPlay,pStart);
			return;
		}
		
		if (assetName == null) assetName = lClassName.split(".").pop();
		
		state = pState;
		
		if (renderer == null) {			
			if (colliderType == ColliderType.SELF) {
				if (collider !=null) removeChild(collider);
				collider = null;
			}
			createRenderer();
		} else {
			updateRenderer();
		}
		
		setBehavior(pLoop, pAutoPlay, pStart);

		if (collider == null) {
			if (colliderType == ColliderType.SELF) {
				collider = renderer;
				return;
			} else {
				collider = new DisplayObjectContainer();
				if (colliderType != ColliderType.NONE) createCollider();
			}
			addChild(collider);
		} else if (colliderType == ColliderType.MULTIPLE) {
			removeChild(collider);
			collider = new DisplayObjectContainer();
			createCollider();
			addChild(collider);
		}
	}
	
	/**
	 * Crée le renderer
	 */
	private function createRenderer ():Void {
		#if debug
		renderer.alpha = Config.rendererAlpha;
		#end
		addChild(renderer);
	}
	
	private function get_stateDefault():String
	{
		return defaultStateDefault;
	}
	
	private function get_colliderType():ColliderType
	{
		return defaultColliderType;
	}
	
	/**
	 * Met à jour le renderer
	 */
	private function updateRenderer ():Void {
		
	}
	
	public function setBehavior (?pLoop:Bool = false, ?pAutoPlay:Bool=true, ?pStart:UInt = 0):Void {

	}

	/**
	 * crée le(s) collider(s) de l'état
	 */
	private function createCollider ():Void {
		var lColliderName:String = assetName + "_" + (colliderType == ColliderType.MULTIPLE && state != "" ? state + "_" : "" ) + COLLIDER_SUFFIX;
		var lColliders:Map<String, ColliderData> = StateManager.getCollider(lColliderName);
		
		if (lColliders == null)
			throw 'Collider with name "$lColliderName" not found';
        
		var lChild:Shape;
        var lCollider:ColliderData;
		
		for (lColliderName in lColliders.keys()) {
			lChild = new Shape();
			lChild.graphics.beginFill(0xFF2222);
            lCollider = lColliders[lColliderName];
            
			if (lCollider.type == Collider.Rectangle) {
				lChild.graphics.drawRect(lCollider.x, lCollider.y, lCollider.width, lCollider.height);
			}
			else if (lCollider.type == Collider.Circle) {
				lChild.graphics.drawCircle(lCollider.x, lCollider.y, lCollider.radius);
			}
			else if (lCollider.type == Collider.Point) 
            {
				lChild.graphics.drawCircle(0, 0, 10);
				lChild.x = lCollider.x;
				lChild.y = lCollider.y;
			} 
            else if (lCollider.type == Collider.Ellipse){
				lChild.graphics.drawEllipse(lCollider.x, lCollider.y, lCollider.width, lCollider.height);
            } 
            else {
                trace('Unknow collider type "${lCollider.type}", skipping $lColliderName');
            }
            
			lChild.graphics.endFill();
			
			lChild.name = lColliderName;
			
			collider.addChild(lChild);
		}
		
		#if debug
		collider.alpha = Config.colliderAlpha;
		#else
		collider.alpha = 0;
		#end
	}		
	
	/**
	 * retourne l'identifiant complet de l'animation
	 * @return identifiant
	 */
	private function getID(): String {
		if (state == "") return assetName;
		return assetName+"_" + state;
	}		
	
	/**
	 * met en pause l'anim
	 */
	public function pause ():Void {
		
	}
	
	/**
	 * relance l'anim
	 */
	public function resume ():Void {
		
	}
	
	/**
	 * retourne la zone de hit de l'objet
	 */
	public var hitBox (get, null):DisplayObject;
	 
	private function get_hitBox (): DisplayObject {
		return collider;
		// Si on veut cibler une zone plus précise: return collider.getChildByName("nom d'instance du AnimatedSprite de type Rectangle ou Circle dans Animate");
	}

	/**
	 * retourne un tableau de points de collision dont les coordonnées sont exprimées dans le systeme global
	 */
	public var hitPoints (get, null): Array<Point>;
	 
	private function get_hitPoints (): Array<Point> {
		return null;
		// liste de Points : return [collider.toGlobal(collider.getChildByName("nom d'instance du AnimatedSprite de type Point dans Animate").position,collider.toGlobal(collider.getChildByName("nom d'instance du AnimatedSprite de type Point dans Animate").position];
	}
	
	/**
	 * nettoie le renderer avant sa suppression
	 */
	private function destroyRenderer ():Void {
		removeChild(renderer);
	}
	
	/**
	 * nettoyage et suppression de l'instance
	 */
	override public function destroy (): Void {
		destroyRenderer();
		
        if (collider != renderer) {
			removeChild(collider);
		}
		
        renderer = null;
        collider = null;
		
		super.destroy();
	}
	
}