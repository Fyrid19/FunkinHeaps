package engine.display.sprite.animation.animate;

import h3d.Matrix;
import h2d.Tile;
import h2d.SpriteBatch;
import h2d.SpriteBatch.BatchElement;

class AnimateSpritemapSprite
{
    public var x:Int = 0;
    public var y:Int = 0;
    public var width:Int = 0;
    public var height:Int = 0;
    public var rotated:Bool = false;

    public function new(x:Int, y:Int, width:Int, height:Int, rotated:Bool) {
        this.x = x;
        this.y = y;
        this.width = width;
        this.height = height;
        this.rotated = rotated;
        
    }
}

typedef AnimateDecomposedMatrix = {
    public var position:Matrix; // T
    public var rotation:Matrix; // R
    public var scaling:Matrix; // S

}
typedef AnimateTimelineElement = {
    public var name:String;
    public var matrix:AnimateDecomposedMatrix;
}

typedef AnimateTimelineFrame = {
    public var ?name:String;
    public var index:Int;
    public var duration:Int;
    public var elements:Array<AnimateTimelineElement>;
}

typedef AnimateLayer = {
    public var name:String;
    public var frames:Array<AnimateTimelineFrame>;
};

typedef AnimateTimeline = {
    public var framerate:Int;
    public var layers:Array<AnimateLayer>;
}

class AnimateAnimation extends SpriteAnimation
{
    public function new() {
        super(ANIMATE);
    }
    
    var smSprites:Map<String, AnimateSpritemapSprite>;
    var smAtlas:hxd.res.Image;
    
    var animTimeline:AnimateTimeline;
    
    var _optimizedAnimJson:Bool = false;
    
    public function loadSpritemap(path:String) {
        //spritemap stuff
        var smJson = Paths.animate(path);

        final atlas = smJson.ATLAS;
        final sprites = atlas.SPRITES;
        final meta = smJson.meta;

        var atlasName = StringTools.replace(meta.image, ".png", "");
                
        smAtlas = Paths.image('$path/$atlasName');
        
        parent.sBatch = new SpriteBatch(smAtlas.toTile(), parent);
        parent.sBatch.hasRotationScale = true;
        
        smSprites = new Map<String, AnimateSpritemapSprite>();
        
        for (i in 0...sprites.length) {
            var sprite = sprites[i].SPRITE;
            
            var animSpr:AnimateSpritemapSprite = new AnimateSpritemapSprite(sprite.x, sprite.y, sprite.w, sprite.h, sprite.rotated);
            smSprites.set(sprite.name, animSpr);
        }
        
        // animation stuff
        final animJson = Paths.json('images/$path/Animation');
        checkIfOptimized(animJson);
        
        final animation = animJson.ANIMATION;
        
        final flaName = animation.name;
        final symbolName =  animation.SYMBOL_name;
        
        final animFramerate = animJson.metadata.framerate;
        
        final timeline = animation.TIMELINE;

        final layers = timeline.LAYERS;
        
        var animLayers:Array<AnimateLayer> = new Array<AnimateLayer>();
        
        for (i in 0...layers.length) {
            final layer = layers[i];
            final layerName = layer.Layer_name;
                        
            final frames = layer.Frames;
            var layerFrames:Array<AnimateTimelineFrame> = new Array<AnimateTimelineFrame>();
            
            for (j in 0...frames.length) {
                final frame = frames[j];
                
                final frameName:String = frame.name;
                final frameIdx:Int = frame.index;
                final frameDur:Int = frame.duration;

                final elements = frame.elements;
                
                var animElements:Array<AnimateTimelineElement> = new Array<AnimateTimelineElement>();
                
                for (k in 0...elements.length) {
                    final element = elements[k];
                    
                    final atlasSprInst = element.ATLAS_SPRITE_instance;
                    
                    final atlasSprName = atlasSprInst.name;
                    
                    final decompMatrix = atlasSprInst.DecomposedMatrix;
                    final pos = decompMatrix.Position;
                    final rot = decompMatrix.Rotation;
                    final scale = decompMatrix.Scaling;
                    
                    animElements.push({name: atlasSprName, matrix: {
                        position: Matrix.T(pos.x, pos.y, pos.z),
                        rotation: Matrix.R(rot.x, rot.y, rot.z),
                        scaling: Matrix.S(scale.x, scale.y, scale.z)
                    }});
                }
                var animFrame:AnimateTimelineFrame = {index: frameIdx, duration: frameDur, elements: animElements};
                if (frameName != null) animFrame.name = frameName;
                layerFrames.push(animFrame);
            }
                        
            animLayers.push({name: layerName, frames: layerFrames});
        }
                
        animTimeline = {framerate: animFramerate, layers: animLayers};
        
        playAnim("Schmoove");
    }
    
    public function playAnim(name:String) {
        curAnim = name;
        curFrame = 0;
        
        var duration:Int = 0;
        
        for (layer in animTimeline.layers) {
            for (frame in layer.frames) {
                for (element in frame.elements) {
                    var smSprElem:BatchElement = new BatchElement(smAtlas.toTile());
                    smSprElem.t.setPosition(smSprites[element.name].x, smSprites[element.name].y);
                    smSprElem.t.setSize(smSprites[element.name].width, smSprites[element.name].height);
                    smSprElem.x = element.matrix.position.getPosition().x;
                    smSprElem.y = element.matrix.position.getPosition().y;
                    smSprElem.scaleX = element.matrix.scaling.getScale().x;
                    smSprElem.scaleY = element.matrix.scaling.getScale().y;
                    smSprElem.rotation = Math.degToRad(element.matrix.rotation.getDirection().z);

                    parent.sBatch.add(smSprElem);
                }
            }
        }
    }
    
    function checkIfOptimized(json:Dynamic) {
        _optimizedAnimJson = json.AN != null ? true : false;
    }
    override public function update(dt:Float) {
        super.update(dt);
    }

}