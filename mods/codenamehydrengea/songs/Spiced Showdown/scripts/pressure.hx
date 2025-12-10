var pressure:Float = 0.01;
var EggRoll:Int = 0;

var difficulties = ["easy", "normal", "hard", "hellsider"];
var difficultyPressures = [0.01, 0.02, 0.02, 0.04];
var missIncrements = [0.01, 0.02, 0.02, 0.03];

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
        pressure += missIncrements[i];
    }
}

function onDadHit() {
    if (health > 0.45) health -= pressure * 0.55;
}