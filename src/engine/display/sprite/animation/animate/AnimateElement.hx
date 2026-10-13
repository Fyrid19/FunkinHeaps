package engine.display.sprite.animation.animate;

import h2d.col.Matrix;

class AnimateElement
{
    public var frame:AnimateFrame = null;
    
    public var name:String;
    public var data:Dynamic; // elements json stuff
    public var type:ElementType;
    public var matrix:Matrix;
    
    public function new(type:ElementType, data:Dynamic, frame:AnimateFrame) {
        this.frame = frame;
        this.data = data;
        this.type = type ?? ElementType.NONE;
    }
    
    function matrix2DTo3D(data:AnimateJson.MatrixJson):Matrix {
        var result = new Matrix();
                
        result.a = data.a;
        result.b = data.b;
        result.c = data.c;
        result.d = data.d;
        result.x = data.tx;
        result.y = data.ty;
        
                
        return result;
    }
}

enum abstract ElementType(String) from String {
    var NONE = "";
    var ATLAS = "atlas";
    var SYMBOL = "symbol";
}