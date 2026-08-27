// Dodge Warning Event – Beat‑synchronized dodge mechanic
import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;

// ------------------------------------------------------------
// Configuration defaults (overridable via event params)
// ------------------------------------------------------------
var defaultGraceFraction:Float = 0.4;      // extra time after final beat before auto‑fail
var defaultBeatCount:Int = 3;              // number of beats (ONE, TWO, DODGE)
var defaultFontSize:Int = 44;
var defaultColors:Array<FlxColor> = [FlxColor.YELLOW, 0xFFFF8800, FlxColor.RED];

// ------------------------------------------------------------
// State variables
// ------------------------------------------------------------
var dodgeActive:Bool = false;
var dodgeResolving:Bool = false;
var dodgeElapsed:Float = 0.0;
var dodgeBeatLen:Float = 0.353;   // will be computed from Conductor
var dodgeTotalDuration:Float = 1.059; // beatCount * beatLen + grace (computed later)
var dodgeInputDone:Bool = false;
var frameTolerance:Float = 5.0 / 60.0; // ±5 frames at 60 FPS

// Parameters (filled on event start)
var dodgePressurePenalty:Float = 0.12;
var dodgeShakeOnFail:Bool = true;
var dodgeShakeMag:Float = 0.05;


var dodgeText:FlxText;

var difficulties = ["easy", "normal", "hard", "hellsider-f", "hellsider-e"];
var maxPressures:Array<Float> = [0.1, 0.2, 0.35, 0.69, 0.69];

function getDifficultyIndex():Int {
	return difficulties.indexOf(PlayState.difficulty);
}

function centerDodgeText() {
	if (dodgeText == null) return;
	dodgeText.x = (FlxG.width - dodgeText.width) / 2;
	dodgeText.y = (FlxG.height - dodgeText.height) / 2;
}

function createDodgeHUD() {
	if (dodgeText != null) return;

	dodgeText = new FlxText(0, 0, 500, "");
	dodgeText.setFormat(null, 44, FlxColor.YELLOW, "center");
	dodgeText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
	dodgeText.scrollFactor.set(0, 0);
	dodgeText.cameras = [camHUD];
	dodgeText.visible = false;
	centerDodgeText();
	add(dodgeText);
}

function postCreate() {
	createDodgeHUD();
}

function onEvent(event) {
	if (event.event.name == "Dodge Warning" || event.event.name == "Pressure DodgeEvent") {
		if (dodgeActive || dodgeResolving) return;

		var params = event.event.params;
		dodgePressurePenalty = (params != null && params.length > 1 && params[1] != null) ? params[1] : 0.12;
		dodgeShakeOnFail     = (params != null && params.length > 2 && params[2] != null) ? params[2] : true;
		dodgeShakeMag        = (params != null && params.length > 3 && params[3] != null) ? params[3] : 0.05;

		// Calculate 1 beat length from Conductor
		if (Conductor != null && Conductor.crochet > 0) {
			dodgeBeatLen = Conductor.crochet / 1000.0;
		} else {
			dodgeBeatLen = 60.0 / 170.0; // Fallback for 170 BPM
		}

		// Exactly 3 beats for the full sequence:
		// Beat 1: DODGE! 3
		// Beat 2: DODGE! 2
		// Beat 3: NOW! (+ grace window to react)
		dodgeTotalDuration = (dodgeBeatLen * 3.0) + (dodgeBeatLen * 0.4);

		dodgeActive    = true;
		dodgeResolving = false;
		dodgeElapsed   = 0.0;
		dodgeInputDone = false;

		createDodgeHUD();
        // Show first beat label (ONE)
        dodgeText.text = "ONE";
        dodgeText.color = defaultColors[0];
        dodgeText.visible = true;
        centerDodgeText();
        // Play optional tick sound
        playOptionalSound(soundTick);
        trace("=== DODGE EVENT STARTED – beatLen=" + dodgeBeatLen + "s ===");
	}
}

function resolveDodgeSuccess() {
	if (dodgeResolving) return;
	dodgeResolving = true;
	dodgeInputDone = true;

	if (dodgeText != null) {
		dodgeText.text  = "NICE!";
		dodgeText.color = FlxColor.GREEN;
		centerDodgeText();
	}

	new FlxTimer().start(0.35, function(tmr:FlxTimer) {
		if (dodgeText != null) {
			dodgeText.text    = "";
			dodgeText.visible = false;
		}
		dodgeActive    = false;
		dodgeResolving = false;
	});

	trace("=== DODGE SUCCESS ===");
}

function resolveDodgeFail() {
	if (dodgeResolving) return;
	dodgeResolving = true;

	// Apply pressure penalty via shared scope or PlayState
	var i = getDifficultyIndex();
	try {
		pressure += dodgePressurePenalty;
		if (i != -1 && pressure > maxPressures[i]) pressure = maxPressures[i];
	} catch(e:Dynamic) {}

	if (dodgeShakeOnFail) {
		FlxG.cameras.shake(dodgeShakeMag, 0.35);
	}

	if (dodgeText != null) {
		dodgeText.text  = "MISSED!";
		dodgeText.color = FlxColor.RED;
		centerDodgeText();
	}

	new FlxTimer().start(0.35, function(tmr:FlxTimer) {
		if (dodgeText != null) {
			dodgeText.text    = "";
			dodgeText.visible = false;
		}
		dodgeActive    = false;
		dodgeResolving = false;
	});

	trace("=== DODGE FAILED | Added: " + dodgePressurePenalty + " ===");
}

function onPlayerHit(e) {
	// Arrow inputs are ignored; dodge only works via SPACE bar.
	return;
}

function update(elapsed:Float) {
	if (!dodgeActive || dodgeResolving) return;

	dodgeElapsed += elapsed;

	// Beat 1: [0.0 -> 1 beat) -> "DODGE! 3"
	// Beat 2: [1 beat -> 2 beats) -> "DODGE! 2"
	// Beat 3: [2 beats -> 3 beats+) -> "NOW!"
	if (dodgeText != null && dodgeText.visible) {
		if (dodgeElapsed < dodgeBeatLen) {
			dodgeText.text  = "3";
			dodgeText.color = FlxColor.YELLOW;
		} else if (dodgeElapsed < dodgeBeatLen * 2.0) {
			dodgeText.text  = "2";
			dodgeText.color = 0xFFFF8800;
		} else {
			dodgeText.text  = "NOW!";
			dodgeText.color = FlxColor.RED;
		}
		centerDodgeText();
	}

	// SPACE key input check
	if (!dodgeInputDone && (FlxG.keys.justPressed.SPACE || FlxG.keys.anyJustPressed(["SPACE"]))) {
		// Allow input only during NOW! window ±5 frames
		if (dodgeElapsed >= (dodgeBeatLen * 2.0 - frameTolerance) && dodgeElapsed <= (dodgeBeatLen * 3.0 + frameTolerance)) {
			resolveDodgeSuccess();
			return;
		}
	}

	// Window expired without input -> Fail on 3rd beat
	if (dodgeElapsed >= dodgeTotalDuration) {
		if (!dodgeInputDone) {
			resolveDodgeFail();
		}
	}
}
