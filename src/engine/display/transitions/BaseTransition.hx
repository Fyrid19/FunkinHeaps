package engine.display.transitions;

class BaseTransition extends Object {
	public var finishedTransition:Bool = false;
	
	public function new() {
		super();
	}
	
	public function transIn(?onEnd:Void->Void, ?time:Float) {}
	
	public function transOut(?onEnd:Void->Void, ?time:Float) {}
}
