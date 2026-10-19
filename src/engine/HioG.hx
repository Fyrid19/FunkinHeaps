package engine;

// heaps equivalent of FlxG (kinda)
class HioG {
	public static var volume(get, never):hxd.snd.Manager;
	
	static function get_volume()
		return hxd.snd.Manager.get();
		
	public static var width(get, never):Int;
	
	static function get_width()
		return HeapsStateManager.game.width;
		
	public static var height(get, never):Int;
	
	static function get_height()
		return HeapsStateManager.game.height;
		
	public static var windowWidth(get, never):Int;
	
	static function get_windowWidth()
		return hxd.Window.getInstance().width;
		
	public static var windowHeight(get, never):Int;
	
	static function get_windowHeight()
		return hxd.Window.getInstance().height;
}
