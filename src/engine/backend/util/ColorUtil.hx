package engine.backend.util;

import h3d.Vector4;

using StringTools;

// just a small thing that helps with colors
class ColorUtil {
    public static function fromRGBA(r:Float, g:Float, b:Float, a:Float) {
        return new Vector4(r/255, g/255, b/255, a);
    }
}