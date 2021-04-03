package com.isartdigital.utils.debug;

import com.isartdigital.utils.Config;
import com.isartdigital.utils.game.GameStage;
import com.isartdigital.utils.math.MathTools;
import openfl.display.Shape;
import openfl.events.Event;
import openfl.geom.Point;

/**
 * Classe de Debug
 * @author Chadi HUSSER
 */
class Debug
{

	/**
	 * instance de DebugPanel
	 */
	private static var debugPanel:DebugPanel;

	/**
	 * instance de Shape gerant l'affichage des vecteurs, lignes et points
	 */
	private static var debugShape:Shape;

	public static function init():Void
	{
		if (Config.fps)
		{
			debugPanel = new DebugPanel();
			GameStage.getInstance().addChild(debugPanel);
			GameStage.getInstance().addEventListener(Event.RESIZE, onResize);
			onResize();
		}

		debugShape = new Shape();
		GameStage.getInstance().addChild(debugShape);
	}

	/**
		 * Dessine un point
		 * @param	pPosition la position du point
		 * @param	pColor la couleur du point
		 */
	public static function drawPoint(pPosition:Point, pColor:UInt = 0xff0000) : Void
	{
		debugShape.graphics.lineStyle();
		debugShape.graphics.beginFill(pColor);
		debugShape.graphics.drawCircle(pPosition.x, pPosition.y, 5);
		debugShape.graphics.endFill();
	}

	/**
	 * Dessine une ligne entre 2 points
	 * @param	pStart position de depart du segment
	 * @param	pEnd position d'arrivee du segment
	 * @param	pColor couleur du segment
	 */
	public static function drawLine(pStart:Point, pEnd:Point, pColor:UInt = 0xff0000) : Void
	{
		debugShape.graphics.lineStyle(3, pColor);
		debugShape.graphics.moveTo(pStart.x, pStart.y);
		debugShape.graphics.lineTo(pEnd.x, pEnd.y);
	}

	/**
	 * Desinne un vecteur a partir d'une origine
	 * @param	pOrigin origine du vecteur
	 * @param	pVector vecteur a dessiner
	 * @param	pColor couleur du vecteur
	 */
	public static function drawVector(pOrigin:Point, pVector:Point, pColor:UInt = 0xff0000) : Void
	{
		var lEndPosition:Point = pOrigin.add(pVector);
		drawLine(pOrigin, lEndPosition, pColor);
		var lAngle:Float = 150 * MathTools.DEG_TO_RAD;
		var lLength:Float = 10;
		var lStartAngle:Float = Math.atan2(pVector.y, pVector.x);

		var lDirection:Point = Point.polar(lLength, lStartAngle + lAngle);
		var lPos:Point = lEndPosition.add(lDirection);

		debugShape.graphics.lineTo(lPos.x, lPos.y);

		debugShape.graphics.moveTo(lEndPosition.x, lEndPosition.y);

		lDirection = Point.polar(lLength, lStartAngle - lAngle);
		debugShape.graphics.lineTo(lEndPosition.x + lDirection.x, lEndPosition.y + lDirection.y);
	}

	/**
	 * Nettoie tout le debug
	 */
	public static function clear() : Void
	{
		debugShape.graphics.clear();
	}

	public static function reset (): Void
	{
		debugShape.parent.removeChild(debugShape);
		debugShape = null;

		if (Config.fps)
		{
			GameStage.getInstance().removeChild(debugPanel);
			GameStage.getInstance().removeEventListener(Event.RESIZE, onResize);
			debugPanel = null;
		}
	}

	private static function onResize(pEvent:Event = null) : Void
	{
		var lPos:Point =  GameStage.getInstance().globalToLocal(new Point());
		debugPanel.x = lPos.x;
		debugPanel.y = lPos.y;

		debugPanel.scaleX = 1 / GameStage.getInstance().scaleX;
		debugPanel.scaleY = 1 / GameStage.getInstance().scaleY;
	}

}