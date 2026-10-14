package funkin.menus;

class MainMenuState extends HeapsState {
    var bg:Sprite;

    override function create() {
        Conductor.instance.setSong(Paths.music('freakyMenu'), 100);

        bg = Sprite.fromImage(Paths.image('menus/menuBG'));
        add(bg);
    }
}