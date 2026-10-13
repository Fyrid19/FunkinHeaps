package engine.display.sprite.animation.animate.elements;

import engine.display.sprite.animation.animate.AnimateAnimation;

import engine.display.sprite.animation.animate.AnimateElement;

class AnimateAtlasElement extends AnimateElement
{    
    public var sprite:AnimateSpritemapSprite;
    
    public function new(data:AnimateJson.AtlasInstanceJson, frame:AnimateFrame) {
        super(ElementType.ATLAS, data, frame);
                
        name = data.N;
        matrix = matrix2DTo3D(data.MX);
        
        sprite = frame.layer.timeline.parent.smSprites.get(name);
    }

}