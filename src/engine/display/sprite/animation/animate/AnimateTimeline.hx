package engine.display.sprite.animation.animate;

import engine.display.sprite.animation.animate.elements.*;
using StringTools;

class AnimateTimeline
{    
    public var parent:AnimateAnimation = null;
        
    public var framerate:Int = 30;
    public var curFrame:Int = 0;
    public var playing:Bool = false;

    public var layers:Array<AnimateLayer>;
    public var symbols:Map<String, AnimateSymbol>;
    
    public var symbol:AnimateSymbol = null;

    public function new(?json:AnimateJson.AnimationJson, ?symbols:Map<String, AnimateSymbol>, ?parent:AnimateAnimation) {     
        this.parent = parent ?? null;
        
        this.symbols = symbols ?? new Map<String, AnimateSymbol>();
        
        layers = [];
        
        if (json != null) {            
            if (json.SD != null) {
                loadSymbolJson(json.SD);
            }
            
            loadTimelineJson(json.AN.TL);
        }
    }
    
    public function loadSymbolJson(symbol:AnimateJson.SymbolDictJson) {
        final symbols:Array<AnimateJson.SymbolJson> = symbol.S;
        
        for (symbol in symbols) {
            var _symbol:AnimateSymbol = new AnimateSymbol(this, symbol);
            this.symbols.set(symbol.SN, _symbol);
        }
        
        for (symbol in this.symbols) {
            symbol.loadTimeline();
        }
    }
    
    public function loadTimelineJson(timeline:AnimateJson.TimelineJson) {
        final layers:Array<AnimateJson.LayerJson> = timeline.L;
        
        for (layer in layers) {
            var _layer:AnimateLayer = new AnimateLayer(this, layer);
            this.layers.push(_layer);
            
        }
    }

    public function findFrameLabelIndices(label:String):Array<Int> {
        var foundFrames:Array<Int> = [];
        var foundLabel:Bool = false;
        
        if (symbol == null) {
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
        } else {
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
            }}
        
        return foundFrames;
    }
    
    public function renderFrame(frameIdx:Int) {
        parent.parent.sBatch.clear();
        
        //trace('ROOT RENDER: $frameIdx');
        
        _renderFrame(frameIdx);
    }
    
    function _renderFrame(frameIdx:Int) {
        //trace('TIMELINE RENDER: $frameIdx');
        
        for (layer in layers) {
            if (layer.visible == false) continue;
            
            var frame = layer.getFrameAt(frameIdx);
            if (frame == null) continue;

            for (element in frame.elements) {
                if (element is AnimateAtlasElement) {
                    var elem:AnimateAtlasElement = cast element;
                    
                    var bElem = parent.parent.sBatch.alloc(elem.sprite.tile);
                    
                    bElem.x = elem.matrix.x;
                    bElem.y = elem.matrix.y;
                    
                    final scaleX = Math.sqrt(elem.matrix.a * elem.matrix.a + elem.matrix.b * elem.matrix.b);
                    bElem.rotation = Math.atan2(elem.matrix.b / scaleX, elem.matrix.a / scaleX);
                    
                } 
                if (element is AnimateSymbolElement) {
                    var elem:AnimateSymbolElement = cast element;
                    
                    elem.symbol.render(0);
                                                            
                    //elem.symbol.timeline.renderFrame(frameIdx);

                }
            }
        }
    }
}