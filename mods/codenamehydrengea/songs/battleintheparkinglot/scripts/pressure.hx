var pressure:Float = 0.01;
var EggRoll:Int = 0;

var difficulties = ["hardcore"];
var difficultyPressures = [0.08];
var missIncrements = [0.02];

function getDifficultyIndex():Int {
    return difficulties.indexOf(PlayState.difficulty);
}

function onStartCountdown() {
   // EggRoll = FlxG.random.int(0, 100);
    var i = getDifficultyIndex();
    pressure = difficultyPressures[i];
   // if (i == 3 && EggRoll == 69) pressure += 0.65;
}

function onPlayerMiss() {
    if (pressure >= 0.01) {
        var i = getDifficultyIndex();
    //HARDCORE!  KRUMP ALL Y'ALL
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