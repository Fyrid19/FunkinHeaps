package engine.game;

import engine.backend.Signal;

class HeapsGame extends h2d.Scene
{        
    //TEMPORARY PROBABLY I DONT LIKE THIS LOLL - ev
    public var s3d:h3d.scene.Scene;

    public var preUpdateSignal:Signal;
    public var postUpdateSignal:Signal;
    
    public function new(s3d:h3d.scene.Scene)
    {
        super();
                
        this.s3d = s3d;
    }
    
    public function update(dt:Float) {
        preUpdateSignal.dispatch();
        HeapsStateManager.update(dt);
        postUpdateSignal.dispatch();
    }    
}