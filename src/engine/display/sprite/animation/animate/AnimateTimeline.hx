package engine.display.sprite.animation.animate;

import engine.display.sprite.animation.animate.elements.AnimateAtlasElement;
using StringTools;

class AnimateTimeline
{    
    public var parent:AnimateAnimation = null;
        
    public var framerate:Int = 30;
    public var curFrame:Int = 0;
    public var playing:Bool = false;

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

    public function findFrameLabelIndices(label:String):Array<Int> {
        var foundFrames:Array<Int> = [];
        var foundLabel:Bool = false;
        
        for (layer in layers) {
            for (frame in layer.frames) {
                if (frame.name == label) {
                    foundLabel = true;
                    
                    for (i in 0...frame.duration)
                        foundFrames[i] = (frame.index + i);
                }
            }
            
            if (foundLabel)
                break; 
        }
        
        return foundFrames;
    }
    
    public function renderFrame(frameIdx:Int) {        
        parent.parent.sBatch.clear();
        
        for (layer in layers) {
            if (layer.visible == false) continue;
            
            var frame = layer.getFrameAt(frameIdx);
            if (frame == null) continue;

            for (element in frame.elements) {
                if (element is AnimateAtlasElement) {
                    final spr = parent.smSprites.get(element.name);
                    
                    var bElem = parent.parent.sBatch.alloc(spr.tile);
                    
                    final matrix = element.matrix;
                    
                    bElem.x = matrix.x;
                    bElem.y = matrix.y;
                    
                    final scaleX = Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b);
                    bElem.rotation = Math.atan2(matrix.b / scaleX, matrix.a / scaleX);
                }
                
            }
        }
    }
}