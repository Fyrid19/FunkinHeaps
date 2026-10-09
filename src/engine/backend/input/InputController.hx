package engine.backend.input;

import hxd.Pad;
import hxd.Key;

enum InputType {
    PRESS;
    RELEASE;
    HOLD;
    TURBO;
}

// controller support soon
class Input { // this feels stupid. i don't know if it is yet.
    public var bindId:String = '';
    public var turboTimer:Float = 0; // for later

    public var P(get, never):Bool; // PRESS
    public var R(get, never):Bool; // RELEASE
    public var H(get, never):Bool; // HOLD
    public var T(get, never):Bool; // TURBO

    public function get_P() return InputController.getInput(bindId, PRESS);
    public function get_R() return InputController.getInput(bindId, RELEASE);
    public function get_H() return InputController.getInput(bindId, HOLD);
    public function get_T() return InputController.getInput(bindId, TURBO);

    public function new(id:String) {
        this.bindId = id;
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

        // NEED TO FIND SOME WAY TO GET THE KEY BEING PRESSED AND IF IT'S IN THE ARRAY
        var bindDown:Int = 0;
        for (i in 0...bindArray.length) {
            if (Key.isDown(bindArray[i])) bindDown = bindArray[i];
        }

        switch (type) {
            case PRESS: return Key.isPressed(bindDown);
            case RELEASE: return Key.isReleased(bindDown);
            case HOLD: return Key.isDown(bindDown);
            case TURBO: return Key.isPressed(bindDown);
        }
    }

    public function new() {

    }
}