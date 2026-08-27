import flixel.addons.effects.FlxTrail;
import flixel.group.FlxTypedGroup;
import flixel.util.FlxColor;

// Toggle Ghost Trail Event (Codename Engine - Powered by native FlxTrail)
// Param 0: Target Strumline (0 = Dad, 1 = BF, 2 = GF, or StrumLine index/object)
// Param 1: Enable Trail (True / False)

var trails:Array<FlxTrail> = [];

function getOrCreateTrail(strumLineID:Int):FlxTrail {
	if (trails[strumLineID] != null) return trails[strumLineID];
	if (PlayState.instance == null || PlayState.instance.strumLines == null) return null;
	if (strumLineID < 0 || strumLineID >= PlayState.instance.strumLines.members.length) return null;

	var strumLine = PlayState.instance.strumLines.members[strumLineID];
	if (strumLine == null || strumLine.characters == null || strumLine.characters.length == 0) return null;

	var char:Character = strumLine.characters[0];
	if (char == null) return null;

	// FlxTrail(Target, Image, Length, Delay, Alpha, Diff)
	// 5 trail steps, 2 frame delay, 0.6 starting alpha, 0.05 step alpha reduction
	var trail:FlxTrail = new FlxTrail(char, null, 5, 2, 0.6, 0.05);
	if (char.iconColor != null) {
		trail.color = char.iconColor;
	}
	trail.visible = false;
	trail.active = false;

	var group = FlxTypedGroup.resolveGroup(char);
	if (group == null) group = PlayState.instance;

	var charIndex:Int = group.members.indexOf(char);
	if (charIndex >= 0) {
		group.insert(charIndex, trail);
	} else {
		PlayState.instance.add(trail);
	}

	while (trails.length <= strumLineID) {
		trails.push(null);
	}
	trails[strumLineID] = trail;
	return trail;
}

function parseBoolParam(val:Dynamic):Bool {
	if (val == null) return false;
	if (val == true) return true;
	if (val == false) return false;
	var str:String = StringTools.trim(Std.string(val).toLowerCase());
	return (str == "1" || str == "true" || str == "on" || str == "yes");
}

function parseStrumlineID(val:Dynamic):Int {
	if (val == null) return 0;
	var str:String = StringTools.trim(Std.string(val).toLowerCase());
	if (str == "dad" || str == "opponent") return 0;
	if (str == "bf" || str == "boyfriend" || str == "player") return 1;
	if (str == "gf" || str == "girlfriend") return 2;

	var p = Std.parseInt(str);
	return p == null ? 0 : p;
}

function onEvent(event) {
	if (event.event.name == "Toggle Ghost Trail") {
		var params = event.event.params;
		if (params == null || params.length == 0) return;

		var strumLineID:Int = parseStrumlineID(params[0]);
		var enabled:Bool = true;
		if (params.length > 1) {
			enabled = parseBoolParam(params[1]);
		}

		var trail:FlxTrail = getOrCreateTrail(strumLineID);
		if (trail != null) {
			trail.visible = enabled;
			trail.active = enabled;
			if (!enabled) {
				trail.resetTrail();
			}
		}

		trace("=== TOGGLE GHOST TRAIL (FlxTrail) | Strumline: " + strumLineID + " | Enabled: " + enabled + " ===");
	}
}
