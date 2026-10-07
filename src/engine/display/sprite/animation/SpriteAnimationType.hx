package engine.display.sprite.animation;

enum abstract SpriteAnimationType(String) from String to String {
    var NONE = "";
    var SPARROW = "sparrow";
    var ANIMATE = "animate";
    var PACKER = "packer";
    var ASEPRITE = "aseprite";
}