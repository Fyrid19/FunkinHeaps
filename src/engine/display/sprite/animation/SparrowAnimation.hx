package engine.display.sprite.animation;

import h2d.SpriteBatch;

typedef SparrowFrame = {
    var name:String;
    var frame:Int;
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

typedef SparrowTileFrame = {
    var tile:h2d.Tile;
    var rotated:Bool;
}

class SparrowAnimation extends SpriteAnimation
{        
    var sBatchElem:BatchElement;

    var xmlAnims:Map<String, Array<SparrowTileFrame>>;

    //var _frames:Array<SparrowFrame>;
    var _frames:Map<String, Array<SparrowFrame>>;
     
    public function new() {
        super(SPARROW);
    }
        
    public function loadAtlas(atlasSheet:hxd.res.Image) {        
        final xml:Xml = Paths.sparrow(atlasSheet);
                
        _frames = new Map<String, Array<SparrowFrame>>();
        
        var xmlName = null;
        var xmlFrame:Int = 0;
        
        for (child in xml.elements()) {
            if (child.nodeName != "TextureAtlas") continue;
            
            for (subTex in child.elements()) {
                if (subTex.nodeName != "SubTexture") continue;
                
                final flipX = subTex.get("flipX") == null ? "false" : subTex.get("flipX");
                final flipY = subTex.get("flipY") == null ? "false" : subTex.get("flipY");
                final rotated = subTex.get("rotated") == null ? "false" : subTex.get("rotated");

                if (subTex.get("name").substr(0, -4) != xmlName) xmlFrame = 0;
                xmlName = subTex.get("name").substr(0, -4);
                                
                var frame:SparrowFrame = {
                    name: xmlName,
                    frame: xmlFrame,
                    x: Std.parseFloat(subTex.get("x")),
                    y: Std.parseFloat(subTex.get("y")),
                    width: Std.parseFloat(subTex.get("width")),
                    height: Std.parseFloat(subTex.get("height")),
                    frameX: Std.parseFloat(subTex.get("frameX")),
                    frameY: Std.parseFloat(subTex.get("frameY")),
                    frameWidth: Std.parseFloat(subTex.get("frameWidth")),
                    frameHeight: Std.parseFloat(subTex.get("frameHeight")),
                    flipX: haxe.Json.parse(flipX),
                    flipY: haxe.Json.parse(flipY),
                    rotated: haxe.Json.parse(rotated)
                };

                if (_frames.get(xmlName) == null) _frames.set(xmlName, new Array<SparrowFrame>());

                _frames[xmlName].push(frame);
                
            }
        }
        
        final atlasTile:h2d.Tile = atlasSheet.toTile();
                
        parent.sBatch = new SpriteBatch(atlasTile, parent);
        parent.sBatch.hasRotationScale = true;

        
        sBatchElem = new BatchElement(atlasTile);
        parent.sBatch.add(sBatchElem);
        
        anims = new Map<String, SpriteAnimation.AnimEntry>();
        
        xmlAnims = new Map<String, Array<SparrowTileFrame>>();
        
        for (frames in _frames) {            
            for (frame in frames) {
                final name = frame.name;
                final fX = (frame.rotated == true ? frame.frameY - frame.width : -frame.frameX);
                final fY = (frame.rotated == true ? -frame.frameX : -frame.frameY);
                
                var tile:h2d.Tile = null;
                
                if (xmlAnims.get(name) == null) xmlAnims.set(name, new Array<SparrowTileFrame>());

                //TODO: make frameWidth and frameHeight do their thing lol
                
                tile = atlasTile.sub(frame.x, frame.y, frame.width, frame.height, fX, fY);
                tile.xFlip = frame.flipX;                                
                tile.yFlip = frame.flipY;

                xmlAnims[name].push({tile: tile, rotated: frame.rotated});   
            }
        }        
    }
    
    public function addByPrefix(name:String, prefix:String, ?fps:Int = 24, ?looped:Bool = false) {
        var extraMap:Map<String, Dynamic> = new Map<String, Dynamic>();
        var rotFrames:Map<Int, Bool> = new Map<Int, Bool>();
        
        var xmlFrames:Array<h2d.Tile> = new Array<h2d.Tile>();
        
        var f:Int = 0;
        for (key in xmlAnims.keys()) {
            if (StringTools.startsWith(key, prefix)) {
                for (frame in xmlAnims[key]) {
                    xmlFrames.push(frame.tile);
                    rotFrames.set(f++, frame.rotated);
                }
                                
                extraMap.set("xmlName", key);
                extraMap.set("rotatedFrames", rotFrames);

                var entry:SpriteAnimation.AnimEntry = {
                    name: name,
                    frames: xmlFrames,
                    fps: fps,
                    looped: looped,
                    extra: extraMap
                };
                
                anims.set(name, entry);
                
                break;
            }
        }
    }
    
    public function addByIndices(name:String, prefix:String, indices:Array<Int>, ?fps:Int = 24, ?looped:Bool = false) {
        var extraMap:Map<String, Dynamic> = new Map<String, Dynamic>();
        var rotFrames:Map<Int, Bool> = new Map<Int, Bool>();

        var xmlFrames:Array<h2d.Tile> = new Array<h2d.Tile>();

        var f:Int = 0;
        for (key in xmlAnims.keys()) {
            if (StringTools.startsWith(key, prefix)) {                
                for (indice in indices) {
                    xmlFrames.push(xmlAnims[key][indice].tile);
                    rotFrames.set(f++, xmlAnims[key][indice].rotated);
                }
                extraMap.set("xmlName", key);
                extraMap.set("rotatedFrames", rotFrames);
                
                var entry:SpriteAnimation.AnimEntry = {
                    name: name,
                    frames: xmlFrames,
                    fps: fps,
                    looped: looped,
                    extra: extraMap
                };
                
                anims.set(name, entry);
                
                break;
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
        sBatchElem.rotation = Math.degToRad(-90) * (anims.get(curAnim).extra.get("rotatedFrames").get(curFrame) == true ? 1 : 0);
     
    }
    
    public function playAnim(name:String, ?forced:Bool = false, ?reversed:Bool = false) {
        if (!forced && !playing) return;
        
        curAnim = name;
        curFrame = 0;
        
        frameTime = 1 / anims.get(curAnim).fps;
        
        playing = true;

    }
}