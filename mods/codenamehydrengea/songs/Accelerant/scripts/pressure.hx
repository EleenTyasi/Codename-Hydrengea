import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxColor;

var pressure:Float = 0.01;
var EggRoll:Int = 0;
var notesHitCount:Int = 0; // Tracks hits for mercy mechanic

// Shifted to lowercase to match engine standards
var difficulties = ["ultrafucked"];
var difficultyPressures = [0.09]; // This is our "minimum" pressure
var missIncrements = [0.11];
var maxPressures:Array<Float> = [0.80];
var mercyDecrement:Float = 0.02; // How much to reduce pressure every 10 hits

var pressureText:FlxText;

function fmt(v:Float):String {
    return Std.string(Math.round(v * 100) / 100);
}

function getDifficultyIndex():Int {
    return difficulties.indexOf(PlayState.difficulty.toLowerCase());
}

function createPressureHUD() {
    if (pressureText != null) return;

    pressureText = new FlxText(0, 0, 200, "");
    pressureText.setFormat(null, 16, FlxColor.WHITE, "left");
    pressureText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
    pressureText.scrollFactor.set(0, 0);
    pressureText.cameras = [camHUD];

    if (PlayState.instance.downscroll) {
        pressureText.y = 640;
    } else {
        pressureText.y = FlxG.height - 70;
    }
    pressureText.x = 90;

    add(pressureText);
    updatePressureText();
}

function updatePressureText() {
    if (pressureText == null) return;

    var i = getDifficultyIndex();
    var max = (i != -1) ? maxPressures[i] : 0.80;

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
    var i = getDifficultyIndex();
    if (i != -1) pressure = difficultyPressures[i];

    createPressureHUD();
}

function onPlayerHit(e) {
    // We don't want "Bad Notes" (Hurt/Crystal) to count toward mercy
    // Assuming your bad notes have a specific type or you handle them elsewhere
    if (e.noteType == "althurtNote" || e.noteType == "altcrystalNote") return;

    notesHitCount++;

    if (notesHitCount >= 10) {
        notesHitCount = 0; // Reset counter
        var i = getDifficultyIndex();

        if (i != -1) {
            var minPressure = difficultyPressures[i];

            // Only reduce if we are above the minimum for this difficulty
            if (pressure > minPressure) {
                pressure -= mercyDecrement;

                // Clamp to the minimum so it doesn't go below
                if (pressure < minPressure) pressure = minPressure;

                updatePressureText();
                trace("Mercy applied! Pressure reduced.");
            }
        }
    }
}

function onPlayerMiss(e) {
    if (e != null && e.noteType == "althurtNote") return;

    var i = getDifficultyIndex();

    if (pressure >= 0.001 && i != -1) {
        var max = maxPressures[i];

        if (pressure < max) {
            pressure += missIncrements[i];
            if (pressure > max) pressure = max;
        } else {
            trace("Pressure cap hit: " + difficulties[i]);
        }

        // You miss? Fuck yo' mercy. You lose progress on it.
         notesHitCount = 0;

        updatePressureText();
    }
}

function onEvent(event) {
	if (event.event.name == "Pressure Spike") {
		var params = event.event.params;
		var amount:Float = 0.08;
		if (params != null && params.length > 0 && params[0] != null) {
			amount = Std.parseFloat(Std.string(params[0]));
			if (Math.isNaN(amount)) amount = 0.08;
		}
		pressure += amount;
		var i = getDifficultyIndex();
		if (i != -1 && pressure > maxPressures[i]) pressure = maxPressures[i];
		updatePressureText();
		trace("=== PRESSURE SPIKE | +" + amount + " | Now: " + pressure + " ===");
	}
}

function onDadHit() {
    if (health > 0.45) health -= pressure * 0.45;
}