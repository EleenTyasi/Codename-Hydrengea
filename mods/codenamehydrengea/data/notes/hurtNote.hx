var hitNoteDrainPenalty:Float = 0.22;

  function onNoteCreation(e)
{
    // if da note type is da hurty type den...

    if(e.noteType == "hurtNote")
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
    if(e.noteType == "hurtNote")
    {
        // punch da munta, send dat lad flyin' to da moon!
        health = health - hitNoteDrainPenalty;

        // haxe say bf no, don't sing. me, i say I KRUMP YOU IF SING!
        e.preventAnim();
        // is bad note! hit make boyfriend flinch!
        boyfriend.playAnim("miss");

        // break the combo by treating it as a miss
        noteMiss(e.note);

        // optionally take a little score hit (safety check to avoid null refs)
        if (PlayState.instance != null)
        {
            PlayState.instance.combo = 0;
            PlayState.instance.songScore = Math.max(0, PlayState.instance.songScore - 50);
        }

        trace("Hurt Note Hit Penalty applied");
    }
}

// Playah ain't dum! dey skipped da hurty note!
function onPlayerMiss(e)
{
    //AGAIN! MAKE SURE DA NOTE IS HURTY, YA GIT!
    if(e.noteType == "hurtNote")
    {
        //krump da note, it ain't supposed ta do nuffin' on da miss.
        e.cancel(true); // KILL IT!
        e.note.strumLine.deleteNote(e.note); //KRUMP DA SPRITE TOO!
    }
}
trace("Hurt Note script loaded; if you see this; it's working.");