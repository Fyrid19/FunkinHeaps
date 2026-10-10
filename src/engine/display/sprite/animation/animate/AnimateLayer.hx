package engine.display.sprite.animation.animate;

class AnimateLayer
{
    public var timeline:AnimateTimeline = null;
    public var name:String;
    public var frames:Array<AnimateFrame> = [];
    
    public function new(timeline:AnimateTimeline, json:AnimateJson.LayerJson) {
        this.timeline = timeline;
        
        name = json.LN ?? "";
        
        if (json != null) {
            loadJson(json);
        }
    }
    
    function loadJson(layer:AnimateJson.LayerJson) {        
        for (frame in layer.FR) {
            var _frame:AnimateFrame = new AnimateFrame(this, frame);
            frames.push(_frame);
        }
    }
}