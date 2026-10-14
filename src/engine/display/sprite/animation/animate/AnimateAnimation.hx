package engine.display.sprite.animation.animate;

import h2d.Tile;
import h2d.SpriteBatch;

class AnimateSpritemapSprite
{
    public var x:Float = 0;
    public var y:Float = 0;
    public var width:Float = 0;
    public var height:Float = 0;
    public var rotated:Bool = false;
    public var tile:h2d.Tile;

    public function new(x:Float, y:Float, width:Float, height:Float, rotated:Bool, tile:h2d.Tile) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.rotated = rotated;
        this.tile = tile;
    }
}

class AnimateAnimation extends SpriteAnimation
{
    public function new() {
        super(ANIMATE);
    }
    
    public var smSprites:Map<String, AnimateSpritemapSprite>;
    public var smAtlas:hxd.res.Image;
    
    var animTimeline:AnimateTimeline;
            
    public function loadSpritemap(path:String) {
        //spritemap stuff
        var smJson:AnimateJson.SpritemapJson = Paths.animate(path);
        final sprites = smJson.ATLAS.SPRITES;
        
        var atlasName = StringTools.replace(smJson.meta.image, ".png", "");
                
        smAtlas = Paths.image('$path/$atlasName');
                
        parent.sBatch = new SpriteBatch(smAtlas.toTile(), parent);
        parent.sBatch.hasRotationScale = true;
        
        smSprites = new Map<String, AnimateSpritemapSprite>();
        
        for (i in 0...sprites.length) {
            var sprite = sprites[i].SPRITE;
            
            final atlasTile = smAtlas.toTile();
            final animTile = atlasTile.sub(sprite.x, sprite.y, sprite.w, sprite.h).center();
            
            var animSpr:AnimateSpritemapSprite = new AnimateSpritemapSprite(sprite.x, sprite.y, sprite.w, sprite.h, sprite.rotated, animTile);
            
            smSprites.set(sprite.name, animSpr);
        }
        
        loadAnimJson(path);
    }
        
    function loadAnimJson(path:String) {
        var animJson:AnimateJson.AnimationJson = Paths.json('images/$path/Animation');
        
        _anims = [];
        
        animTimeline = new AnimateTimeline(animJson, null, this);
    }
    
//    function loadSymbolDictJson(json:AnimateJson.SymbolDictJson)
    
    var _anims:Map<String, AnimateAnimationObject>;
    
    public function addByFrameLabel(name:String, label:String, ?framerate:Int = 24, ?looped:Bool = false) {
        var foundFrames:Array<Int> = animTimeline.findFrameLabelIndices(label);
        
        var anim = new AnimateAnimationObject(this, name, foundFrames, framerate, looped);
        anim.timeline = animTimeline;
        _anims.set(name, anim);
    }
    
    // for readability sake - ev
    private function setMatrix2D(matrix:h2d.col.Matrix, eM:Array<Float>) {  
        matrix.a = eM[0];
        matrix.b = eM[1];
        matrix.c = eM[2];
        matrix.d = eM[3];
        matrix.x = eM[4];
        matrix.y = eM[5];
    }
    
    private function parseMatrix3D(e:Dynamic):Array<Float> {
        var pM:Array<Float> = new Array<Float>();
        
        for (m in Reflect.fields(e.Matrix3D)) {
            pM.push(Reflect.field(e.Matrix3D, m));
        }

        return pM;
    }
    

    public function playAnim(name:String, ?forced:Bool = false, ?reversed:Bool = false) {        
        if ((!forced && playing)) return;
                
        curAnim = name;
        curFrame = 0;
        
        final anim = _anims.get(curAnim);
        
        animLength = anim.frames.length;
                
        frameTime = 1 / anim.framerate;
        
        playing = true;
    }
    
    override public function update(dt:Float) {
        super.update(dt);
                
        if (!playing) return;
                
        while (et >= frameTime) {            
            et -= frameTime;
            curFrame++;
        }
        
        final anim = _anims.get(curAnim);
        
        if (curFrame >= animLength) {
            if (anim.looped == true) {
                curFrame = 0;
            } else {
                curFrame = animLength;
                playing = false;
            }
        }
        
        animTimeline.renderFrame(anim.frames[curFrame]);
        
        for (symbol in animTimeline.symbols) {
            symbol.timeline.renderFrame(anim.frames[curFrame]);
        }
    }
}