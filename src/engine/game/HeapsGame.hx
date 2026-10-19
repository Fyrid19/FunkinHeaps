package engine.game;

import hxd.snd.Manager;

import engine.backend.Signal;
import engine.display.transitions.BaseTransition;
import engine.display.transitions.FadeTransition;
import engine.display.debug.DebugDisplay;
import engine.display.VolumeTray;

class HeapsGame extends h2d.Scene {
	// TEMPORARY PROBABLY I DONT LIKE THIS LOLL - ev
	// public var s3d:h3d.scene.Scene; // removed temporarily as it isn't needed
	public var transSprite:BaseTransition; // ehehefhehe
	public var debugDisplay:DebugDisplay; // for things like fps and memory and such
	public var volumeTray:VolumeTray;
	
	public var preUpdateSignal:Signal = new Signal();
	public var postUpdateSignal:Signal = new Signal();
	
	public function new(?width:Int = 1280, ?height:Int = 720) {
		super();
		
		// this.s3d = s3d;
		this.scaleMode = ScaleMode.LetterBox(width, height);
		this.camera.clipViewport = true;
		
		transSprite = new FadeTransition();
		
		debugDisplay = new DebugDisplay(6, 4, this);
		volumeTray = new VolumeTray(this);
	}
	
	// definitely very flimsy, will change later
	public function changeTransition(newTrans:BaseTransition) {
		transSprite = newTrans;
	}
	
	public function update(dt:Float) {
		preUpdateSignal.dispatch();
		HeapsStateManager.update(dt);
		postUpdateSignal.dispatch();
		
		transSprite.update(dt);
		
		volumeTray.update(dt);
	}
	
	public function onStateSwitch() {
		transSprite.remove();
		debugDisplay.remove();
		volumeTray.remove();
		add(transSprite);
		add(debugDisplay);
		add(volumeTray);
	}
}
