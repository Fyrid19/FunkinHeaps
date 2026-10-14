package engine.display.sprite.animation.animate;

class AnimateSymbol
{
    public var root:AnimateTimeline;
    
    public var symbolName:String;
    public var timeline:AnimateTimeline;
    
    public var json:AnimateJson.SymbolJson;
    public function new(root:AnimateTimeline, json:AnimateJson.SymbolJson) {
        this.root = root;
        
        loadJson(json);
    }
    
    function loadJson(symbol:AnimateJson.SymbolJson) {
        json = symbol;
        
        symbolName = json.SN;
    }
    
    public function loadTimeline() {
        timeline = new AnimateTimeline(null, root.symbols, root.parent);
        timeline.symbol = this;
        timeline.loadTimelineJson(json.TL);
    }
    
    public function render(frameIdx:Int) {
        @:privateAccess timeline._renderFrame(frameIdx);
    }
}