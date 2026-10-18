package engine.display.transitions;

class BaseTransition extends Object {
	var isTransIn:Bool;
	var initialTime:Float;
	var timeLeft:Float;
	var onEnd:Void->Void;
	
	var defaultTransTime:Float = 0.6;
	
	public var finishedTransition:Bool = false;
	
	public function new() {
		super();
	}
	
	public function transIn(?onEnd:Void->Void, ?time:Float) {
		this.onEnd = onEnd;
		
		finishedTransition = false;
		isTransIn = true;
		initialTime = timeLeft = time ?? defaultTransTime;
	}
	
	public function transOut(?onEnd:Void->Void, ?time:Float) {
		this.onEnd = onEnd;
		
		finishedTransition = false;
		isTransIn = false;
		initialTime = timeLeft = time ?? defaultTransTime;
	}
	
	public function update(dt:Float) {
		if (timeLeft > 0) timeLeft -= dt;
		else if (!finishedTransition) {
			if (onEnd != null) onEnd();
			finishedTransition = true;
			if (isTransIn) transOut();
		}
	}
}
