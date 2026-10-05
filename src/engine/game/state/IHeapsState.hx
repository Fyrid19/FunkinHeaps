package engine.game.state;

interface IHeapsState
{
    public function create():Void;
    
    public function update(dt:Float):Void;
    
    public function destroy():Void;
}