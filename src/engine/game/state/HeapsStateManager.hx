package engine.game.state;

class HeapsStateManager {
	static public var game:HeapsGame;
	
	public static function init(_game:HeapsGame, _initialState:Class<MusicBeatState>) {
		game = _game;
		switchState(_initialState, true);
	}
	
	static public function addState(newState:Class<MusicBeatState>) {
		var _newState:MusicBeatState = cast Type.createInstance(newState, []);
		game.addChild(_newState);
		_newState.create();
	}
	
	static public function switchState(newState:Class<MusicBeatState>, ?skipTransition:Bool = false) {
		if (!skipTransition) {
			game.transSprite.transIn(() -> {
				// clear the states lolol
				game.removeChildren();
				
				// maybe clear conductor signals here? im not sure though it might break some shit
				
				addState(newState);
				game.onStateSwitch();
			});
		} else {
			// clear the states lolol
			game.removeChildren();
			
			// maybe clear conductor signals here? im not sure though it might break some shit
			
			addState(newState);
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
