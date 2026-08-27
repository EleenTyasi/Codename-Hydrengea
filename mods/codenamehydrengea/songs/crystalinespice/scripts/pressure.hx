import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxColor;

var pressure:Float = 0.01;
var notesHitCount:Int = 0; // Tracks hits for mercy mechanic
var mercyDecrement:Float = 0.05; // How much to reduce pressure every 10 hits
var difficulties = ["blazinghot"];
var difficultyPressures = [0.38];
var missIncrements = [0.21];
var maxPressures:Array<Float> = [0.99];
var pressureText:FlxText;

function fmt(v:Float):String {
	return Std.string(Math.round(v * 100) / 100);
}

function getDifficultyIndex():Int {
	return difficulties.indexOf(PlayState.difficulty);
}

function createPressureHUD() {
	if (pressureText != null)
		return;

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
	if (pressureText == null)
		return;
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
	var i = getDifficultyIndex();
	pressure = difficultyPressures[i];
}

trace("Difficulty: " + PlayState.difficulty);
trace("starting pressure: " + pressure);
trace("Miss Increnmeat: " + missIncrements[getDifficultyIndex()]);
trace("This should fucking work?");
function onPlayerHit(e) {
	if (e.noteType == "althurtNote" || e.noteType == "altcrystalNote")
		return;

	notesHitCount++;

	if (notesHitCount >= 20) {
		notesHitCount = 0;
		var i = getDifficultyIndex();

		if (i != -1) {
			var minPressure = difficultyPressures[i];

			if (pressure > minPressure) {
				pressure -= mercyDecrement;
				if (pressure < minPressure)
					pressure = minPressure;

				updatePressureText();
				trace("Mercy applied! Pressure reduced.");
			}
		}
	}
}

function onPlayerMiss(e) {
	// You miss? Fuck yo' mercy. You lose progress on it.
	notesHitCount = 0;

	if (pressure >= 0.01) {
		var i = getDifficultyIndex();
		// So, this works.
		if (i == 0 && pressure < 0.99)
			pressure += missIncrements[i];
		// this is stupid. this is so fucking aids
		else if (i == 0 && pressure > 0.99) {
			pressure = 0.99;
			trace("Pressure cap hit for this difficulty, ignoring miss...");
		}

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
	// This is a hard song; the pressure damage is good.
	if (health > 0.45)
		health -= pressure * 0.55;
}
