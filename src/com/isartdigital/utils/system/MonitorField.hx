package com.isartdigital.utils.system;

/**
 * ...
 * @author Chadi Husser
 */
typedef MonitorField = {
	var name : String;
	@:optional var min : Dynamic;
	@:optional var max : Dynamic;
	@:optional var step : Dynamic;
	@:optional var constrain : Dynamic;
	@:optional var isColor : Bool;
	@:optional var onChange : Dynamic->Void;
}