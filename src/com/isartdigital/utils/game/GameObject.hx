package com.isartdigital.utils.game;

import openfl.display.DisplayObjectContainer;

/**
 * Classe de base des objets interactifs dans le jeu
 * @author Mathieu ANTHOINE
 */
class GameObject extends DisplayObjectContainer
{

	public function new() 
	{
		super();
	}
	
	/**
	 * nettoie et détruit l'instance
	 */
	public function destroy():Void {
        if (parent != null)
            parent.removeChild(this);
	}
	
}