package com.isartdigital.sokoban.game.sprites;

import com.isartdigital.sokoban.game.mvp.GameManager;
import com.isartdigital.sokoban.game.sprites.iso.IsoGoal;
import openfl.display.MovieClip;
import openfl.events.Event;

/**
 * ...
 * @author AnaelleMncs
 */
class Target extends MovieClip 
{
	public static var list:Array<Target> = new Array<Target>();

	public var isoGoal:IsoGoal;
	public var radar:MovieClip;
	
	public function new() 
	{
		super();
		
		if (list == null) list = new Array<Target>();

		addEventListener(Event.ADDED_TO_STAGE, init);
	}
	
	private function init(pEvent:Event):Void
	{
		removeEventListener(Event.ADDED_TO_STAGE, init);

		list.push(this);
		isoGoal = new IsoGoal();
		addChild(isoGoal);
	}
	
	public function removeGoalAt():Void
	{
		list.splice(list.indexOf(this), 1);
		radar.parent.removeChild(radar);
		parent.removeChild(this);
		
		if (list.length == 0) GameManager.setEndLevel();
	}
	
	public static function destroy():Void
	{
		list = null;
	}
}