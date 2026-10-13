package engine.game;

import hxd.snd.Manager;

import engine.display.debug.DebugDisplay;
import engine.display.VolumeTray;

import engine.backend.input.InputController;
import engine.backend.Signal;

class HeapsGame extends h2d.Scene
{        
    //TEMPORARY PROBABLY I DONT LIKE THIS LOLL - ev
    public var s3d:h3d.scene.Scene;

    public var debugDisplay:DebugDisplay; // for things like fps and memory and such
    public var volumeTray:VolumeTray; 
    public var volumeTime:Float = 0;

    public var preUpdateSignal:Signal = new Signal();
    public var postUpdateSignal:Signal = new Signal();
    
    var manager:Manager = Manager.get();
    
    public function new(s3d:h3d.scene.Scene, ?width:Int = 1280, ?height:Int = 720)
    {
        super();
        
        this.s3d = s3d;

        this.scaleMode = ScaleMode.LetterBox(width, height);
        
        debugDisplay = new DebugDisplay(6, 4, this);

        volumeTray = new VolumeTray(manager, this);
        volumeTray.x = this.width/2 - volumeTray.back.width/2;
        volumeTray.y = 4;
        volumeTray.alpha = 0;
    }
    
    public function update(dt:Float) {
        preUpdateSignal.dispatch();
        HeapsStateManager.update(dt);
        postUpdateSignal.dispatch();

        if (volumeTime > 0) volumeTime -= dt;
        volumeTray.alpha = Math.clamp(volumeTime);

        if (InputController.getInput('volume_up', PRESS)) {
            manager.masterVolume += 0.1;
            volumeTime = 2;
        } else if (InputController.getInput('volume_down', PRESS)) {
            manager.masterVolume -= 0.1;
            volumeTime = 2;
        }
    }

    public function onStateSwitch() {
        debugDisplay.remove();
        volumeTray.remove();
        add(debugDisplay);
        add(volumeTray);
    }
}