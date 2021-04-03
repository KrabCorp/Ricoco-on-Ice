package com.isartdigital.utils.debug;

import flash.display.Sprite;
import openfl.display.FPS;
import openfl.events.Event;
import openfl.system.System;
import openfl.text.TextField;

/**
 * Affiche le nombre de frame par seconde, le nombre de drawcall et la mémoire utilisée
 * @author Chadi Husser
 */
class DebugPanel extends Sprite 
{

	private static inline var BYTE_TO_MEGABYTE:Float = 1 / (1024 * 1024);
	private var memoryPeak : Float = 0;
	private var fps : FPS;
	private var memoryText : TextField;
	private var background :Sprite;
	
	public function new() 
	{
		super();
		fps = new FPS(0, 0, 0xFFFFFF);
		fps.__enterFrame(0);
		memoryText = new TextField();
		memoryText.defaultTextFormat = fps.defaultTextFormat;
		memoryText.y = fps.textHeight;
		updateMemory(null);
		
		background = new Sprite();
		addChild(background);
		addChild(memoryText);
		addChild(fps);
			
		background.graphics.beginFill(0x000000);
		background.graphics.drawRect(0, 0, Math.max(memoryText.textWidth, fps.textWidth) + 4,  memoryText.textHeight + fps.textHeight + 2);
		background.graphics.endFill();
		
		scaleX = scaleY = 2;
		addEventListener(Event.ENTER_FRAME, updateMemory);
	}
	
	public function updateMemory(pEvent:Event) : Void {
		var lMemory:Float = Math.round(System.totalMemory * BYTE_TO_MEGABYTE * 100)/100;
		if (lMemory > memoryPeak) memoryPeak = lMemory;
		memoryText.text = "MEM " + lMemory +" MB \nMEM peak " + memoryPeak +" MB";
	}
	
	public function destroy() : Void {
		removeChild(memoryText);
		memoryText = null;
		removeChild(fps);
		fps = null;
		
		removeChild(background);
		background = null;
	}
	
	
}