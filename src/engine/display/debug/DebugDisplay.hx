package engine.display.debug;

import h2d.Bitmap;

class DebugDisplay extends Object
{
    var back:Bitmap;
    var back2:Bitmap;
    var fpsDisplay:FPSDisplay;
    var ramDisplay:RAMDisplay;
    var outline:Int = 2;
    
    // GOD I LOVE OBJECT ORIENTED PROGRAMMING RAHHH - ev
    public function new(x:Float = 0, y:Float = 0, parent:Object)
    {
        super(parent);
        this.setPosition(x, y);
        
        back = Sprite.simpleBitmap(0, 0, 1, 1, 0x000000, 0.25, this);
        back2 = Sprite.simpleBitmap(outline, outline, 1, 1, 0x000000, 0.25, this);

        fpsDisplay = new FPSDisplay(5, 5, this);
        ramDisplay = new RAMDisplay(5, 25, this);

        var width:Float = 250;
        var height:Float = fpsDisplay.fpsText.textHeight + ramDisplay.gcRamText.textHeight + 11;
        back.tile.setSize(width, height);
        back2.tile.setSize(width - outline*2, height - outline*2);
    }
}