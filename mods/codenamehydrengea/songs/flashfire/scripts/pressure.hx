import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxColor;

var pressure:Float = 0.01;
var notesHitCount:Int = 0;
var mercyDecrement:Float = 0.01;

var difficulties = ["easy", "normal", "hard", "hellsider-f", "hellsider-e"];
var difficultyPressures = [0.01, 0.02, 0.03, 0.04, 0.04];
var missIncrements = [0.01, 0.01, 0.02, 0.04, 0.04];
var maxPressures:Array<Float> = [0.1, 0.2, 0.35, 0.69, 0.69];

var pressureText:FlxText;

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
	if (i == -1) return;
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

function postCreate() {
	var i = getDifficultyIndex();
	if (i != -1) pressure = difficultyPressures[i];
	createPressureHUD();
}

function onStartCountdown() {
	var i = getDifficultyIndex();
	if (i != -1) pressure = difficultyPressures[i];
	createPressureHUD();
}

function onPlayerHit(e) {
	if (e == null) return;
	if (e.noteType == "althurtNote" || e.noteType == "altcrystalNote") return;

	notesHitCount++;
	if (notesHitCount >= 40) {
		notesHitCount = 0;
		var i = getDifficultyIndex();
		if (i != -1) {
			var minPressure = difficultyPressures[i];
			if (pressure > minPressure) {
				pressure -= mercyDecrement;
				if (pressure < minPressure) pressure = minPressure;
				updatePressureText();
				trace("Mercy applied! Pressure reduced.");
			}
		}
	}
}

function onPlayerMiss(e) {
	if (e == null) return;
	notesHitCount = 0;

	var i = getDifficultyIndex();
	if (i == -1) return;

	if (pressure >= 0.01) {
		var max = maxPressures[i];
		if (pressure < max) {
			pressure += missIncrements[i];
			if (pressure > max) pressure = max;
		} else {
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
	if (health > 0.45)
		health -= pressure * 0.45;
}
