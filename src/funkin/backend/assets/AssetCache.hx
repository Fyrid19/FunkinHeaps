package funkin.backend.assets;

import sys.FileSystem;

import hxd.res.Sound;
import hxd.res.Image;

// notes taken from my old code
class AssetCache {
    public var imageCache:Map<String, Image> = [];
    var backupImageCache:Map<String, Image> = [];
    public var soundCache:Map<String, Sound> = [];
    var backupSoundCache:Map<String, Sound> = [];

    public function new() {
        imageCache = new Map<String, Image>();
        backupImageCache = new Map<String, Image>();
        soundCache = new Map<String, Sound>();
        backupSoundCache = new Map<String, Sound>();
    }

    public function clearCaches() {
        backupImageCache = imageCache;
        imageCache = [];
        backupSoundCache = soundCache;
        soundCache = [];
        trace('CACHES CLEARED');
    }

    public function cacheImage(key:String, ?asset:Image):Image {
        if (imageCache.exists(key)) {
            trace('Image ($key) exists in cache!', WARNING);
            return imageCache.get(key);
        }

        if (backupImageCache.exists(key)) {
            imageCache.set(key, backupImageCache.get(key));
            backupImageCache.remove(key);
            return imageCache.get(key);
        }

        if (asset != null) {
            imageCache.set(key, asset);
        } else {
            var image:Image;
            if (FileSystem.exists('assets/$key')) {
                image = Res.load(key).toImage();
            } else {
                trace('Image ($key) not found!', ERROR);
                return Res.images.hxlogo;
            }
            
            imageCache.set(key, image);
        }

        return imageCache.get(key);
    }

    public function cacheSound(key:String, ?asset:Sound):Sound {
        if (soundCache.exists(key)) {
            trace('Sound ($key) exists in cache!', WARNING);
            return soundCache.get(key);
        }

        if (backupSoundCache.exists(key)) {
            soundCache.set(key, backupSoundCache.get(key));
            backupSoundCache.remove(key);
            return soundCache.get(key);
        }

        if (asset != null) {
            soundCache.set(key, asset);
        } else {
            var sound:Sound;
            if (FileSystem.exists('assets/$key')) {
                sound = Res.load(key).toSound();
            } else {
                trace('Sound ($key) not found!', ERROR);
                return Res.sounds.metronome;
            }
            
            soundCache.set(key, sound);
        }

        return soundCache.get(key);
    }

    public function getImage(key:String) {
        if (!imageCache.exists(key))
            return cacheImage(key);
        else
            return imageCache.get(key);
    }

    public function getSound(key:String) {
        if (!soundCache.exists(key))
            return cacheSound(key);
        else
            return soundCache.get(key);
    }
}