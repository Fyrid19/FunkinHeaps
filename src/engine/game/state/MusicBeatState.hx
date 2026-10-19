package engine.game.state;

import engine.backend.input.InputController;

class MusicBeatState extends h2d.Scene implements IHeapsState {
	public var controls:InputController = new InputController();
	
	public function new():Void {
		super();
	}
	
	public function create():Void {
		Conductor.instance.onStepHit.add(stepHit);
		Conductor.instance.onBeatHit.add(beatHit);
		Conductor.instance.onMeasureHit.add(measureHit);
	}
	
	public function update(dt:Float):Void {}
	
	public function destroy():Void {}
	
	public function stepHit():Void {}
	
	public function beatHit():Void {}
	
	public function measureHit():Void {}
}
