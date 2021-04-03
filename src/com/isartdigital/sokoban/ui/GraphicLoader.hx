package com.isartdigital.sokoban.ui;

import com.isartdigital.utils.ui.Screen;
import openfl.display.DisplayObject;
import openfl.display.Loader;
import openfl.events.Event;
import openfl.events.IOErrorEvent;
import openfl.events.ProgressEvent;
import openfl.utils.Assets;

/**
 * ...
 * @author Chadi Husser
 */
class GraphicLoader extends Screen
{
	private var mcFill:DisplayObject;

	private static var instance:GraphicLoader;

	public static function getInstance():GraphicLoader
	{
		if (instance == null) instance = new GraphicLoader();
		return instance;
	}

	private function new()
	{
		super("loader");
	}

	override function init(pEvent:Event):Void
	{
		super.init(pEvent);
		mcFill = content.getChildByName("mcFill");
	}

	/**
	   Ajuste le progrès de la barre de chargement
	   @param	pProgress progrès compris entre 0 et 1
	**/
	public function setProgress(pProgress:Float) : Void
	{
		mcFill.scaleX = pProgress;
	}

	override public function destroy():Void
	{
		instance = null;
		super.destroy();
	}
}