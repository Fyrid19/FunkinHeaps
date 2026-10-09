package;

import engine.backend.Signal;
import engine.display.debug.DebugDisplay;
import engine.game.HeapsGame;

class Main extends hxd.App {
    public var debugDisplay:DebugDisplay; // for things like fps and memory and such

    public var initialState = funkin.test.AnimateTestState; // state that the game starts on

    override function init() {
        Res.initEmbed();
        Res.initLocal();
        
        HeapsStateManager.game = new HeapsGame(s3d);
        HeapsStateManager.setState(initialState);
        setScene(HeapsStateManager.game);
        
        debugDisplay = new DebugDisplay(6, 4, s2d);
    }

    override function update(dt:Float) {        
        HeapsStateManager.game.update(dt);
        // HeapsStateManager.update(dt); // don't know if putting this here would be better - kaylee // its in heapsGame because it makes main look nicer and heapsGame is meant to be the root Game class thing - ev
        super.update(dt);
    }
    
    override function dispose()
    {
        HeapsStateManager.game.dispose();
        super.dispose();
    }

    static function main() {
        new Main();
    }
}