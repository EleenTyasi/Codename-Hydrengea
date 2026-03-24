
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxColor;

var pressure:Float = 0.01;
var pressureCount:Float = (pressure * 10000);
var EggRoll:Int = 0;
var bar:FlxBar;
var difficulties = ["hardcore"];
var difficultyPressures = [0.08];
var missIncrements = [0.02];

var maxPressures:Array<Float> = [0.65];
var pressureText:FlxText;

function fmt(v:Float):String {
    return Std.string(Math.round(v * 100) / 100);
}


function getDifficultyIndex():Int {
    return difficulties.indexOf(PlayState.difficulty);
}

function createPressureHUD() {
    if (pressureText != null) return;

    pressureText = new FlxText(0, 0, 200, "");
    pressureText.setFormat(null, 16, FlxColor.WHITE, "left");
    pressureText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    pressureText.scrollFactor.set(0, 0);
    pressureText.cameras = [camHUD];
    
    if (PlayState.instance.downscroll) {
        pressureText.y = 10;
    } else {
        pressureText.y = FlxG.height - 40;
    }
    pressureText.x = 10;
    
    add(pressureText);
    updatePressureText();
}

function updatePressureText() {
    if (pressureText == null) return;
    var i = getDifficultyIndex();
    var max = maxPressures[i];
    var percent = Math.floor((pressure / max) * 100);
    pressureText.text = "Pressure: " + percent + "/100";
    
    if (percent >= 100) {
        pressureText.color = FlxColor.RED;
    } else if (percent >= 67) {
        pressureText.color = 0xFFFF8800;
    } else if (percent >= 34) {
        pressureText.color = FlxColor.YELLOW;
    } else {
        pressureText.color = FlxColor.WHITE;
    }
}

function onStartCountdown() {
   // EggRoll = FlxG.random.int(0, 100);
    var i = getDifficultyIndex();
    pressure = difficultyPressures[i];
   // if (i == 3 && EggRoll == 69) pressure += 0.65;
   
    createPressureHUD();
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

        updatePressureText();
    }
}

function onDadHit() {
    if (health > 0.45) health -= pressure * 0.45;
}