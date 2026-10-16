package engine.game.state;

import engine.display.transitions.FadeTransition;
import engine.display.transitions.BaseTransition;

class HeapsStateManager {
	static public var game:HeapsGame;
	
	static var transitionSprite:BaseTransition;
	static var _defaultTransition:FadeTransition;
	
	public static function init(_game:HeapsGame, _initialState:Class<HeapsState>) {
		game = _game;
		_defaultTransition = new FadeTransition();
		switchState(_initialState, false);
	}
	
	static public function addState(newState:Class<HeapsState>) {
		var _newState:HeapsState = cast Type.createInstance(newState, []);
		game.addChild(_newState);
		_newState.create();
	}
	
	static public function switchState(newState:Class<HeapsState>, ?doTrans:Bool = true, ?transition:BaseTransition) {
		// if (doTrans) {
		// 	if (transition == null) {
		// 		transition = _defaultTransition;
		// 	}
		
		// 	game.add(transitionSprite);
		// 	transitionSprite = transition;
		// 	transitionSprite.transIn(() -> {
		// 		// clear the states lolol
		// 		game.removeChildren();
		
		// 		// maybe clear conductor signals here? im not sure though it might break some shit
		
		// 		addState(newState);
		// 		game.onStateSwitch();
		
		// 		transitionSprite.transOut(() -> {
		// 			transitionSprite.remove();
		// 		});
		// 	});
		// } else {
		// clear the states lolol
		game.removeChildren();
		
		// maybe clear conductor signals here? im not sure though it might break some shit
		
		addState(newState);
		game.onStateSwitch();
		// }
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
