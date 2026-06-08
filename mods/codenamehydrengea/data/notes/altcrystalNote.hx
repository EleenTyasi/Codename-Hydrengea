
var hitNoteDrainPenalty:Float = 0.11;

import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxTextBorderStyle;

  function onCountdown()
  {
    var text = new FlxText();
    text.text = "These crystal notes are different; missing them WILL kill you.";
    text.color = FlxColor.ORANGE;
    text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    text.size = 24;
    text.screenCenter();
    text.cameras = [camHUD];
    add(text);
    new FlxTimer().start(3, function(tmr)
        {remove(text);
        text.destroy();});
  }
  function onNoteCreation(e)
{
    // if da note type is da crystal type den...

    if(e.noteType == "altcrystalNote")
    {
         // I'm going to send ya to da scrapheap, ya git.
        // set it as da propah note, ya git
        e.noteSprite = "game/notes/types/crystalNote";
        e.note.frameOffset.set(50,3); // this da perfect offset for da conversion of da krumpin' notes
        e.sustain.frameOffset.set(1,5); // am i smoking crack?
    }
}

// when da playah hit da crystal
function onPlayerHit(e)
{
    //MAKE SURE ITS THA CRYSTAL NOTE YA GIT!
    if(e.noteType == "altcrystalNote")
    {
        // Make sure da git can pay da tax.
        if (health >= 0.11) {
            health = health - hitNoteDrainPenalty;
            trace("Got hurt; Crystal tax taken.");
        }
        // OI! Don't kill da git if he can't! He hit the note, ya git!
        else
            trace("You're not dead yet.");
    }
}

// playah missed da shiny! FUCK HIS DAY UP, YA GIT!
function onPlayerMiss(e)
{
    //AGAIN! MAKE SURE DA NOTE IS CRYSTAL, YA GIT!
    if(e.noteType == "altcrystalNote")
    {
        //this crystal note...
        // it's not like the one in story/bonnie's normal songs
        // You die if you miss these. Straight up.
        gameOver();
        trace("Your punishment, is death.");
    }
}

trace("ALL GOOD! Crystal Notes Loaded! :D")