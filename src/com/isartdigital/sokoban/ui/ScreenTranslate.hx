package com.isartdigital.sokoban.ui;

import com.isartdigital.utils.ui.Localization;
import com.isartdigital.utils.ui.Screen;
import openfl.display.DisplayObject;
import openfl.events.Event;

/**
 * ...
 * @author Jean VIDREQUIN
 */
class ScreenTranslate extends Screen 
{
	public static var english : Bool = true;
	
	public function new(?pLibrary:String="ui") 
	{
		super(pLibrary);
		
	}
	override function init(pEvent:Event):Void 
	{
		super.init(pEvent);
		Localization.getScreenElements(content);
		Localization.translate(Localization.english);
		onResize();
	}
	override public function destroy():Void 
	{
		Localization.destroy();
		super.destroy();
		
	}
	
}