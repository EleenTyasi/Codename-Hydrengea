
var hitNoteDrainPenalty:Float = 0.011;
var missNoteDrainPenalty:Float = 0.22;


  function onNoteCreation(e)
{
    // if da note type is da crystal type den...

    if(e.noteType == "crystalNote")
    {
         // I'm going to send ya to da scrapheap, ya git.
        // set it as da propah note, ya git
        e.noteSprite = "game/notes/types/crystalNote";
        e.note.frameOffset.set(61,5); // this da perfect offset for da conversion of da krumpin' notes
    }
}

// when da playah hit da crystal
function onPlayerHit(e)
{
    //MAKE SURE ITS THA CRYSTAL NOTE YA GIT!
    if(e.noteType == "crystalNote")
    {
        // Make sure da git can pay da tax.
        if (health >= 0.5) {
            health -= hitNoteDrainPenalty;
            trace("Crystal Note Hit Penalty Success");
        }
        // OI! Don't kill da git if he can't! He hit the note, ya git!
        else
            trace("Safeguarded against Lethal Damage!");
    }
}

// playah missed da shiny! FUCK HIS DAY UP, YA GIT!
function onPlayerMiss(e)
{
    //AGAIN! MAKE SURE DA NOTE IS CRYSTAL, YA GIT!
    if(e.noteType == "crystalNote")
    {
        //krump tha midget! hit him as hard as ye can!
        health -= missNoteDrainPenalty;
        trace("Crystal Note Miss Penalty Success");
    }
}

trace("ALL GOOD! Crystal Notes Loaded! :D")