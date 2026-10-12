package funkin.menus;

class MainMenuState extends HeapsState {
    var bg:Sprite;

    override function create() {
        if (Conductor.instance.targetSong == null)
            Conductor.instance.setSong(Paths.music('freakyMenu'), 120);

        bg = Sprite.fromImage(Paths.image('menus/menuBG'));
        add(bg);
    }
}