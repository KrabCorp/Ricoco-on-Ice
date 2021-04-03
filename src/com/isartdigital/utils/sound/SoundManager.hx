package com.isartdigital.utils.sound;

import com.isartdigital.utils.sound.SoundFX;
import openfl.events.Event;
import openfl.events.EventDispatcher;
/**
 * ...
 * @author Mathieu ANTHOINE
 * @author Chadi Husser
 */
class SoundManager 
{
	
	
	/**
	 * Volume principal
	**/
	public static var mainVolume(default, set) : Float;
	
	private static var soundPath:String = "assets/sounds/";
	
	private static var soundType:String = ".ogg";
	
	private static var sounds :Map<String, SoundFX>;
	
	private static function set_mainVolume(pVolume:Float) :Float {
		for (sound in sounds) {
			sound.volume = pVolume;
		}
		
		mainVolume = pVolume;
		return pVolume;
	}
	
	
	/**
	   Initialise la liste des sfx et musics
	   @param	pJson le fichier sounds.json
	   @param	pGameloopDispatcher le main
	   @return un tableau des chemins d'accès aux sons à charger
	**/
	public static function setupSoundsData(pJson:Dynamic) : Array<String> {
		sounds = new Map<String, SoundFX>();
		
		
		var lPaths:Array<String> = new Array<String>();
		
		var lFiles:Dynamic = Reflect.field(pJson, "files");
		
		var lVolumes : VolumeData = Reflect.field(pJson, "volumes");
		
		trace(lVolumes);
		
		mainVolume = lVolumes.master;
		
		var lPath:String;
		var lSoundData:SoundData;
		
		// FXS
		var lFxs : Dynamic = Reflect.field(lFiles, "fxs");
		
		for (sound in Reflect.fields(lFxs)) {
			lSoundData = Reflect.field(lFxs, sound);
			lPath = getSoundPath(lSoundData.asset);
			lPaths.push(lPath);
			addSound(sound, new SoundFX(lPath, lSoundData.volume * lVolumes.fxs));
		}
		
		// MUSICS
		var lMusic : Dynamic = Reflect.field(lFiles, "musics");
		
		for (sound in Reflect.fields(lMusic)) {
			lSoundData = Reflect.field(lMusic, sound);
			lPath = getSoundPath(lSoundData.asset);
			lPaths.push(lPath);
			addSound(sound, new SoundFX(lPath, lSoundData.volume * lVolumes.musics));
		}
		
		return lPaths;
	}
	
	
	private static function getSoundPath(pPath:String) : String {
		return soundPath + pPath + soundType;
	}
	
	/**
	 * Créé les instances de chaque son et les stock en interne pour les rendre accessible via getSound
	 */
	public static function initSounds():Void{
		for (sound in sounds) {
			sound.setupSound();
		}
	}
	
	/**
	 * ajoute un son à la liste
	 * @param	pName identifiant du son
	 * @param	pSound son
	 */
	private static function addSound (pName:String, pSound:SoundFX):Void {
		sounds.set(pName, pSound);
	}
	
	/**
	 * retourne une référence vers le son par l'intermédiaire de son identifiant
	 * @param	pName identifiant du son
	 * @return le son
	 */
	public static function getSound(pName:String): SoundFX {
		var lSound:SoundFX = sounds.get(pName);
		
		if (lSound == null) throw "\rL'identifiant " + pName + " de son n'existe pas dans la liste de son !"; 
		return lSound;
	}
	
	/**
	 * Stoppe l'intégralité des sons
	 */
	public static function stopSounds():Void{
		for (name in sounds.keys()) {
			sounds[name].stop();
		}		
	}
	
	/**
	 * Détuit l'intégralité des sons
	 */
	public static function destroySounds(pEvent:Event=null): Void {
		for (sound in sounds) {
			trace(sound);
			sound.destroy();
		}	
		sounds = null;
	}
}