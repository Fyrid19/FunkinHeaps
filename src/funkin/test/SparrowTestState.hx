package funkin.test;

class SparrowTestState extends HeapsState
{    

    var sparrow:Sprite;
    var sparrow2:Sprite;

    override public function new():Void
    {        
        super();
        
        var bg = new h2d.Bitmap(h2d.Tile.fromColor(0x00FF00, hxd.Window.getInstance().width, hxd.Window.getInstance().height), this);
            
        sparrow = new Sprite();
        sparrow.setScale(0.9);
        sparrow.x = 50;
        sparrow.loadSparrowAtlas(Paths.image("characters/DADDY_DEAREST"));
        addChild(sparrow);
        
        sparrow.animation.addByPrefix("idle", "Dad idle dance", 24, true);
        sparrow.animation.playAnim("idle", true, false);
        
        sparrow2 = new Sprite();
        sparrow2.setScale(1);
        sparrow2.x = 400;
        sparrow2.loadSparrowAtlas(Paths.image("characters/spooky_dark"));
        addChild(sparrow2);
        
        sparrow2.animation.addByPrefix("idle", "spooky dance idle", 24, true);
        sparrow2.animation.addByPrefix("cheer", "Spookiez YEAH cheer", 24, true);
        sparrow2.animation.addByIndices("idleFreaky", "spooky dance idle", [0, 2, 8, 9, 10, 11, 2, 11, 2, 1, 2, 3, 4,5], 24, true);
        sparrow2.animation.playAnim("idleFreaky", true, false);


    }
    
    
    override public function create():Void
    {        
        super.create();
    }
    
    override public function update(dt:Float) {
        super.update(dt);
        
        sparrow.animation.update(dt);
        sparrow2.animation.update(dt);

    }
}