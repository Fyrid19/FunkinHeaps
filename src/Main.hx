package;

import engine.backend.Signal;
import engine.display.debug.DebugDisplay;
import engine.game.HeapsGame;

class Main extends hxd.App {
    public var heapsGame:HeapsGame; // the root scene of everything in the game
    public var debugDisplay:DebugDisplay; // for things like fps and memory and such

    public var initialState = funkin.test.ConductorTestState; // state that the game starts on

    override function init() {
        Res.initEmbed();
        Res.initLocal();

        heapsGame = new HeapsGame(s3d);

        HeapsStateManager.game = heapsGame;
        HeapsStateManager.setState(initialState);
        
        setScene(heapsGame);
        
        debugDisplay = new DebugDisplay(6, 4, s2d);
    }

    override function update(dt:Float) {        
        heapsGame.update(dt);
        HeapsStateManager.update(dt); // don't know if putting this here would be better
        super.update(dt);
    }
    
    override function dispose()
    {
        heapsGame.dispose();
        super.dispose();
    }

    static function main() {
        new Main();
    }
}