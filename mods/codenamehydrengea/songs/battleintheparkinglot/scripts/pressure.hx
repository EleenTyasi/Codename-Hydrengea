var pressure:Float = 0.01;
var EggRoll:Int = 0;

var difficulties = ["hardcore"];
var difficultyPressures = [0.08];
var missIncrements = [0.12];

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
    if (health > 0.65) health -= pressure * 0.55;
}