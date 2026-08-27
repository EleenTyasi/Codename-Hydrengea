// Pressure Spike Event – Instantly adds pressure to the player.
// Only works on charts that have the pressure mechanic loaded (pressure.hx).

function onEvent(event) {
	if (event.event.name != "Pressure Spike") return;

	var params = event.event.params;
	var amount:Float = 0.08;
	if (params != null && params.length > 0 && params[0] != null) {
		amount = Std.parseFloat(Std.string(params[0]));
		if (Math.isNaN(amount)) amount = 0.08;
	}

	// Only apply if the song script has a pressure variable in scope
	try {
		pressure += amount;
		updatePressureText();
		trace("=== PRESSURE SPIKE | +" + amount + " | Now: " + pressure + " ===");
	} catch (e:Dynamic) {
		trace("Pressure Spike fired but no pressure mechanic found – ignoring.");
	}
}

