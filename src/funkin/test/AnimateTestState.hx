package funkin.test;

class AnimateTestState extends HeapsState
{    

    var spr:Sprite;

    override public function new():Void
    {        
        super();
        
        var bg = new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, hxd.Window.getInstance().width, hxd.Window.getInstance().height), this);
            
        spr = new Sprite();
        spr.setScale(0.9);
        spr.x = 50;
        spr.loadAnimate("test/Untitled-2");
        addChild(spr);
    }
    
    
    override public function create():Void
    {        
        super.create();
    }
    
    override public function update(dt:Float) {
        super.update(dt);
        
        spr.animation.update(dt);
    }
}