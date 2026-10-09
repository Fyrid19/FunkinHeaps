package engine.display.debug;

class DebugDisplay extends h2d.Object
{
    var fpsDisplay:FPSDisplay;
    var ramDisplay:RAMDisplay;
    
    // GOD I LOVE OBJECT ORIENTED PROGRAMMING RAHHH - ev
    public function new(x:Float = 0, y:Float = 0, parent:h2d.Object)
    {
        super(parent);
        this.setPosition(x, y);
        
        fpsDisplay = new FPSDisplay(0, 0, this);
        ramDisplay = new RAMDisplay(0, 30, this);
    }
}