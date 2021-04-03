package com.isartdigital.sokoban.game.sprites.iso;

import com.isartdigital.utils.game.stateObjects.StateAtlas;

/**
 * ...
 * @author Jean VIDREQUIN
 */
class IsoPlayer extends Iso
{
	
	public function new()
	{
		super("Player");
	}

	override function get_stateDefault():String
	{
		return "IDLE_LEFT";
	}
	
	override function setBehavior(?pLoop:Bool = false, ?pAutoPlay:Bool = true, ?pStart:UInt = 0):Void 
	{
		renderer.loop = pLoop;
		renderer.gotoAndStop(pStart);
		if (pAutoPlay) renderer.play();
	}
	
	override public function get_isAnimEnded():Bool
	{
		return super.get_isAnimEnded();
	}

	override public function setState(pState:String, ?pLoop:Bool = false, ?pAutoPlay:Bool = true, ?pStart:UInt = 0):Void
	{
		super.setState(pState, pLoop, pAutoPlay, pStart);
	}
}