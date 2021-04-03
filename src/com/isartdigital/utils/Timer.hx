package com.isartdigital.utils;
import openfl.Lib;

/**
 * Classe utilitaire de chronomètre
 * @author Chadi Husser
 */
class Timer 
{
	/**
	 * Le timer tourne-t-il ?  
	 */
	public var isRunning(default, null):Bool;
	
	/**
	 * Temps écoulé depuis la dernière frame en seconde
	 */
	public var deltaTime(default, null):Float;
	
	/**
	 * Temps écoulé depuis la dernière frame en miliseconde
	 */
	public var deltaTimeInMilisecond(default, null):Int;
	
	/**
	 * Temps écoulé depuis le lancement du timer
	 */
	public var elapsedTime(default, null):Float;
	
	
	/**
	 * Facteur de vitesse d'écoulement du temps
	 */
	public var timeScale:Float = 1;
	
	/**
	 * Timestamp de la dernière frame
	 */
	private var lastDateInSecond : Float;
	
	public function new() 
	{
		reset();
	}
	
	/**
	 * Met à jours le timer
	 */
	public function update() : Void {
		
		deltaTimeInMilisecond = isRunning ? cast(timeScale * (Lib.getTimer() - lastDateInSecond), Int) : 0;
		
		deltaTime = deltaTimeInMilisecond / 1000;
		
		lastDateInSecond = Lib.getTimer();
		elapsedTime += deltaTime;
	}
	
	/**
	 * Relance le timer
	 */
	public function resume() : Void {
		lastDateInSecond = Lib.getTimer();
		isRunning = true;
		
	}
	
	/**
	 * Arrète le timer
	 */
	public function stop() : Void {
		isRunning = false;
	}
	
	/**
	 * Redemare le timer
	 */
	public function reset() : Void {
		elapsedTime = 0;
		deltaTime = 0;
		deltaTimeInMilisecond = 0;
	}
}