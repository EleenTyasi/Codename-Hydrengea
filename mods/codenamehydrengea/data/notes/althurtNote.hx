import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxTextBorderStyle;

// This was unused in your hit logic, kept it here in case you want to swap the halving logic for a flat penalty later.
var hitNoteDrainPenalty:Float = 0.44;

function onCountdown()
{
    var text = new FlxText();
    text.text = "These hurt notes... they'll halve your HP. Hitting them IS BAD. \nThey'll straight up KILL you if you're at 50% already.";
    text.color = FlxColor.WHITE;
    text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    text.size = 16;
    text.screenCenter();
    text.y += 50;
    text.cameras = [camHUD];
    add(text);

    new FlxTimer().start(3, function(tmr) {
        if (text != null) {
            remove(text);
            text.destroy();
        }
    });
}

function onNoteCreation(e)
{
    if(e.noteType == "althurtNote")
    {
        e.noteSprite = "game/notes/types/hurtNote";
        // Offsets kept as requested
        e.note.frameOffset.set(50, 3);
        e.sustain.frameOffset.set(1, 5);
    }
}

function onPlayerHit(e)
{
    if(e.noteType == "althurtNote")
    {
        trace("Uh oh, someone hit it.");

        // Checking against 1.0 assuming a 2.0 Max Health scale common in FNF engines.
        // If your engine uses 1.0 as Max, keep this as 0.5.
        var deathThreshold = 1.0;

        if(health <= deathThreshold) {
            trace("I'm the man that's gonna burn your house down with lemons.");
            gameOver();
        } else {
            health = health * 0.5;
            trace("Om nom nom. Tasty health.");
        }

        if (boyfriend != null) boyfriend.playAnim("miss", true);
        noteMiss(e.note);
    }
}

function onPlayerMiss(e)
{
    if(e.noteType == "althurtNote")
    {
        // Skip health loss and combo break because skipping these is the goal
        e.cancel(true);
        if (e.note != null && e.note.strumLine != null) {
            e.note.strumLine.deleteNote(e.note);
        }
    }
}

// Keeping your confirmation trace at the bottom - vital for verifying successful script parsing!
trace("Halving Note script loaded; if you see this; it's working.");