package engine.game;

import engine.game.state.*;

class HeapsGame extends h2d.Scene
{        
    //TEMPORARY PROBABLY I DONT LIKE THIS LOLL
    public var s3d:h3d.scene.Scene;
    
    public function new(initialState:Class<HeapsState>, s3d:h3d.scene.Scene)
    {
        super();
        
        this.s3d = s3d;
    
        HeapsStateManager.game = this; // this fucking sucks.
        HeapsStateManager.setState(initialState);
    }
    
    public function update(dt:Float) {
        HeapsStateManager.update(dt);
    }    
}