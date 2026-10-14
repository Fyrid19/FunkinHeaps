package engine.display;

import h2d.Bitmap;

class VolumeTray extends Object {    
    public var volume:Int = 100;
    public var volumeFloat(get, default):Float; // i loove getter setter functions -ev

    public var muted:Bool = false;
    var mutedVolume:Int = 0; // so we can save the volume when its muted

    public var volumeTime:Float = 0; // the timer for it appear and then leaving
    
    var back:Bitmap;
    var text:Text;

    var volumeBar:Bitmap;
    var volumeBarBack:Bitmap;
    
    var manager:hxd.snd.Manager;

    public function new(manager:hxd.snd.Manager, parent:h2d.Scene) {
        super(parent);

        this.manager = manager;

        back = Sprite.simpleBitmap(-150, 0, 300, 40, 0x000000, 0.5, this);

        volumeBarBack = Sprite.simpleBitmap(-140, 20, 280, 15, 0x000000, 1, this);
        volumeBar = Sprite.simpleBitmap(-140, 20, 280, 15, 0xFFFFFF, 1, this);

        text = new Text(Paths.font('vcr', 20), back);
        text.textAlign = Align.Center;
        text.maxWidth = back.width;
        text.text = 'Volume: ${volume}';
        text.x = 150;
        
        x = parent.width/2 - back.width/2;
        alpha = 0;
    }
    
	override function sync(ctx:h2d.RenderContext) {
        volumeBar.scaleX = Math.lerp(volumeBar.scaleX, volumeFloat, 0.5);
        super.sync(ctx);
    }

    public function update(dt:Float) {
        if (volumeTime > 0) volumeTime -= dt;
        
        y = 4 + (Math.clamp(volumeTime)-1) * 50;
        alpha = Math.clamp(volumeTime);
        
        if (InputController.getInput('volume_up', PRESS)) {
            addVolume(10);
        } else if (InputController.getInput('volume_down', PRESS)) {
            addVolume(-10);
        } else if (InputController.getInput('volume_mute', PRESS)) {
            muteVolume();
        }
                
        manager.masterVolume = volumeFloat;
        
        text.text = 'Volume: ${volume}';
    }
    
    public function setVolume(set:Int, ?volumeTime:Float = 2) {
        this.volumeTime = volumeTime;
        
        if (muted == true && set > 0) muted = false;
        
        volume = Std.int(Math.clamp(set, 0, 100));
    }
    
    public function addVolume(add:Int, ?volumeTime:Float = 2) {
        final setVol = (add < 0 && volume + add <= 0) ? 0 : volume + add;
        setVolume(setVol, volumeTime);
    }
    
    public function muteVolume() {
        muted = !muted;

        if (muted) mutedVolume = volume;
        
        setVolume(muted ? 0 : mutedVolume);
    }
    
    function get_volumeFloat():Float {
        return Math.clamp(volume / 100);
    }
}