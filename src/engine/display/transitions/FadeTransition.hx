package engine.display.transitions;

import h2d.Bitmap;

class FadeTransition extends BaseTransition {
	var fade:Bitmap;
	
	public function new(?color:Int = 0x000000) {
		super();
		fade = Sprite.simpleBitmap(0, 0, 1280, 720, color, 1, this); // change this to get the default game size values later
		fade.alpha = 0;
	}
	
	override public function update(dt:Float) {
		super.update(dt);
		
		if (isTransIn) {
			if (!finishedTransition) fade.alpha = 1 - (timeLeft / initialTime);
			else fade.alpha = 1;
		} else {
			if (!finishedTransition) fade.alpha = (timeLeft / initialTime);
			else fade.alpha = 0;
		}
	}
}
