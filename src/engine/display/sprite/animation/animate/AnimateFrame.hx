package engine.display.sprite.animation.animate;

import engine.display.sprite.animation.animate.elements.*;

class AnimateFrame
{
    public var layer:AnimateLayer = null;
    public var name:String;
    public var index:Int;
    public var duration:Int;
    
    public function new(layer:AnimateLayer, json:AnimateJson.FrameJson) {
        this.layer = layer;
        
        name = json.N ?? "";
        index = json.I ?? 0;
        duration = json.DU ?? 1;
        
        trace(name);
    }
}