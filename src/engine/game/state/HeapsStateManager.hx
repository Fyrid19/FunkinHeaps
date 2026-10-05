package engine.game.state;

class HeapsStateManager
{            
    static public var game:HeapsGame;
        
    static public function addState(newState:Class<HeapsState>)
    {
        var _newState:HeapsState = cast Type.createInstance(newState, []);
        game.addChild(_newState);
        _newState.create();
    }
    
    static public function setState(newState:Class<HeapsState>)
    {
        // clear the states lolol
        game.removeChildren();
        
        addState(newState);
    }
    
    static public function update(dt:Float)
    {
        for (i in 0...game.numChildren)
        {
            var object:h2d.Object = game.getChildAt(i);
            
            if (object is HeapsState)
            {
                var state:HeapsState = cast(object, HeapsState);
                state?.update(dt);
            }
        }
    }
    static public function destroy()
    {
        for (i in 0...game.numChildren)
        {
            var object:h2d.Object = game.getChildAt(i);
            
            if (object is HeapsState)
            {
                var state:HeapsState = cast(object, HeapsState);
                state?.destroy();
                game.removeChild(object);
            }
        }
    }
}