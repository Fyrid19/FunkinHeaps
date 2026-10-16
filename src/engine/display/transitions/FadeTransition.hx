package engine.display.transitions;

import h2d.Bitmap;

class FadeTransition extends BaseTransition {
	var fade:Bitmap;
	
	public function new(?color:Int = 0x000000) {
		super();
		fade = Sprite.simpleBitmap(0, 0, 1280, 720, color, 0, this); // change this to get the default game size values later
	}
	
	override public function transIn(?onEnd:Void->Void, ?time:Float = 1.2) {
		finishedTransition = false;
		
		var timeLeft = time;
		
		while (timeLeft > 0) {
			timeLeft -= hxd.Timer.dt;
			fade.alpha = timeLeft / time;
		}
		
		finishedTransition = true;
		if (onEnd != null) onEnd();
	}
	
	override public function transOut(?onEnd:Void->Void, ?time:Float = 0.8) {
		finishedTransition = false;
		
		var timeLeft = time;
		
		while (timeLeft > 0) {
			timeLeft -= hxd.Timer.dt;
			fade.alpha = -(timeLeft / time);
		}
		
		finishedTransition = true;
		if (onEnd != null) onEnd();
	}
}
