var hitNoteDrainPenalty:Float = 0.33;

  function onNoteCreation(e)
{
    // if da note type is da hurty type den...

    if(e.noteType == "hurtNote")
    {
        // set it as da propah note, ya git
        e.noteSprite = "game/notes/types/hurtNote";
        e.note.frameOffset.set(61,5);
    }
}

// when da playah hit da hurty note
function onPlayerHit(e)
{
    //MAKE SURE ITS THA HURTY NOTE YA GIT!
    if(e.noteType == "hurtNote")
    {
        // punch da munta, send dat lad flyin' to da moon!
        health -= hitNoteDrainPenalty;

        // haxe say bf no, don't sing. me, i say I KRUMP YOU IF SING!
        e.preventAnim();
        // is bad note! hit make boyfriend flinch!
        boyfriend.playAnim("singLEFTmiss");
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