package engine.display.sprite;

import h2d.Bitmap;

import engine.display.sprite.animation.*;

class Sprite extends h2d.Object {
    public var animation:Dynamic = new SpriteAnimation();
    public var sBatch:h2d.SpriteBatch;

    @:isVar public var bitmap(get, set):h2d.Bitmap;
    
    public function new() {
        super();
    }
    
    public function loadSparrowAtlas(img:hxd.res.Image) {
        animation = new SparrowAnimation();
        animation.parent = this;
        
        animation.loadAtlas(img);
        
        //bitmap = new h2d.Bitmap(animation.frames[1]); // temp
    }
    
    public function updateAnim() {
        
    }
    
    static public function fromBitmap(bitmap:h2d.Bitmap):Sprite {
        var sprite = new Sprite();
        
        sprite.bitmap = bitmap;
        
        return sprite;
    }
        

    // we cant add the bitmap in the constructor, so we add it when it actually gets changed
    function set_bitmap(value:Bitmap):Bitmap {
        bitmap = value;
        
        if (value != null && getChildIndex(bitmap) == -1) {
            addChild(bitmap);
        } else if (value == null && getChildIndex(bitmap) != -1) {
            removeChild(bitmap);   
        }
        
        return value;
    }

	function get_bitmap():Bitmap {
        return bitmap;
	}
}