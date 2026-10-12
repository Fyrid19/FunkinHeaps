package funkin.backend.assets;

import hxd.res.BitmapFont;
import sys.FileSystem;

import hxd.res.Font;
import hxd.res.Image;
import hxd.res.Sound;
import hxd.snd.Channel;

class Paths {
    static var imageCache:Map<String, Image> = new Map();
    static var soundCache:Map<String, Sound> = new Map();

    public static function getPath(key:String, ?folder:String):String {
        return (folder != null ? folder + "/" : "") + key;
    }

    public static function image(key:String, ?ext:String = "png", ?folder:String = null):Image {
        var path = getPath('images/$key.$ext', folder);

        // fallback image to prevent crashes
        if (!FileSystem.exists('assets/$path')) {
            trace('File ($path) not found!');
            return Res.images.hxlogo;
        }

        if (!imageCache.exists(path))
            imageCache.set(path, Res.load(path).toImage());

        return imageCache.get(path);
    }

    public static function music(key:String, ?ext:String = "ogg", ?folder:String = null):Channel {
        var path = getPath('music/$key.$ext', folder);
        
        // fallback sound to prevent crashes
        if (!FileSystem.exists('assets/$path')) {
            trace('File ($path) not found!');
            return Res.sounds.metronome.play();
        }

        if (!soundCache.exists(path)) 
            soundCache.set(path, Res.load(path).toSound());

        var channel = soundCache.get(path).play();
        channel.pause = true;
        return channel;
    }

    public static function sound(key:String, ?ext:String = "ogg", ?folder:String = null):Sound {
        var path = getPath('sounds/$key.$ext', folder);

        // fallback sound to prevent crashes
        if (!FileSystem.exists('assets/$path')) {
            trace('File ($path) not found!');
            return Res.sounds.metronome;
        }

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
        var data = Res.load(path).toText();
        
        // so it can parse jsons encoded in UTF-8 with BOM - ev
        if (data.charCodeAt(0) == 0xFEFF) {
            data = data.substr(1);
        }
        
        return haxe.Json.parse(data);
    }
    
    public static function xml(key:String, ?folder:String = null):Dynamic {
        var path = getPath('$key.xml', folder);
        var data = Res.load(path).toText();
        return haxe.xml.Parser.parse(data);
    }

    // based off of DefaultFont - kaylee
    public static function font(font:String, ?size:Int = 24, ?folder:String = null):h2d.Font {
        var path = getPath('fonts/$font', folder);
        var bytes = Res.load('$path/$font.png');
        var desc = Res.load('$path/$font.fnt');
        var bmp = new BitmapFont(desc.entry);
        @:privateAccess bmp.loader = bytes.loader;

        var fnt = bmp.toFont();
        fnt.resizeTo(size);
        return fnt;
    }
    
    // little thing so its less annoying - ev
    public static function sparrow(img:hxd.res.Image, ?folder:String = null):Dynamic {
        return Paths.xml(StringTools.replace(img.entry.path, ".png", ""), folder);
    }
    public static function animate(name:String, ?folder:String = null):Dynamic {
        return Paths.json('images/$name/spritemap1', folder);
    }
}