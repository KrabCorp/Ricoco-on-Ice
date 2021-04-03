package com.isartdigital.sokoban.game;
import openfl.geom.Point;


/**
 * @author Jean VIDREQUIN
 */
typedef ChainPoint =
{
	var coord : Point;
	var previous : ChainPoint;
}