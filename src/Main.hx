package;

import engine.backend.input.InputController;
import engine.backend.Signal;
import engine.display.debug.DebugDisplay;
import engine.game.HeapsGame;

class Main extends hxd.App {
    public var debugDisplay:DebugDisplay; // for things like fps and memory and such

    public var initialState = funkin.test.ConductorTestState; // state that the game starts on

    override function init() {
        Res.initEmbed();
        Res.initLocal();
        
        HeapsStateManager.game = new HeapsGame(s3d);
        HeapsStateManager.setState(initialState);
        setScene(HeapsStateManager.game);

        // DiscordUtil.init();
        
        debugDisplay = new DebugDisplay(6, 4, s2d);
    }

    override function update(dt:Float) {        
        HeapsStateManager.game.update(dt);
        super.update(dt);
    }
    
    override function dispose()
    {
        trace('dipose');
        HeapsStateManager.game.dispose();
        // DiscordUtil.shutdown();
        super.dispose();
    }

    static function main() {
        new Main();
    }
}