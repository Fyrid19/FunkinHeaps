package engine.game.state;

class HeapsStateManager {
	static public var game:HeapsGame;
	
	public static function init(_game:HeapsGame, _initialState:Class<MusicBeatState>) {
		game = _game;
		switchState(_initialState, true);
	}
	
	static function addState(newState:Class<MusicBeatState>) {
		var _newState:MusicBeatState = cast Type.createInstance(newState, []);
		game.addChild(_newState);
		_newState.create();
	}
	
	static public function switchState(nextState:Class<MusicBeatState>, ?skipTransition:Bool = false) {
		if (!skipTransition) {
			game.transSprite.transIn(() -> {
				game.removeChildren();
				addState(nextState);
				game.onStateSwitch();
			});
		} else {
			game.removeChildren();
			addState(nextState);
			game.onStateSwitch();
			
			game.transSprite.transOut();
		}
	}
	
	static public function update(dt:Float) {
		for (i in 0...game.numChildren) {
			var object:Object = game.getChildAt(i);
			
			if (object is MusicBeatState) {
				var state:MusicBeatState = cast(object, MusicBeatState);
				state?.update(dt);
			}
		}
	}
	
	static public function destroy() {
		for (i in 0...game.numChildren) {
			var object:Object = game.getChildAt(i);
			
			if (object is MusicBeatState) {
				var state:MusicBeatState = cast(object, MusicBeatState);
				state?.destroy();
				game.removeChild(object);
			}
		}
	}
}
