package com.isartdigital.utils.game.stateObjects;

import animateAtlasPlayer.core.Animation;
import com.isartdigital.utils.game.stateObjects.StateObject;
import com.isartdigital.utils.loader.GameLoader;
import openfl.display.DisplayObject;

/**
 * ...
 * @author Chadi Husser
 */
class StateAtlas extends StateObject<Animation>
{
	public function new(pAssetName:String = null) 
	{
		assetName = pAssetName;
		super();
	}

	public function removeItem(pId:String) : Void {
		renderer.removeItem(pId);
	}
	
	public function addItem(pId:String, pDisplayObject:DisplayObject) : Void {
		renderer.addItem(pId, pDisplayObject);
	}
	
	override function updateRenderer():Void 
	{
		removeChild(renderer);
		createRenderer();
		super.updateRenderer();
	}
	
	override function setBehavior(?pLoop:Bool = false, ?pAutoPlay:Bool = true, ?pStart:UInt = 0):Void 
	{
		renderer.loop = pLoop;
		renderer.gotoAndStop(pStart);
		if (pAutoPlay) renderer.play();
	}
	
	override function get_isAnimEnded():Bool 
	{
		if (renderer != null && !renderer.loop) return renderer.currentFrame == renderer.totalFrames;
		return false;
	}
	
	override public function pause():Void 
	{
		if (renderer != null) renderer.stop();
	}
	
	override public function resume():Void 
	{
		if (renderer != null) renderer.play();
	}
	
	override function createRenderer():Void 
	{
		var lId:String = getID();
		renderer = GameLoader.getAnimationFromAtlas(lId);
 		super.createRenderer();
	}
	
	override function destroyRenderer():Void 
	{
		renderer.stop();
		super.destroyRenderer();
	}
	
}