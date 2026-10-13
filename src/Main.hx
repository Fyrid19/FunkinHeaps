package;

import hxd.Window;
import hxd.snd.Manager;

import engine.backend.input.InputController;
import engine.display.debug.DebugDisplay;
import engine.display.VolumeTray;
import engine.game.HeapsGame;

enum TraceType {
    LOG;
    ERROR;
    WARNING;
    CUSTOM;
}

class Main extends hxd.App {
    public var debugDisplay:DebugDisplay; // for things like fps and memory and such
    public var volumeTray:VolumeTray; 
    public var volumeTime:Float = 0;

    public var initialState = funkin.menus.MainMenuState; // state that the game starts on

    var manager:Manager = Manager.get();

    override function init() {
        Res.initEmbed();
        Res.initLocal();

        // var oldTrace = haxe.Log.trace;
        haxe.Log.trace = function(v:Dynamic, ?infos:haxe.PosInfos) { // i like this it makes the traces pretty.. could also set up a logger system with this
            var type:TraceType = LOG;
            var customType:String = '';
            if (infos.customParams != null) {
                type = cast(infos.customParams[0], TraceType);
                customType = cast(infos.customParams[1], String) ?? "\033[32m[LOG]\033[92m";
            }

            var prefix:String = switch(type) {
                case ERROR:
                    "\033[31m[ERROR]\033[91m";
                case WARNING:
                    "\033[33m[WARNING]\033[93m";
                case CUSTOM:
                    customType;
                default:
                    "\033[32m[LOG]\033[92m";
            }

            Sys.println('$prefix ${infos.fileName}:${infos.lineNumber}: $v\033[0m');
        };
        
        HeapsStateManager.game = new HeapsGame(s3d);
        HeapsStateManager.setState(initialState);
        setScene(HeapsStateManager.game);
        
        debugDisplay = new DebugDisplay(6, 4, s2d);

        volumeTray = new VolumeTray(manager, s2d);
        volumeTray.x = s2d.width/2 - volumeTray.back.width/2;
        volumeTray.y = 4;
        volumeTray.alpha = 0;

        // trace('error', ERROR);
        // trace('warning', WARNING);
        // trace('log', LOG);
        
        // DiscordUtil.init();
    }

    override function update(dt:Float) {        
        HeapsStateManager.game.update(dt);
        super.update(dt);

        if (volumeTime > 0) volumeTime -= dt;
        volumeTray.alpha = Math.clamp(volumeTime);

        if (InputController.getInput('volume_up', PRESS)) {
            manager.masterVolume += 0.1;
            volumeTime = 2;
        } else if (InputController.getInput('volume_down', PRESS)) {
            manager.masterVolume -= 0.1;
            volumeTime = 2;
        }

        manager.masterVolume = Math.clamp(manager.masterVolume);
    }
    
    override function dispose()
    {
        trace('dipose');
        HeapsStateManager.game.dispose();
        // DiscordUtil.shutdown();
        super.dispose();
    }

    static function main() {
        new Main();
    }
}