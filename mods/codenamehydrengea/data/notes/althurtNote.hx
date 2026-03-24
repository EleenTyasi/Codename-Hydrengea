import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxTextBorderStyle;
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
    new FlxTimer().start(3, function(tmr)
        {remove(text);
        text.destroy();});
  }
  function onNoteCreation(e)
{
    // if da note type is da hurty type den...

    if(e.noteType == "althurtNote")
    {
        // set it as da propah note, ya git
        e.noteSprite = "game/notes/types/hurtNote";
        e.note.frameOffset.set(50,3); 
        e.sustain.frameOffset.set(1,5); // am i smoking crack? yes, deal with it fuckass
    }
}

// when da playah hit da hurty note
function onPlayerHit(e)
{
    //MAKE SURE ITS THA HURTY NOTE YA GIT!
    if(e.noteType == "althurtNote")
    {
        trace("Uh oh, someone hit it.");

        // BF hit it!
        // check health.
        if(health <= 0.5) { 
            trace("I'm the man that's gonna burn your house down with lemons.");
            gameOver(); // force game over
        } else {
            health = health * 0.5;
            trace("Om nom nom. Tasty health.");
        }


        boyfriend.playAnim("miss");
        noteMiss(e.note);
    }
}

// Playah ain't dum! dey skipped da hurty note!
function onPlayerMiss(e)
{
    //AGAIN! MAKE SURE DA NOTE IS HURTY, YA GIT!
    if(e.noteType == "althurtNote")
    {
        //krump da note, it ain't supposed ta do nuffin' on da miss.
        e.cancel(true); // KILL IT!
        e.note.strumLine.deleteNote(e.note); //KRUMP DA SPRITE TOO!
    }
}
    trace("Halving Note script loaded; if you see this; it's working.");