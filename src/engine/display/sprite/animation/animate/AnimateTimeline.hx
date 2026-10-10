package engine.display.sprite.animation.animate;

using StringTools;

class AnimateTimeline
{    
    public var parent:AnimateAnimation = null;
    public var layers:Array<AnimateLayer>;
    
    public function new(timeline:AnimateJson.TimelineJson, parent:AnimateAnimation) {     
        this.parent = parent;
        
        layers = [];
        
        if (timeline != null) {
            loadJson(timeline);
        }
    }
    
    function loadJson(timeline:AnimateJson.TimelineJson) {
        var layers:Array<AnimateJson.LayerJson> = timeline.L;
        
        for (layer in layers) {
            var _layer:AnimateLayer = new AnimateLayer(this, layer);
            this.layers.push(_layer);
            
        }
    }
}