package;

import engine.game.HeapsGame;

class Main extends hxd.App {
	public var initialState = funkin.menus.MainMenuState; // state that the game starts on

	override function init() {
		Res.initEmbed();
		Res.initLocal();

		Conductor.instance.initConductor();

		HeapsStateManager.init(new HeapsGame(s3d), initialState);
		setScene(HeapsStateManager.game);

		// trace('error', ERROR);
		// trace('warning', WARNING);
		// trace('log', LOG);

		// DiscordUtil.init();
	}

	override function update(dt:Float) {
		HeapsStateManager.game.update(dt);
		Conductor.instance.update(dt);
		super.update(dt);

		// debug stuff
		if (hxd.Key.isPressed(hxd.Key.F1)) HeapsStateManager.setState(funkin.test.AnimateTestState);
		if (hxd.Key.isPressed(hxd.Key.F2)) HeapsStateManager.setState(funkin.test.SparrowTestState);
		if (hxd.Key.isPressed(hxd.Key.F3)) HeapsStateManager.setState(funkin.test.ConductorTestState);
	}

	override function dispose() {
		trace('dipose');
		HeapsStateManager.game.dispose();
		// DiscordUtil.shutdown();
		super.dispose();
	}

	static function main() {
		haxe.Log.trace = onLog;

		new Main();
	}

	static function onLog(v:Dynamic, ?infos:haxe.PosInfos) { // i like this it makes the traces pretty.. could also set up a logger system with this - kay
		var type:TraceType = LOG;
		var customType:String = '';
		if (infos.customParams != null) {
			type = cast(infos.customParams[0], TraceType);
			customType = cast(infos.customParams[1], String) ?? "\033[32m[LOG]\033[92m";
		}

		var prefix:String = switch (type) {
			case ERROR: "\033[31m[ERROR]\033[91m";
			case WARNING: "\033[33m[WARNING]\033[93m";
			case CUSTOM: customType;
			default: "\033[32m[LOG]\033[92m";
		}

		Sys.println('$prefix ${infos.fileName}:${infos.lineNumber}: $v\033[0m');
	};
}
