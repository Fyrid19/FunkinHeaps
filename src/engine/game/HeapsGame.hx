package engine.game;

import engine.backend.Signal;

class HeapsGame extends h2d.Scene
{        
    //TEMPORARY PROBABLY I DONT LIKE THIS LOLL - ev
    public var s3d:h3d.scene.Scene;

    public var preUpdateSignal:Signal = new Signal();
    public var postUpdateSignal:Signal = new Signal();
    
    public function new(s3d:h3d.scene.Scene, ?width:Int = 1280, ?height:Int = 720)
    {
        super();
        
        this.s3d = s3d;

        this.scaleMode = ScaleMode.LetterBox(width, height);
    }
    
    public function update(dt:Float) {
        preUpdateSignal.dispatch();
        HeapsStateManager.update(dt);
        postUpdateSignal.dispatch();
    }    
}