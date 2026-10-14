package engine.display.sprite.animation.animate.elements;

import engine.display.sprite.animation.animate.AnimateElement;

class AnimateSymbolElement extends AnimateElement
{    
    public var symbol:AnimateSymbol;
    
    public var instanceName:String;
    public var firstFrame:Int;
    public var symbolType:String;
    public var loop:String;
    
    public var curFrame:Int;

    public function new(data:AnimateJson.SymbolInstanceJson, frame:AnimateFrame) {
        super(ElementType.SYMBOL, data, frame);
        
        name = data.SN;
        instanceName = data.IN;
        firstFrame = data.FF;
        symbolType = data.ST;
        loop = data.LP;
        
        curFrame = firstFrame;
        
        matrix = matrix2DTo3D(data.MX);
                
        symbol = frame.layer.timeline.symbols.get(name);
   //     trace('symbol name: $name  symbol found: ${symbol != null}  instance name: $instanceName');
    }
}