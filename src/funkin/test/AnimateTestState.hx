package funkin.test;

class AnimateTestState extends HeapsState
{    

    var ball:Sprite;
    var bf:Sprite;

    override public function new():Void
    {        
        super();
        
        var bg = new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, hxd.Window.getInstance().width, hxd.Window.getInstance().height), this);
            
        ball = new Sprite();
        ball.setScale(0.9);
        ball.x = 500;
        ball.y = 200;
        //ball.loadAnimate("test/Untitled-2");
        addChild(ball);
        
        bf = new Sprite();
        bf.setScale(0.9);
        bf.x = 200;
        bf.y = 200;
        bf.loadAnimate("test/BoyFriend Assets_TA-Export");
        addChild(bf);
        
        bf.animation.addByFrameLabel("idle", "Idle", 24, true);
        bf.animation.playAnim("idle", true, false);
        
     //   ball.animation.addByFrameLabel("moving", "Schmoove", 16, true);
       // ball.animation.playAnim("moving", true, false);
    }
    
    
    override public function create():Void
    {        
        super.create();
    }
    
    override public function update(dt:Float) {
        super.update(dt);
        
      //  ball.animation.update(dt);
        bf.animation.update(dt);
    }
}