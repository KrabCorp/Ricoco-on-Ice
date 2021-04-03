package com.isartdigital.sokoban.ui;

import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.SimpleButton;
import openfl.text.TextField;

/**
 * ...
 * @author Jean VIDREQUIN
 */
class ButtonToTextfield extends SimpleButton 
{

	public function new(upState:DisplayObject=null, overState:DisplayObject=null, downState:DisplayObject=null, hitTestState:DisplayObject=null) 
	{
		super(upState, overState, downState, hitTestState);
		
	}
	
	public static function returnTextFieldUp(pButton : DisplayObject) : TextField
	{
		var lButton : SimpleButton = cast(pButton, SimpleButton);
		var lButtonUpState:DisplayObjectContainer = cast(lButton.upState, DisplayObjectContainer);
		var lButtonUpText : TextField = cast (lButtonUpState.getChildAt(1), TextField);
		return lButtonUpText;
	}
	
	public static function returnTextFieldDown(pButton : DisplayObject) : TextField
	{
		var lButton : SimpleButton = cast(pButton, SimpleButton);
		var lButtonDownState:DisplayObjectContainer = cast(lButton.downState, DisplayObjectContainer);
		var lButtonDownText : TextField = cast (lButtonDownState.getChildAt(1), TextField);
		return lButtonDownText;
	}
	
	public static function returnTextFieldOver(pButton : DisplayObject) : TextField
	{
		var lButton : SimpleButton = cast(pButton, SimpleButton);
		var lButtonOverState:DisplayObjectContainer = cast(lButton.overState, DisplayObjectContainer);
		var lButtonOverText : TextField = cast (lButtonOverState.getChildAt(1), TextField);
		return lButtonOverText;
	}
	
}