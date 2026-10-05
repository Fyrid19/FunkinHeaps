package funkin.test;

import engine.game.state.HeapsStateManager;
import engine.game.state.HeapsState;
import engine.backend.Signal;

class ConductorTestState extends HeapsState
{    
    var time : Float = 0.;

    var song:hxd.snd.Channel;
    var metronome:hxd.res.Sound;
    var songTime:Text;
    var conductorData:Text;

    var beatSquare:h2d.Bitmap;

    var beatsHit:Int = 0;

    public var conductor:funkin.backend.music.Conductor;

    public var preUpdateSignal:Signal = new Signal();
    public var postUpdateSignal:Signal = new Signal();

    override public function new():Void
    {        
        super();
    }
    
    
    override public function create():Void
    {        
        conductorData = new Text(hxd.res.DefaultFont.get(), this);
        conductorData.text = "s";
        conductorData.x = 20;
        conductorData.y = this.height - conductorData.textHeight - 10;

        song = Paths.inst("Fresh");
        metronome = Paths.sound("metronome");

        var playButton = new h2d.Interactive(300, 100, this);
        playButton.backgroundColor = 0xFF414141;
        playButton.onClick = (e) -> {
            song.pause = !song.pause;
        };

        var playButtonText = new Text(hxd.res.DefaultFont.get(), playButton);
        playButtonText.text = "Play / Pause";
        playButtonText.x = playButton.width / 2 - playButtonText.textWidth / 2;
        playButtonText.y = playButton.height / 2 - playButtonText.textHeight / 2;

        playButton.x = this.width / 2 - playButton.width / 2;
        playButton.y = this.height / 2 - playButton.height / 2;

        songTime = new Text(hxd.res.DefaultFont.get(), this);

        // initialize conductor
        var songMeta = Paths.json("songs/Fresh/meta");
        conductor = new funkin.backend.music.Conductor(songMeta.bpm, song);
        conductor.songOffset = 0.005; // mess with this prolly, idk
        conductor.onBeatHit.add(() -> {
            // trace("beat hit");
            beatSquare.setScale(1.2);
            metronome.play();
            beatsHit++;
        });

        var tile = h2d.Tile.fromColor(0xFF0000, 100, 100);
        tile.dx = -50;
        tile.dy = -50;
        beatSquare = new h2d.Bitmap(tile, this);
        
        super.create();
    }
    
    override public function update(dt:Float) {
        super.update(dt);
        conductor.update(dt);
        
        var mult = Math.lerpTime(beatSquare.scaleX, 1, 0.2, dt);
        beatSquare.setScale(mult);
        beatSquare.rotation += 0.01;

        beatSquare.x = this.width / 2 - beatSquare.width / 2;
        beatSquare.y = this.height / 2 - beatSquare.height / 2 + 150;

        if (song != null) {
            songTime.text = "Song time: " + song.position + " / " + song.duration + " [paused: " + song.pause + "]" + " | Beats hit: " + beatsHit + " | Decstep: " + conductor.decStep;
            songTime.x = this.width / 2 - songTime.textWidth / 2;
            songTime.y = this.height - songTime.textHeight - 40;
        }

        if (conductor != null) {
            conductorData.text = 'Offset: ${conductor.songOffset}';
        }
    }
}