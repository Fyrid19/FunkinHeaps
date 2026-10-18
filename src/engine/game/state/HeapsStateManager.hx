package engine.game.state;

class HeapsStateManager {
	static public var game:HeapsGame;
	
	public static function init(_game:HeapsGame, _initialState:Class<HeapsState>) {
		game = _game;
		switchState(_initialState, false);
	}
	
	static public function addState(newState:Class<HeapsState>) {
		var _newState:HeapsState = cast Type.createInstance(newState, []);
		game.addChild(_newState);
		_newState.create();
	}
	
	static public function switchState(newState:Class<HeapsState>, ?doTrans:Bool = true) {
		if (doTrans) {
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
		}
	}
	
	static public function update(dt:Float) {
		for (i in 0...game.numChildren) {
			var object:Object = game.getChildAt(i);
			
			if (object is HeapsState) {
				var state:HeapsState = cast(object, HeapsState);
				state?.update(dt);
			}
		}
	}
	
	static public function destroy() {
		for (i in 0...game.numChildren) {
			var object:Object = game.getChildAt(i);
			
			if (object is HeapsState) {
				var state:HeapsState = cast(object, HeapsState);
				state?.destroy();
				game.removeChild(object);
			}
		}
	}
}
