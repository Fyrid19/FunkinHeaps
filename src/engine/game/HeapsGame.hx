package engine.game;

class HeapsGame extends h2d.Scene
{        
    //TEMPORARY PROBABLY I DONT LIKE THIS LOLL - ev
    public var s3d:h3d.scene.Scene;
    
    public function new(s3d:h3d.scene.Scene)
    {
        super();
                
        this.s3d = s3d;
    }
    
    public function update(dt:Float) {
        HeapsStateManager.update(dt);
    }    
}