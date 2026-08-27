import flixel.FlxG;
import flixel.math.FlxMath;

// Flurry Rush Dynamic Camera Zoom for Ring Out (Matt vs Ricky)
var baseZoom:Float = 0.85;
var flurryZoomAdd:Float = 0.0;
var targetFlurryZoom:Float = 0.0;
var lastDadHit:Float = 0.0;
var lastBfHit:Float = 0.0;
var dadStreak:Int = 0;
var bfStreak:Int = 0;
var flurryTimer:Float = 0.0;

function postCreate() {
	if (defaultCamZoom > 0) baseZoom = defaultCamZoom;
	else baseZoom = 0.85;
}

// Check if current timestamp is in one of the 4 major high-intensity sections
function isHighIntensitySection():Bool {
	var pos = Conductor.songPosition;
	// 1: 32s-40s | 2: 74.6s-90s (Drop) | 3: 96s-107s (Rage) | 4: 118s-138s (Climax)
	return (pos >= 32000 && pos <= 40000) ||
	       (pos >= 74660 && pos <= 90000) ||
	       (pos >= 96000 && pos <= 107000) ||
	       (pos >= 118000 && pos <= 138500);
}

function onDadHit(e) {
	var cur = Conductor.songPosition;
	var delta = cur - lastDadHit;
	lastDadHit = cur;

	// In 180 BPM, 8th notes are 166ms, 16th notes are 83ms
	if (delta > 0 && delta <= 175) {
		dadStreak++;
		if (dadStreak >= 4 || (isHighIntensitySection() && dadStreak >= 2)) {
			triggerRushZoom(0.12);
		}
	} else {
		dadStreak = 1;
	}
}

function onPlayerHit(e) {
	var cur = Conductor.songPosition;
	var delta = cur - lastBfHit;
	lastBfHit = cur;

	if (delta > 0 && delta <= 175) {
		bfStreak++;
		if (bfStreak >= 4 || (isHighIntensitySection() && bfStreak >= 2)) {
			triggerRushZoom(0.12);
		}
	} else {
		bfStreak = 1;
	}
}

function triggerRushZoom(amount:Float) {
	targetFlurryZoom = amount;
	flurryTimer = 0.65; // Keep zoom active through the flurry phrase
	FlxG.camera.shake(0.002, 0.05); // Soft punch rumble
}

function update(elapsed:Float) {
	if (flurryTimer > 0) {
		flurryTimer -= elapsed;
		if (flurryTimer <= 0) {
			targetFlurryZoom = 0.0;
		}
	}

	// Smoothly interpolate flurry zoom add
	flurryZoomAdd = FlxMath.lerp(flurryZoomAdd, targetFlurryZoom, FlxMath.bound(elapsed * 8.0, 0, 1));
	
	// Apply directly to defaultCamZoom so engine lerp works WITH the flurry zoom
	defaultCamZoom = baseZoom + flurryZoomAdd;
}
