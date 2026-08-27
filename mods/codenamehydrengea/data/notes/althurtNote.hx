import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.text.FlxTextBorderStyle;

var strikesText:FlxText;
var strikes:Int = 0;
var nonHurtHits:Int = 0;

function postCreate() {
	createStrikesHUD();
}

function onCountdown() {
	createStrikesHUD();

	var text = new FlxText();
	text.text = "These hurt notes act like strikes... Hitting 3 will kill you.\nEvery 30 normal hits removes 1 strike.";
	text.color = FlxColor.WHITE;
	text.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
	text.size = 16;
	text.screenCenter();
	text.y += 50;
	text.cameras = [camHUD];
	add(text);

	new FlxTimer().start(3, function(tmr) {
		if (text != null) {
			remove(text);
			text.destroy();
		}
	});
}

function createStrikesHUD() {
	if (strikesText != null)
		return;

	strikesText = new FlxText(0, 0, 200, "");
	strikesText.setFormat(null, 16, FlxColor.WHITE, "left");
	strikesText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 2);
	strikesText.scrollFactor.set(0, 0);
	strikesText.cameras = [camHUD];

	if (PlayState.instance != null && PlayState.instance.downscroll) {
		strikesText.y = 610;
	} else {
		strikesText.y = FlxG.height - 100;
	}
	strikesText.x = 90;

	add(strikesText);
	updateStrikesText();
}

function updateStrikesText() {
	if (strikesText == null)
		return;
	strikesText.text = "Strikes: " + strikes + "/3";

	if (strikes == 0) {
		strikesText.color = FlxColor.WHITE;
	} else if (strikes == 1) {
		strikesText.color = FlxColor.YELLOW;
	} else if (strikes == 2) {
		strikesText.color = 0xFFFF8800; // Orange
	} else {
		strikesText.color = FlxColor.RED;
	}
}

function onNoteCreation(e) {
	if (e.noteType == "althurtNote") {
		e.noteSprite = "game/notes/types/hurtNote";
		e.note.frameOffset.set(50, 3);
		e.sustain.frameOffset.set(1, 5);
	}
}

function onPlayerHit(e) {
	if (e == null)
		return;

	if (e.noteType == "althurtNote") {
		trace("Uh oh, someone hit it.");
		e.preventAnim();

		strikes++;
		updateStrikesText();

		if (strikes == 1) {
			// Deal as much damage as a normal hurt note: 0.22
			health = health - 0.22;
			trace("1st Strike: normal hurt note damage applied.");
		} else if (strikes == 2) {
			// Deal 50% of player's current health in damage (halves current health)
			health = health * 0.5;
			trace("2nd Strike: HP halved.");
		} else if (strikes >= 3) {
			gameOver();
			trace("3rd Strike: You're out, fucknugget!");
		}

		boyfriend.playAnim("miss");

		if (PlayState.instance != null) {
			PlayState.instance.combo = 0;
			PlayState.instance.songScore = Math.max(0, PlayState.instance.songScore - 100);
		}
	} else if (e.noteType != "hurtNote") {
		if (strikes > 0) {
			nonHurtHits++;
			if (nonHurtHits >= 30) {
				nonHurtHits = 0;
				strikes--;
				updateStrikesText();
				trace("Strike removed due to 30 non-hurt notes hit!");
			}
		} else {
			nonHurtHits = 0;
		}
	}
}

function onPlayerMiss(e) {
	if (e.noteType == "althurtNote") {
		// Skip health loss and combo break because skipping these is the goal
		e.cancel(true);
		if (e.note != null && e.note.strumLine != null) {
			e.note.strumLine.deleteNote(e.note);
		}
	}
}
trace("Strike-based altHurtNote script loaded; if you see this, it's working.");
