var pressure:Float = 0.01;

var difficulties = ["blazinghot"];
var difficultyPressures = [0.38];
var missIncrements = [0.21];

function getDifficultyIndex():Int {
    return difficulties.indexOf(PlayState.difficulty);

}

 function onStartCountdown() {
  var i = getDifficultyIndex();
  pressure = difficultyPressures[i];    
}
    trace("Difficulty: " + PlayState.difficulty);
    trace("starting pressure: " + pressure);
    trace("Miss Increnmeat: " + missIncrements[getDifficultyIndex()]);
    trace("This should fucking work?");
function onPlayerMiss() {
    if (pressure >= 0.01) {
        var i = getDifficultyIndex();
//So, this works.
        if (i == 1 && pressure < 0.99)
            pressure += missIncrements[i];
        // this is stupid. this is so fucking aids
        else if (i == 1 && pressure > 0.99) {
            pressure = 0.99;
            trace("Pressure cap hit for this difficulty, ignoring miss...");
        }
    }
}

function onDadHit() {
    // This is a hard song; the pressure damage is good.
    if (health > 0.45) health -= pressure * 0.55;
}

