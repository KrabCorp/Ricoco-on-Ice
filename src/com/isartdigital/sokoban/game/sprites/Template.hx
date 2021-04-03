package com.isartdigital.sokoban.game.sprites;

import com.isartdigital.utils.game.stateObjects.StateMovieClip;
import com.isartdigital.utils.game.stateObjects.colliders.ColliderType;

/**
 * ...
 * @author Chadi Husser
 */
class Template extends StateMovieClip
{

	/**
	 * instance unique de la classe Template
	 */
	private static var instance: Template;

	/**
	 * Retourne l'instance unique de la classe, et la crée si elle n'existait pas au préalable
	 * @return instance unique
	 */
	public static function getInstance (): Template
	{
		if (instance == null) instance = new Template();
		return instance;
	}

	/**
	 * constructeur privé pour éviter qu'une instance soit créée directement
	 */
	private function new()
	{
		super();
	}

	override function get_colliderType():ColliderType
	{
		return ColliderType.SIMPLE;
	}

	/**
	 * détruit l'instance unique et met sa référence interne à null
	 */
	override public function destroy (): Void
	{
		instance = null;
	}

}