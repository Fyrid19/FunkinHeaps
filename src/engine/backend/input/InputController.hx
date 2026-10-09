package engine.backend.input;

import hxd.Pad;
import hxd.Key;

enum InputType {
    PRESS;
    RELEASE;
    HOLD;
}

// controller support soon
class Input { // this feels stupid. i don't know if it is yet.
    public var bindId:String = '';

    public var canTurbo:Bool = true;
    public var turboStart:Bool = false;
    public var turboTimer:Float = 0;

    public var P(get, never):Bool; // PRESS
    public var R(get, never):Bool; // RELEASE
    public var H(get, never):Bool; // HOLD

    public function get_P() return InputController.getInput(bindId, PRESS) || (H && turboTimer == 0.2);
    public function get_R() return InputController.getInput(bindId, RELEASE);
    public function get_H() return InputController.getInput(bindId, HOLD);

    public function new(id:String, ?canTurbo:Bool = true) {
        this.bindId = id;
        this.canTurbo = canTurbo;
    }

    // this lowk looks ugly as fuckkkk, also gotta figure out how to do this
    public function update(dt:Float) {
        if (!turboStart) {
            if (P && H) {
                turboStart = true;
                turboTimer = -0.6;
            }
        } else {
            if (H) {
                turboTimer += dt;

                if (turboTimer >= 0.2) {
                    turboTimer = 0;
                }
            } else {
                turboStart = false;
                turboTimer = 0;
            }
        }
    }
}

class InputController {
    public static var keybindMap:Map<String, Array<Int>> = [
        'menu_left'     => [Key.A, Key.LEFT],
        'menu_down'     => [Key.S, Key.DOWN],
        'menu_up'       => [Key.W, Key.UP],
        'menu_right'    => [Key.D, Key.RIGHT],

        'note_left'     => [Key.A, Key.LEFT],
        'note_down'     => [Key.S, Key.DOWN],
        'note_up'       => [Key.W, Key.UP],
        'note_right'    => [Key.D, Key.RIGHT],

        'volume_up'     => [Key.NUMPAD_ADD],
        'volume_down'   => [Key.NUMPAD_SUB],

        'confirm'       => [Key.ENTER, Key.NUMPAD_ENTER],
        'back'          => [Key.BACKSPACE],
        'reset'         => [Key.R]
    ];

    public static function getInput(id:String, type:InputType):Bool {
        var bindArray:Array<Int> = keybindMap.get(id);

        // could see if there's a better way later
        var bindDown:Int = -1;
        for (i in 0...bindArray.length) {
            if (Key.isDown(bindArray[i])) bindDown = bindArray[i];
        }

        switch (type) {
            case PRESS: return Key.isPressed(bindDown);
            case RELEASE: return Key.isReleased(bindDown);
            case HOLD: return Key.isDown(bindDown);
        }
    }

    public var MENU_LEFT:Input = new Input('menu_left');
    public var MENU_DOWN:Input = new Input('menu_down');
    public var MENU_UP:Input = new Input('menu_up');
    public var MENU_RIGHT:Input = new Input('menu_right');
    
    public var NOTE_LEFT:Input = new Input('note_left');
    public var NOTE_DOWN:Input = new Input('note_down');
    public var NOTE_UP:Input = new Input('note_up');
    public var NOTE_RIGHT:Input = new Input('note_right');
    
    // these should probably just be for main primarily, but they're here too
    public var VOLUME_UP:Input = new Input('volume_up');
    public var VOLUME_DOWN:Input = new Input('volume_down');

    public function new() {}
}