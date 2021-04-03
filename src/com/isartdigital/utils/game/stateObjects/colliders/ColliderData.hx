package com.isartdigital.utils.game.stateObjects.colliders;

/**
 * @author Chadi Husser
 */
typedef ColliderData =
{
	var x:Float;	
	var y:Float;	
	var type:Collider;	
	@optional var radius:Float;
	@optional var width:Float;
	@optional var height:Float;
}