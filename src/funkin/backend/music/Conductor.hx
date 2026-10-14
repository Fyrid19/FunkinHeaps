package funkin.backend.music;

import engine.backend.Signal;
import hxd.snd.Channel;

class Conductor {
    // proper singleton design - ev
    public static final instance:Conductor = new Conductor();

    public var targetSong:Channel;

    public var bpm(default, set):Float;
    public function set_bpm(v:Float):Float {
        bpm = v;
        crochet = (60 / bpm);
        stepCrochet = crochet / stepsPerBeat;
        measureCrochet = crochet * beatsPerMeasure;

        onBpmChange.dispatch();

        return bpm;
    }

    public var songOffset:Float = 0; // in ms
    public var songPosition:Float = 0;
    public var songLength:Float = 0;

    public var crochet:Float;
    public var stepCrochet:Float;
    public var measureCrochet:Float;

    public var stepsPerBeat:Int = 4;
    public var beatsPerMeasure:Int = 4;

    public var curStep:Int;
    public var curBeat:Int;
    public var curMeasure:Int;

    public var stepFloat:Float;
    public var beatFloat:Float;
    public var measureFloat:Float;

    public var decStep:Float;
    public var decBeat:Float;
    public var decMeasure:Float;

    // Signals
    public var onStepHit:Signal = new Signal();
    public var onBeatHit:Signal = new Signal();
    public var onMeasureHit:Signal = new Signal();

    public var onBpmChange:Signal = new Signal();
    
    private function new() {}
    
    public function initConductor(?initialBpm:Float = 120, ?song:Channel) {
        this.bpm = initialBpm;
        this.targetSong = song;
        this.songPosition = 0;

        if (song != null) {
            this.songLength = song.duration;
        } else {
            this.songLength = 0;
            trace('No song was provided to the Conductor!', WARNING);
        }

        trace('Conductor initialized with BPM: ' + bpm);
    }
    
    public function update(dt:Float) {
        songPosition += songOffset / 1000;

        if (targetSong != null) {
            songPosition = Math.min(targetSong.position, targetSong.duration);
            songLength = targetSong.duration;
            songPosition = Math.clamp(songPosition, 0, songLength);
        }
        
        stepFloat = songPosition / stepCrochet;
        beatFloat = stepFloat / stepsPerBeat;
        measureFloat = beatFloat / beatsPerMeasure;

        if (curStep != Math.floor(stepFloat)) {
            curStep = Math.floor(stepFloat);
            onStepHit.dispatch();
        }
        if (curBeat != Math.floor(beatFloat)) {
            curBeat = Math.floor(beatFloat);
            onBeatHit.dispatch();
        }
        if (curMeasure != Math.floor(measureFloat)) {
            curMeasure = Math.floor(measureFloat);
            onMeasureHit.dispatch();
        }

        decStep = (songPosition % stepCrochet) / stepCrochet;
        decBeat = (songPosition % crochet) / crochet;
        decMeasure = (songPosition % measureCrochet) / measureCrochet;

        curStep = Math.floor(songPosition / stepCrochet);
        curBeat = Math.floor(songPosition / crochet);
        curMeasure = Math.floor(songPosition / measureCrochet);
    }

    public function setSong(song:Channel, bpm:Float, ?autoPlay:Bool = true) {
        if (targetSong != null) targetSong.stop();

        this.targetSong = song;
        this.bpm = bpm;
        this.targetSong.pause = !autoPlay;

        trace('Conductor song changed with BPM $bpm');
    }
}