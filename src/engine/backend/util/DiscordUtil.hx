package engine.backend.util; // took some notes from the awesome mod Tom's Birthday Bash (i coded it)

// FUUUUUCK im gonna kill myself
#if cpp
import hxdiscord_rpc.Discord;
import hxdiscord_rpc.Types;
import sys.thread.Thread;

@:structInit class PresenceDetails {
    public var state:String = "";
    public var details:String = "";
    public var largeImageKey:String = "largeImage";
    public var largeImageText:String = "Friday Night Funkin'";
    public var smallImageKey:String = "";
    public var smallImageText:String = "";
    public var hasStartTimestamp:Bool = false;
    public var endTimestamp:Float = 0;
}

class DiscordUtil {
    public static var initialized:Bool = false;
    public static var clientID:String = "";
    private static var presence:DiscordRichPresence = new DiscordRichPresence();

    public static function init() {
        setupClient();

        Thread.create(() -> {
			while (true) {
				Discord.UpdateConnection();
				Discord.RunCallbacks();
				Sys.sleep(1); // doesn't need to update very often, can be lenient with the timer
			}
		});
    }

    public static function shutdown() {
        Discord.Shutdown();
        initialized = false;
    }

    private static function setupClient(?params:PresenceDetails = null) {
        var handlers:DiscordEventHandlers = new DiscordEventHandlers();
		handlers.ready = cpp.Function.fromStaticFunction(onReady);
		handlers.disconnected = cpp.Function.fromStaticFunction(onDisconnected);
		handlers.errored = cpp.Function.fromStaticFunction(onError);
		Discord.Initialize(clientID, cpp.RawPointer.addressOf(handlers), true, null);
        if (params != null) changePresence(params) else changePresence({});
        initialized = true;
    }
}
#end