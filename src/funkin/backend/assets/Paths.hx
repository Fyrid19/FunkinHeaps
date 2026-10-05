package funkin.backend.assets;

import hxd.res.Image;
import hxd.res.Sound;
import hxd.snd.Channel;

class Paths {
    public static var imageCache:Map<String, Image> = new Map();
    public static var soundCache:Map<String, Sound> = new Map();

    public static function getPath(key:String, ?folder:String):String {
        return (folder != null ? folder + "/" : "") + key;
    }

    public static function image(key:String, ?ext:String = "png", ?folder:String = null):Image {
        var path = getPath('images/$key.$ext', folder);

        if (!imageCache.exists(path))
            imageCache.set(path, Res.load(path).toImage());

        return imageCache.get(path);
    }

    public static function music(key:String, ?ext:String = "ogg", ?folder:String = null):Channel {
        var path = getPath('music/$key.$ext', folder);

        if (!soundCache.exists(path)) 
            soundCache.set(path, Res.load(path).toSound());

        var channel = soundCache.get(path).play();
        channel.pause = true;
        return channel;
    }

    public static function sound(key:String, ?ext:String = "ogg", ?folder:String = null):Sound {
        var path = getPath('sounds/$key.$ext', folder);

        if (!soundCache.exists(path)) 
            soundCache.set(path, Res.load(path).toSound());

        var channel = soundCache.get(path);
        return channel;
    }

    public static function inst(song:String, ?ext:String = "ogg", ?folder:String = null):Channel {
        var path = getPath('songs/$song/Inst.$ext', folder);

        if (!soundCache.exists(path)) 
            soundCache.set(path, Res.load(path).toSound());

        var channel = soundCache.get(path).play();
        channel.pause = true;
        return channel;
    }

    public static function voices(song:String, ?suffix:String = "", ?ext:String = "ogg", ?folder:String = null):Channel {
        var path = getPath('songs/$song/Voices$suffix.$ext', folder);

        if (!soundCache.exists(path)) 
            soundCache.set(path, Res.load(path).toSound());

        var channel = soundCache.get(path).play();
        channel.pause = true;
        return channel;
    }

    public static function json(key:String, ?folder:String = null):Dynamic {
        var path = getPath('$key.json', folder);
        var jsonData = Res.load(path).toText();
        return haxe.Json.parse(jsonData);
    }
}