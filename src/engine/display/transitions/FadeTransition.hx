package engine.display.transitions;

import h2d.Bitmap;

class FadeTransition extends BaseTransition {
	var fade:Bitmap;
	
	public function new(?color:Int = 0x000000) {
		super();
		
		transInTime = 0.5;
		transOutTime = 0.5;
		
		fade = Sprite.simpleBitmap(0, 0, HioG.width, HioG.height, color, 1, this);
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
