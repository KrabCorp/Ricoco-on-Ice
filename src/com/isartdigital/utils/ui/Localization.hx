package com.isartdigital.utils.ui;
import com.isartdigital.sokoban.ui.ButtonToTextfield;
import com.isartdigital.sokoban.ui.LocalizationLabel;
import com.isartdigital.utils.loader.GameLoader;
import haxe.Json;
import js.html.TextEncoder;
import openfl.display.DisplayObject;
import openfl.display.DisplayObjectContainer;
import openfl.display.MovieClip;
import openfl.display.SimpleButton;
import openfl.text.TextField;

/**
 * ...
 * @author Jean VIDREQUIN
 */
class Localization
{
	private static var labelList : Array<TextField>;
	public static var english : Bool;
	public function new()
	{

	}

	public static function translate(pBool : Bool) : Void
	{

		var localizationData:String = GameLoader.getText("assets/localisation.json");
		var localizationObject:Dynamic = Json.parse(localizationData);
		var translation : LocalizationLabel;
		for (i in 0...labelList.length)
		{
			if (labelList[i] == null) labelList.remove(labelList[i]);
			if (labelList[i] != null)
			{
				var lText : String = labelList[i].text, String;
				trace (lText);
				lText = lText.substr(0, labelList[i].length - 1);
				if (pBool)
				{
					translation = Reflect.field(localizationObject, lText);
					labelList[i].text = translation.fr;

				}
				else
				{
					translation = Reflect.field(localizationObject, lText);
					labelList[i].text = translation.en;
				}
			}
		}
	}

	public static function getScreenElements (pContent : MovieClip) : Void
	{
		labelList = new Array<TextField>();
		for (i in 0...pContent.numChildren)
		{
			var lChildren : DisplayObject = pContent.getChildAt(i);
			if (Std.isOfType(lChildren, TextField))
			{
				if (pContent.getChildAt(i) != pContent.getChildByName("btnHigh"))
				{
					labelList.push(cast(lChildren, TextField));
				}
			}
			else if (Std.isOfType(lChildren, SimpleButton))
			{
				if (pContent.getChildAt(i) != pContent.getChildByName("btnHigh"))
				{
					var textUp : TextField = ButtonToTextfield.returnTextFieldUp(lChildren);

					var textDown : TextField = ButtonToTextfield.returnTextFieldDown(lChildren);
					var textOver : TextField = ButtonToTextfield.returnTextFieldOver(lChildren);

					labelList.push(textUp);

					labelList.push(textDown);
					labelList.push(textOver);
				}
			}
		}
	}

	public static function destroy () : Void
	{
		for (i in labelList)
		{
			labelList.remove(i);
		}
	}

}