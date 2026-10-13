package engine.display;

import h2d.Bitmap;

class VolumeTray extends Object {
    public var back:Bitmap;
    var text:Text;

    var volumeBar:Bitmap;
    var volumeBarBack:Bitmap;

    var manager:hxd.snd.Manager;

    public function new(manager:hxd.snd.Manager, parent:Object) {
        super(parent);

        this.manager = manager;

        back = Sprite.simpleBitmap(-150, 0, 300, 40, 0x000000, 0.5, this);

        volumeBarBack = Sprite.simpleBitmap(-140, 10, 280, 20, 0x000000, 1, this);
        volumeBar = Sprite.simpleBitmap(-140, 10, 280, 20, 0xFFFFFF, 1, this);

        // text = new Text(Paths.font('vcr', 20), back);
        // text.textAlign = Align.Center;
        // text.maxWidth = back.width;
        // text.text = 'Volume: ${Math.clamp(manager.masterVolume)}';
        // text.x = 150;
    }
    
	override function sync(ctx:h2d.RenderContext) {
        volumeBar.scaleX = Math.clamp(manager.masterVolume);
        super.sync(ctx);
    }
}