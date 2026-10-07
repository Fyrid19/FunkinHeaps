package;

import engine.backend.Signal;
import engine.display.debug.DebugDisplay;
import engine.game.HeapsGame;

class Main extends hxd.App {
    public var heapsGame:HeapsGame; // the root scene of everything in the game
    public var debugDisplay:DebugDisplay; // for things like fps and memory and such

    override function init() {
        Res.initEmbed();
        Res.initLocal();

        heapsGame = new HeapsGame(funkin.test.SparrowTestState, s3d);
        setScene(heapsGame);
        
        debugDisplay = new DebugDisplay(15, 15, s2d);
    }

    override function update(dt:Float) {        
        heapsGame.update(dt);
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