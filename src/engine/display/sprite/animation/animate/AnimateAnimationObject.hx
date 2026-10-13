package engine.display.sprite.animation.animate;

class AnimateAnimationObject
{
    public var animation:AnimateAnimation = null;
    public var timeline:AnimateTimeline = null;
    
    public var name:String;
    public var frames:Array<Int>;
    public var framerate:Int;
    public var looped:Bool;
    
    public function new(animation:AnimateAnimation, name:String, frames:Array<Int>, framerate:Int, looped:Bool) {
        this.animation = animation;
        this.name = name;
        this.frames = frames;
        this.framerate = framerate;
        this.looped = looped;
    }
}