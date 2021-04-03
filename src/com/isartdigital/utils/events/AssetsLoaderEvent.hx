package com.isartdigital.utils.events;

import openfl.events.Event;

/**
 * Classe d'Evenements de chargement associée à la classe AssetsLoader
 * @author Mathieu ANTHOINE
 */
class AssetsLoaderEvent extends Event
{

	public static inline var PROGRESS:String = "progress";
	public static inline var CURRENT_COMPLETE:String = "currentComplete";
	public static inline var COMPLETE:String = "complete";

	public static inline var ERROR:String = "error";

	public var description:String;
	public var currentLoaded:Float=-1;
	public var currentTotal:Float=-1;

	public var filesLoaded:Float;
	public var nbFiles:Int;

	public function new (pType:String,pDescription:String="",pCurrent:Dynamic=null,pFilesLoaded:Float=0,pNbFiles:Int=0)
	{
		super(pType);

		description=pDescription;

		if (pCurrent!=null)
		{
			currentLoaded=pCurrent.loaded;
			currentTotal=pCurrent.total;
		}

		filesLoaded = pFilesLoaded;
		nbFiles = pNbFiles;

	}

	/**
	 * Returns a String containing all the properties of the current
	 * instance.
	 * @return A string representation of the current instance.
	 */
	override public function toString():String
	{
		//TODO tout afficher
		if (type == "progress") return formatToString("AssetsLoaderEvent", "type", "currentLoaded", "currentTotal", "filesLoaded");
		//if (type=="progress") return formatToString("AssetsLoaderEvent", "type","description","currentLoaded","currentTotal","filesLoaded","nbFiles","bubbles", "cancelable", "eventPhase");
		else if (type=="error") return formatToString("AssetsLoaderEvent", "type","description","bubbles", "cancelable", "eventPhase");
		else return formatToString("AssetsLoaderEvent", "type","bubbles", "cancelable", "eventPhase");
	}
}
