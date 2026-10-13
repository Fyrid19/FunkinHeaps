package engine.display.debug;

class FPSDisplay extends Object
{
    var accuTime:Float = 0.0;
    var frameCnt:Int = 0;
    var curFPS:Int = 0;
    
    public var fpsText:Text;
    public function new(x:Float = 0, y:Float = 0, parent:Object)
    {
        super(parent);
        this.setPosition(x, y);

        fpsText = new Text(Paths.font('vcr', 20), this);
        fpsText.text = 'FPS: ${h3d.Engine.getCurrent().fps}';
        fpsText.color = new h3d.Vector4(1, 1, 1, 1);
    }
    
    // yeah this is weird i cant lie - ev
	override function sync(ctx:h2d.RenderContext)
    {
        /*accuTime += hxd.Timer.elapsedTime;
        frameCnt++;
        
        if (accuTime >= 1.0)
        {
            curFPS = frameCnt;
            frameCnt = 0;
            accuTime = 0.0;
        }*/

        // i gotchu - kayle
        fpsText.text = 'FPS: ${Math.round(h3d.Engine.getCurrent().fps)}';
        
        super.sync(ctx);
    }
}