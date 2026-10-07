package engine.display.sprite.animation;

import h2d.SpriteBatch;

typedef SparrowFrame = {
    var name:String;
    var x:Float;
    var y:Float;
    var width:Float;
    var height:Float;
    var frameX:Float;
    var frameY:Float;
    var frameWidth:Float;
    var frameHeight:Float;
    var flipX:Bool;
    var flipY:Bool;
    var rotated:Bool;

}

class SparrowAnimation extends SpriteAnimation
{    
    public var frames:Array<h2d.Tile>;
    
    var sBatchElem:BatchElement;

    var xmlAnims:Map<String, Array<h2d.Tile>>;
    //var xmlAnims:Map<String, Array<BatchElement>>;

    var _frames:Array<SparrowFrame>;
        
    public function new() {
        super(SPARROW);
    }
        
    public function loadAtlas(atlasSheet:hxd.res.Image) {        
        final xml:Xml = Paths.sparrow(atlasSheet);
                
        _frames = new Array<SparrowFrame>();
        for (child in xml.elements()) {
            if (child.nodeName != "TextureAtlas") continue;
            
            for (subTex in child.elements()) {
                if (subTex.nodeName != "SubTexture") continue;
                
                final flipX = subTex.get("flipX") == null ? "false" : subTex.get("flipX");
                final flipY = subTex.get("flipY") == null ? "false" : subTex.get("flipY");
                final rotated = subTex.get("rotated") == null ? "false" : subTex.get("rotated");

                var frame:SparrowFrame = {
                    name: subTex.get("name"),
                    x: Std.parseInt(subTex.get("x")),
                    y: Std.parseInt(subTex.get("y")),
                    width: Std.parseInt(subTex.get("width")),
                    height: Std.parseInt(subTex.get("height")),
                    frameX: Std.parseInt(subTex.get("frameX")),
                    frameY: Std.parseInt(subTex.get("frameY")),
                    frameWidth: Std.parseInt(subTex.get("frameWidth")),
                    frameHeight: Std.parseInt(subTex.get("frameHeight")),
                    flipX: haxe.Json.parse(flipX),
                    flipY: haxe.Json.parse(flipY),
                    rotated: haxe.Json.parse(rotated)
                };

                _frames.push(frame);
                
            }
        }
        
        final atlasTile:h2d.Tile = atlasSheet.toTile();
        
        frames = new Array<h2d.Tile>();
        
        parent.sBatch = new SpriteBatch(atlasTile, parent);
        sBatchElem = new BatchElement(atlasTile);
        parent.sBatch.add(sBatchElem);
        
        anims = new Map<String, SpriteAnimation.AnimEntry>();
        xmlAnims = new Map<String, Array<h2d.Tile>>();

        for (frame in _frames) {
            var name = frame.name.substr(0, -4);
            var tile:h2d.Tile = null;
            
            // TODO: make framewidth and frameheight do their thing
            
            if (frame.rotated) {
                tile = atlasTile.sub(frame.x, frame.y, frame.width, frame.height, 0, 0);
                tile.xFlip = frame.flipX;
            
                @:privateAccess {
                    final width = tile.width;
                    final height = tile.height;
                    final texWidth = atlasTile.getTexture().width;
                    final texHeight = atlasTile.getTexture().height;
                    final x = tile.x;// + (frame.frameHeight - frame.height - frame.frameX);
                    final y = tile.y;// + frame.frameY;

                    tile.u = (x) / texWidth;
                    tile.v = (y + height) / texHeight;
                    tile.u2 = (x + width) / texWidth;
                    tile.v2 = (y) / texHeight;
                    
                    tile.scaleToSize(height, width);
                    
                    tile.dx = -frame.frameY;
                    tile.dy = -frame.frameX;
                    
                }
                                                
                //tile.yFlip = !frame.flipY;
            } else {
                tile = atlasTile.sub(frame.x, frame.y, frame.width, frame.height, -frame.frameX, -frame.frameY);
                tile.xFlip = frame.flipX;
                tile.yFlip = frame.flipY;

            }

            if (xmlAnims.get(name) == null) xmlAnims.set(name, new Array<h2d.Tile>());
            
            xmlAnims[name].push(tile);
        }
        
    }
    
    public function addByPrefix(name:String, prefix:String, ?fps:Int = 24, ?looped:Bool = false) {
        var xmlFrames:Array<h2d.Tile> = new Array<h2d.Tile>();
        
        for (key in xmlAnims.keys()) {
            if (StringTools.startsWith(key, prefix)) {
                for (frame in xmlAnims[key]) {
                    xmlFrames.push(frame);
                }
                
                var entry:SpriteAnimation.AnimEntry = {
                    name: name,
                    frames: xmlFrames,
                    fps: fps,
                    looped: looped
                };
                
                anims.set(name, entry);
            }
        }
    }
    
    override public function update(dt:Float) {
        super.update(dt);
        
        if (!playing) return;
        
        while (et >= frameTime) {
            et -= frameTime;
            curFrame++;
        }
        
        if (curFrame >= anims[curAnim].frames.length) {
            if (anims[curAnim].looped) {
                curFrame = 0;
            } else {
                playing = false;
                return;
            }
        }
        
        sBatchElem.t = anims.get(curAnim).frames[curFrame];            
    }
    
    public function playAnim(name:String, ?forced:Bool = false, ?reversed:Bool = false) {
        curAnim = name;
        

        frameTime = 1 / anims.get(name).fps;
        
        playing = true;

    }
}