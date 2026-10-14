package engine.display.sprite.animation.animate;

import engine.display.sprite.animation.animate.elements.*;

class AnimateFrame
{
    public var layer:AnimateLayer = null;
    
    public var name:String;
    public var index:Int;
    public var duration:Int;
    
    public var elements:Array<AnimateElement>;
    
    public function new(layer:AnimateLayer, json:AnimateJson.FrameJson) {
        this.layer = layer;
        
        elements = [];
        
        name = json.N ?? "";
        index = json.I;
        duration = json.DU;      
               
        if (json != null) {
            loadJson(json);
        }
    }
    
    function loadJson(layer:AnimateJson.FrameJson) {
        for (element in layer.E) {
            if (element.ASI != null) {
                var atlas = new AnimateAtlasElement(element.ASI, this);
                elements.push(atlas);
            }
            if (element.SI != null) {
                var symbol = new AnimateSymbolElement(element.SI, this);
                elements.push(symbol);
            }
        }
    }

}