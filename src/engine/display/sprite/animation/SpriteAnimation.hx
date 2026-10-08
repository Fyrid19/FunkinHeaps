package engine.display.sprite.animation;

typedef AnimEntry = {
    var name:String;
    var frames:Array<h2d.Tile>;
    var fps:Int;
    var looped:Bool;
    var extra:Map<String,Dynamic>; // incase animation implementations need extra data
}

class SpriteAnimation
{
    public var parent:Sprite = null;
    
    public var type:SpriteAnimationType;
    
    public var frameTime:Float = 0;

    public var curAnim:String = "";
    public var curFrame:Int = 0;
    public var et:Float = 0;
    
    public var playing:Bool = false;
    
    public var anims:Map<String, AnimEntry>;
    
    public function new(type:SpriteAnimationType = NONE) {
        this.type = type;
    }
    
    public function update(dt:Float) {
        if (playing) et += dt;
    }
}