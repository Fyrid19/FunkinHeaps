package engine.display.sprite.animation.animate.elements;

import engine.display.sprite.animation.animate.AnimateElement;

class AnimateSymbolElement extends AnimateElement
{    
    public function new(data:AnimateJson.SymbolInstanceJson, frame:AnimateFrame) {
        super(ElementType.SYMBOL, data, frame);
                
        matrix = matrix2DTo3D(data.MX);
    }
}