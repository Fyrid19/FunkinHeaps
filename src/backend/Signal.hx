package backend;

class Signal {
    public var functions:Array<Void->Void>;

    public function new() {
        this.functions = [];
    }

    public function add(f:Void->Void) {
        this.functions.push(f);
    }

    public function clear() {
        this.functions = [];
    }

    public function dispatch() {
        for (f in this.functions) {
            f();
        }
    }
}