var pressure:Float = 0.01;
var EggRoll:Int = 0;

var difficulties = ["easy", "normal", "hard", "hellsider"];
var difficultyPressures = [0.01, 0.02, 0.03, 0.04];
var missIncrements = [0.01, 0.01, 0.02, 0.04];

function getDifficultyIndex():Int {
    return difficulties.indexOf(PlayState.difficulty);
}

function onStartCountdown() {
   EggRoll = FlxG.random.int(0, 100);
    var i = getDifficultyIndex();
    pressure = difficultyPressures[i];
   if (i == 3 && EggRoll == 69) pressure += 0.65;
}

function onPlayerMiss() {
    if (pressure >= 0.01) {
        var i = getDifficultyIndex();
// yaaawn, its easy mode.
        if (i == 0 && pressure < 0.1)
            pressure += missIncrements[i];
        else if (i == 0 && pressure > 0.1) {
            pressure = 0.1;
            trace("Pressure cap hit for this difficulty, ignoring miss...");
        }
// Nice, simple Normal Mode. :)
        if (i == 1 && pressure < 0.2)
            pressure += missIncrements[i];
        else if (i == 1 && pressure > 0.2) {
            pressure = 0.2;
            trace("Pressure cap hit for this difficulty, ignoring miss...");
        }
// This is gonna get rough for you on hard.
        if (i == 2 && pressure < 0.35)
            pressure += missIncrements[i];
        else if (i == 2 && pressure > 0.35) {
            pressure = 0.35;
            trace("Pressure cap hit for this difficulty, ignoring miss...");
        }
// Oh, no. You poor bastard, you're on hellsider.
        if (i == 3 && pressure < 0.65)
            pressure += missIncrements[i];
        else if (i == 3 && pressure > 0.65) {
            pressure = 0.65;
            trace("Pressure cap hit for this difficulty, ignoring miss...");
        }

    }
}

function onDadHit() {
    if (health > 0.45) health -= pressure * 0.45;
}