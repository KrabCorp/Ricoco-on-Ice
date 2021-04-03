package com.isartdigital.sokoban.controller;
import openfl.display.Stage;
import openfl.events.KeyboardEvent;
import openfl.ui.Keyboard;

/**
 * ...
 * @author DELCENSERIE Kalvin
 */
class KeyboardController {

	private var myStage:Stage;
	private var allKeysDown:Array<Bool> = [];

	public var leftDown(get, null):Bool;
	public var rightDown(get, null):Bool;
	public var upDown(get, null):Bool;
	public var downDown(get, null):Bool;

	public function new() {
		myStage = Main.getInstance().stage;
		myStage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		myStage.addEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
	}

	private function onKeyboardUp(pEvent:KeyboardEvent):Void {
		allKeysDown[pEvent.keyCode] = false;
	}

	private function onKeyboardDown(pEvent:KeyboardEvent):Void {
		allKeysDown[pEvent.keyCode] = true;
	}

	public function get_leftDown():Bool {
		return (allKeysDown[Keyboard.LEFT] || allKeysDown[Keyboard.Q]);
	}

	public function get_rightDown():Bool {
		return (allKeysDown[Keyboard.RIGHT] || allKeysDown[Keyboard.D]);
	}

	public function get_upDown():Bool {
		return (allKeysDown[Keyboard.UP] || allKeysDown[Keyboard.Z]);
	}

	public function get_downDown():Bool {
		return (allKeysDown[Keyboard.DOWN] || allKeysDown[Keyboard.S]);
	}

	public function destroy():Void {
		myStage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyboardDown);
		myStage.removeEventListener(KeyboardEvent.KEY_UP, onKeyboardUp);
		myStage = null;
		allKeysDown = null;
	}
}