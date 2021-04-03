package com.isartdigital.utils.sound;

import com.isartdigital.utils.loader.GameLoader;
import openfl.display.Stage;
import openfl.Lib;
import openfl.events.Event;
import openfl.events.EventDispatcher;
import openfl.media.Sound;
import openfl.media.SoundChannel;
import openfl.media.SoundTransform;


/**
 * Classe simplifiée pour la manipulation de sons contenus dans des swfs chargés (pas de son externes)
 * todo : prendre ne compte le json sound.json pour déterminer les volumes max par son
 * @author Mathieu ANTHOINE
 * @author Fabien Sayer
 * @author Chadi Husser
 */
class SoundFX extends EventDispatcher
{
	/**
	 * vitesse du fade de volume par frame par défaut
	 */
	public static inline var FADE_SPEED:Float = 0.005;
	
	/**
	 * vitesse du fade de volume par frame
	 */
	private var fadeSpeed:Float;
	
	/**
	 * son manipulé par la classe SoundFX
	 */
	private var sound:Sound;
	
	/**
	 * canal du son interne
	 */
	private var channel:SoundChannel;
	
	/**
	 * position de la lecture
	 */
	private var position:Int = 0;
	
	/**
	 * volume (valeur plus précise du volume que celle stockée par channel)
	 */
	public var volume(default, set):Float;
	
	/**
	 * Toggle pause / resume
	 */
	private var isPlaying:Bool = false;
	
	/**
	 * Loop, si 0 considère comme répétition infinie
	 */
	private var loops:Int = 0;
	
	/**
	 * Point de départ du son en millisecondes
	 */
	private var startTime:Int = 0;
	
	/**
	 * Volume initial
	 */
	private var initialVolume(default, null):Float;
	
	/**
	 * Volume que le fadeIn doit atteindre
	 */
	private var fadeInTargetedVolume:Float;
	
	/**
	 * Chemin d'accès vers le sons
	**/
	private var soundPath:String;
	
	public function new(pName:String, pVolume:Float) 
	{
		soundPath 	  = pName;
		initialVolume = volume = pVolume;
		super();
	}
	
	public function setupSound() : Void {
		sound = GameLoader.getSound(soundPath);
	}
	
	private var length(get, never):Float;
	
	/**
	 * retourne la longueur du son
	 */
	private function get_length ():Float {
		return sound.length;
	}
	
	/**
	 * Lance la lecture du son, si le son est déjà en lecture le stop d'abord
	 * @param	pStartTime position de départ en millisecondes
	 * @param	pLoops nombre de répétitions, 0 = infinie
	 */
	public function start (pStartTime:Int = 0, pLoops:Int = 1):Void {
		startTime = pStartTime;
		loops 	  = pLoops;
		isPlaying = true;
		channel   = sound.play (pStartTime, pLoops, new SoundTransform(volume * SoundManager.mainVolume));
		if (channel == null)
			throw "you are trying to play too many time the same sound in a short time";
		
		position  = Std.int(channel.position);
		
		if (loops == 1) channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		else channel.addEventListener(Event.SOUND_COMPLETE, onLoop);
	}

	/**
	 * Stoppe le son (retour à 0)
	 */
	public function stop ():Void {
		if (channel == null) return;
		
		channel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
		
		var lStage:Stage = Lib.current.stage;
		lStage.removeEventListener(Event.ENTER_FRAME, doFadeIn);
		lStage.removeEventListener(Event.ENTER_FRAME, doFadeOut);
		channel.stop();
		
		isPlaying = false;
	}
	
	/**
	 * Joue le son en boucle infinie
	 * @param	pStartTime position de départ en millisecondes
	 */
	public function loop (pStartTime:Int = 0):Void {
		loops = 0;
		start (pStartTime, 0);
	}
	
	/**
	 * Evenement à chaque boucle de son, n'est pas émis si son joué qu'une fois.
	 * @param	pEvent
	 */
	private function onLoop (pEvent:Event): Void {
		loops--;
		
		if (loops == 1 ){
			channel.removeEventListener(Event.SOUND_COMPLETE, onLoop);
			channel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
			start(startTime, loops);
		}
		
		else loop(startTime);
	}
	
	/**
	 * Met le son en pause
	 */
	public function pause ():Void {
		if (channel == null) return;
		
		position = Std.int(channel.position);
		stop();
	}
	
	/**
	 * Relance le son (un son relancé par resume sera lancé en boucle infinie car il n'est pas possible de connaitre le nombre de boucle déjà executées)
	 */
	public function resume ():Void {
		start(position, loops);
	}
	
	/**
	 * Alterne pause et resume
	 */
	public function togglePauseResume ():Void {
		isPlaying ? pause() : resume();
	}

	/**
	 * volume du son
	 */
	private function set_volume (pVolume:Float):Float {
		volume = pVolume;
		
		if (channel != null) {
			
			var lSoundTransform:SoundTransform = new SoundTransform(volume * SoundManager.mainVolume);
			channel.soundTransform = lSoundTransform;
			
			
		}
		
		return pVolume;
	}
	
	/**
	 * Lance un fadeIn depuis le volume actuel jusqu'à pTargetedVolume
	 * @param   pFadeSpeed Incrément de volume à chaque frame (0.005 donne volume += 0.3/seconde à une cadence de 60 fps)
	 * @param   pTargetedVolume Volume sonore à atteindre, si inférieur à 0, prendra pour valeur le volume initial mis en place dans sound.json
	 * @param	pStartTime position de départ en millisecondes, 0 par défaut
	 * @param	pLoops nombre de répétitions, 0 = infinie
	 */
	public function fadeIn (pFadeSpeed:Float = FADE_SPEED, pTargetedVolume:Float = -1, pStartTime:Int = 0, pLoops:Int = 0): Void {
		startTime = pStartTime;
		loops 	  = pLoops;
		fadeSpeed = pFadeSpeed;
		
		if (pTargetedVolume < 0)
			pTargetedVolume = initialVolume;
			
		fadeInTargetedVolume = pTargetedVolume;
		
		var lStage:Stage = Lib.current.stage;
		
		lStage.removeEventListener(Event.ENTER_FRAME, doFadeOut);
		
		if (!isPlaying) {				
			if (channel == null) volume = 0;
			
			loops == 0 ? loop(startTime) : start(startTime, loops);
		}
		
		lStage.addEventListener(Event.ENTER_FRAME, doFadeIn);
	}
	
	/**
	 * fait évoluer le son pendant le fadeIn
	 */
	private function doFadeIn (pEvent:Event): Void {
		volume = Math.min(fadeInTargetedVolume, volume + fadeSpeed);
		
		if (volume >= fadeInTargetedVolume)
			Lib.current.stage.removeEventListener(Event.ENTER_FRAME, doFadeIn);
	}
	
	/**
	 * Lance un fadeOut jusqu'a 0 puis stop le son
	 * @param Décrément de volume à chaque frame (0.005 donne volume += 0.3/seconde à une cadence de 60 fps)
	 */
	public function fadeOut (pFadeSpeed:Float = FADE_SPEED):Void {
		fadeSpeed = pFadeSpeed;
		
		if (channel == null) return;

		var lStage:Stage = Lib.current.stage;
		lStage.removeEventListener(Event.ENTER_FRAME, doFadeIn);
		lStage.addEventListener(Event.ENTER_FRAME, doFadeOut);
	}
	
	/**
	 * fait évoluer le son pendant le fadeOut
	 */
	private function doFadeOut (pEvent:Event): Void {
		volume-= fadeSpeed;
		
		if (volume <= 0) stop();
	}
	
	/**
	 * diffuse l'évenement de fin de son
	 * @param	pEvent Evenement SOUND_COMPLETE diffusé par le canal
	 */
	private function onSoundComplete (pEvent:Event = null):Void {
		dispatchEvent(new Event(Event.COMPLETE));
	}
	
	/**
	 * nettoyage de l'instance de SoundFX
	 */
	public function destroy (): Void {
		stop();
		
		sound   = null;
		channel = null;
	}
}