package engine.display.debug;

import hxd.Timer;
import hxd.Math;
import hxd.res.DefaultFont;
import h2d.RenderContext;
import h2d.Text;
import h2d.Object;

class RAMDisplay extends Object
{
    // for tha timer
    var syncTime:Float = 0.0;
    
    // program memory usage
    var taskMem:Float = 0;
    var taskMemFormatted:String = "0 MB";
    
    // garbage collector memory usage
    var gcMem:Float = 0;
    var gcMemFormatted:String = "0 MB";
    var gcPeakMem:Float = 0;
    var gcPeakMemFormatted:String = "0 MB";

    public var gcRamText:Text;
    
    public function new(x:Float = 0, y:Float = 0, parent:Object)
    {
        super(parent);
        this.setPosition(x, y);

        gcRamText = new Text(hxd.Res.fonts.vcr_fnt.toFont(), this);
        gcRamText.scale(0.6);
        gcRamText.text = "GC [0MB / 0MB]";
    }
    
	override function sync(ctx:RenderContext)
    {
        syncTime += Timer.elapsedTime;
        
        if (syncTime >= 0.25)
        {            
            final stats = hl.Gc.stats();
            
            if(stats.currentMemory > gcPeakMem) {
                gcPeakMem = stats.currentMemory;
            }
            
            gcMemFormatted = formatMemoryUse(stats.currentMemory);
            gcPeakMemFormatted = formatMemoryUse(gcPeakMem);

            // i wanna use • as the divider after i add the font lol
            // i have to do a thingy to get task manager memory and i dont wanna do that rn so we just have gc memory
            gcRamText.text = 'GC - [${gcMemFormatted} / ${gcPeakMemFormatted}]';
            
            syncTime = 0;
        }
        
        super.sync(ctx);
    }

    function formatMemoryUse(use:Float = 0):String
    {
        // usage in megabytes
        var memMB:Float = use / 1000 / 1000;
        
        var suffix:String = "MB";
        
        if (memMB >= 1000 * 1000) {  // WHAT THE FUCK ARE YOU DOING TO REACH THIS MUCH USAGE
            memMB /= 1000 * 1000;
            suffix = "TB";
        } else if (memMB >= 1000) {
            memMB /= 1000;
            suffix = "GB";
        }
        
        return '${Math.round(memMB)} ${suffix}';
    }
}