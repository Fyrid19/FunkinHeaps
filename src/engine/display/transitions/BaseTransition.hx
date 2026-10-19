package engine.display.transitions;

class BaseTransition extends Object {
	var isTransIn:Bool;
	var initialTime:Float;
	var timeLeft:Float;
	var onEnd:Void->Void;
	
	var defaultTransTime:Float = 0.6;
	
	var transInTime:Null<Float>;
	var transOutTime:Null<Float>;
	
	public var finishedTransition:Bool = false;
	
	public function new() {
		super();
	}
	
	public function transIn(?onEnd:Void->Void) {
		this.onEnd = onEnd;
		
		finishedTransition = false;
		isTransIn = true;
		initialTime = timeLeft = transInTime ?? defaultTransTime;
	}
	
	public function transOut(?onEnd:Void->Void) {
		this.onEnd = onEnd;
		
		finishedTransition = false;
		isTransIn = false;
		initialTime = timeLeft = transOutTime ?? defaultTransTime;
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
