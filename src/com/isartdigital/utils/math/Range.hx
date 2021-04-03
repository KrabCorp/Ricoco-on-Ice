package com.isartdigital.utils.math;

/**
 * ...
 * @author Théo Sabattié
 */
class Range 
{
	private var _min:Float;
	private var _max:Float;
	
    public var min(get, set):Float;
    public var max(get, set):Float;
    
    public function new(pMin:Float, pMax:Float) 
    {
        _min = pMin;
        max  = pMax;
    }
    
    private function get_min():Float {
        return _min;
    }
    
    private function get_max():Float {
        return _max;
    }
    
    private function set_min(pMin:Float):Float {
        _min = pMin;
        _max = Math.max(_max, _min);
        return _min;
    }
    
    private function set_max(pMax:Float):Float {
        _max = pMax;
        _min = Math.min(_max, _min);
        return _max;
    }
    
    public function random():Float {
        return MathTools.randomRange(_min, _max);
    }
    
    public function clamp(pValue:Float):Float {
        return MathTools.clamp(pValue, _min, _max);
    }
    
    public function lerp(pRatio:Float):Float {
        return MathTools.lerp(_min, _max, pRatio);
    }
}