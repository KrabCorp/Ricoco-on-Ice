package com.isartdigital.utils.game;

import haxe.ds.Either;
import openfl.display.DisplayObject;
import openfl.geom.Point;
import src.com.isartdigital.utils.OneOf;

/**
 * Classe utilitaire permettant de tester diverses collisions entre boites, formes et points
 * @author Mathieu ANTHOINE
 */
class CollisionManager 
{
    /**
     * 
     * @param   pHitBoxA boite englobante principale
     * @param   pHitBoxB boite englobante principale
     * @param   pHitsA liste de boites complémentaires ou de points de collision
     * @param   pHitsB liste de boites complémentaires ou de points de collision
     * @return  résultat de la collision
     */
    public static function hasCollision (pHitBoxA:DisplayObject, pHitBoxB:DisplayObject, pHitsA:HitBoxesOrHitPoints = null, pHitsB:HitBoxesOrHitPoints = null): Bool {
        if (pHitBoxA == null || pHitBoxB == null) return false;
        
        // test des boites de collision principale
        if (!pHitBoxA.hitTestObject(pHitBoxB)) return false;
        
        // si il n'y a pas de boites de collision plus précises on valide
        if (pHitsA == null && pHitsB == null) return true;            
        // test points vers la forme de la boite principale 
        
        switch(pHitsA){
            case Right(allHitPointsA): // pHitsA = points de collision
                switch(pHitsB){
                    // pHitB = points de collision
                    case Right(allHitPointsB): return testPoints(allHitPointsB, [pHitBoxA]) && testPoints(allHitPointsA, [pHitBoxB]);
                    // pHitB = boîtes complémentaires de collision
                    case Left(allHitBoxesB): return testPoints(allHitPointsA, allHitBoxesB);
                    // pHitB = null
                    default: return testPoints(allHitPointsA, [pHitBoxB]);
                }
            case Left(allHitBoxesA): // pHitsA = boîtes complémentaires de collision
                switch(pHitsB){
                    // pHitB = points de collision
                    case Right(allHitPointsB): return testPoints(allHitPointsB, allHitBoxesA);
                    // pHitB = boîtes complémentaires de collision
                    case Left(allHitBoxesB): return testBoxes(allHitBoxesB, allHitBoxesA);
                    // pHitB = null
                    default: return testBoxes(allHitBoxesA, [pHitBoxB]);
                }
            default: // pHitsA = null
                switch(pHitsB){
                    // pHitB = points de collision
                    case Right(allHitPointsB): return testPoints(allHitPointsB, [pHitBoxA]);
                    // pHitB = boîtes complémentaires de collision
                    case Left(allHitBoxesB): return testBoxes(allHitBoxesB, [pHitBoxA]);
                }
        }
        
        return false;
    }
    
    /**
     * 
     * @param   pHitPoints liste de points de collision (dont le repère est déjà converti en global)
     * @param   pHitBoxesB liste de boites de collision
     * @return  résultat de la collision
     */
    private static function testPoints (pHitPoints:Array<Point>, pHitBoxesB:Array<DisplayObject>): Bool {
        for (lHitPoint in pHitPoints) {
            for (lHitBoxB in pHitBoxesB)
                if (lHitBoxB.hitTestPoint(lHitPoint.x, lHitPoint.y,true)) return true;
        }
        
        return false;
        
    }
    
    /**
     * 
     * @param   pHitBoxesA liste de boites de collision
     * @param   pHitBoxesB liste de boites de collision
     * @return  résultat de la collision
     */
    private static function testBoxes (pHitBoxesA:Array<DisplayObject>, pHitBoxesB:Array<DisplayObject>): Bool {
        for (lHitBoxA in pHitBoxesA) {
            for (lHitBoxB in pHitBoxesB) {
                if (lHitBoxA.hitTestObject(lHitBoxB)) return true;
            }
        }
            
        return false;
    }

}

typedef HitBoxesOrHitPoints = OneOf<Array<DisplayObject>, Array<Point>>;