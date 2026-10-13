package engine.display.sprite.animation.animate;

class AnimateLayer
{
    public var timeline:AnimateTimeline = null;
    
    public var visible:Bool = true;
    
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
            
            final startIdx = frame.I;
            final duration = frame.DU;
            
            for (i in 0...duration) {
                frames[startIdx + i] = _frame;
            }
        }
    }

    public function getFrameAt(frameIdx:Int):AnimateFrame {
        return frames[frameIdx];
    }
}