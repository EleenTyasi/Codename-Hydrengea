// Dedicated High-Pain Crystal Note for Ring Out
var hitNoteDrainPenalty:Float = 0.012; // Gentle chip on hit (~1.2% HP)
var missNoteDrainPenalty:Float = 0.28; // Moderate miss penalty (~28% HP)

function onNoteCreation(e)
{
    if (e.noteType == "painCrystalNote")
    {
        e.noteSprite = "game/notes/types/crystalNote";
        e.note.frameOffset.set(50, 3);
        e.sustain.frameOffset.set(1, 5);
    }
}

function onPlayerHit(e)
{
    if (e.noteType == "painCrystalNote")
    {
        if (health > 0.15) {
            health -= hitNoteDrainPenalty;
            if (health < 0.10) health = 0.10;
        }
    }
}

function onPlayerMiss(e)
{
    if (e.noteType == "painCrystalNote")
    {
        health -= missNoteDrainPenalty;
    }
}

trace("Pain Crystal Notes (Rebalanced) Loaded! :D");
