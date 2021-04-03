package com.isartdigital.utils.ui;

import com.isartdigital.utils.game.GameObject;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.system.DeviceCapabilities;
import com.isartdigital.utils.ui.UIPositionable;
import openfl.display.DisplayObject;
import openfl.events.Event;
import openfl.geom.Point;
import openfl.geom.Rectangle;

/**
 * Base de tous les conteneurs d'interface
 * @author Mathieu ANTHOINE
 */
class UIComponent extends GameObject
{

	private var positionables:Array<UIPositionable> = [];
	
	private var isOpened:Bool;
	
	private var componentName:String;

	public function new(pID:String=null) 
	{
		super();
	}
	
	public function open (): Void {
		if (isOpened) return;
		isOpened = true;
		GameStage.getInstance().addEventListener(Event.RESIZE, onResize);
		onResize();
	}

	
	public function close ():Void {
		if (!isOpened) return;
		isOpened = false;
		destroy();
	}

	/**
	 * déclenche le positionnement des objets
	 * @param pEvent
	 */
	private function onResize (pEvent:Event = null): Void {
		for (lObj in positionables) {
			if (lObj.update) {
				if (lObj.align==AlignType.TOP || lObj.align==AlignType.TOP_LEFT || lObj.align==AlignType.TOP_RIGHT) {
					lObj.offsetY = parent.y + lObj.item.y;
				} else if (lObj.align==AlignType.BOTTOM || lObj.align==AlignType.BOTTOM_LEFT || lObj.align==AlignType.BOTTOM_RIGHT) {	
					lObj.offsetY = GameStage.getInstance().safeZone.height - parent.y - lObj.item.y;
				}
				
				if (lObj.align==AlignType.LEFT || lObj.align==AlignType.TOP_LEFT || lObj.align==AlignType.BOTTOM_LEFT) {
					lObj.offsetX = parent.x + lObj.item.x;
				} else if (lObj.align==AlignType.RIGHT || lObj.align==AlignType.TOP_RIGHT || lObj.align==AlignType.BOTTOM_RIGHT) {	
					lObj.offsetX = GameStage.getInstance().safeZone.width - parent.x - lObj.item.x;
				}
				
				lObj.update = false;
			}
			
			setPosition(lObj.item, lObj.align, lObj.offsetX, lObj.offsetY);
		}
	}
	
	/**
	* 
	* @param	pTarget DisplayObject à positionner
	* @param	pPosition type de positionnement
	* @param	pOffsetX décalage en X (positif si c'est vers l'interieur de la zone de jeu sinon en négatif)
	* @param	pOffsetY décalage en Y (positif si c'est vers l'interieur de la zone de jeu sinon en négatif)
	*/
	static public function setPosition (pTarget:DisplayObject, pPosition:AlignType, pOffsetX:Float = 0, pOffsetY:Float = 0): Void {
				
		var lScreen:Rectangle = DeviceCapabilities.getScreenRect(pTarget.parent);
		
		var lTopLeft:Point = new Point (lScreen.x, lScreen.y);
		var lBottomRight:Point = new Point (lScreen.x+lScreen.width,lScreen.y+lScreen.height);
		
		if (pPosition == AlignType.TOP || pPosition == AlignType.TOP_LEFT || pPosition == AlignType.TOP_RIGHT) pTarget.y = lTopLeft.y + pOffsetY;
		if (pPosition == AlignType.BOTTOM || pPosition == AlignType.BOTTOM_LEFT || pPosition == AlignType.BOTTOM_RIGHT) pTarget.y = lBottomRight.y - pOffsetY;
		if (pPosition == AlignType.LEFT || pPosition == AlignType.TOP_LEFT || pPosition == AlignType.BOTTOM_LEFT) pTarget.x = lTopLeft.x + pOffsetX;
		if (pPosition == AlignType.RIGHT || pPosition == AlignType.TOP_RIGHT || pPosition == AlignType.BOTTOM_RIGHT) pTarget.x = lBottomRight.x - pOffsetX;
		
		if (pPosition ==  AlignType.FIT_WIDTH || pPosition ==  AlignType.FIT_SCREEN) {
			pTarget.x = lTopLeft.x;
			untyped pTarget.width = lBottomRight.x - lTopLeft.x;
		}
		if (pPosition ==  AlignType.FIT_HEIGHT || pPosition ==  AlignType.FIT_SCREEN) {
			pTarget.y = lTopLeft.y;
			untyped pTarget.height = lBottomRight.y - lTopLeft.y;
		}
		
		
	}
	
	/**
	 * nettoie l'instance
	 */
	override public function destroy (): Void {
		GameStage.getInstance().removeEventListener(Event.RESIZE, onResize);
		super.destroy();
	}
	
}