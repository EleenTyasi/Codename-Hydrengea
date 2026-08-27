import flixel.text.FlxText;
import flixel.text.FlxTextBorderStyle;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxTimer;

function showRoundBanner(roundTextStr:String, subTextStr:String) {
	var bannerGroup:FlxSpriteGroup = new FlxSpriteGroup();
	bannerGroup.cameras = [camHUD];
	bannerGroup.scrollFactor.set(0, 0);

	var bannerColor:Int = 0xFFFFCC00; // Gold default
	if (roundTextStr.indexOf("2") != -1 || roundTextStr.indexOf("FINAL") != -1 || roundTextStr.indexOf("KNOCKOUT") != -1) {
		bannerColor = 0xFFFF3333; // Red for Round 2 / Final
	}

	// Main Round Text
	var mainText = new FlxText(0, (FlxG.height * 0.38), FlxG.width, roundTextStr);
	mainText.setFormat(Paths.font("vcr.ttf"), 64, bannerColor, "center");
	mainText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 4);
	mainText.antialiasing = true;
	bannerGroup.add(mainText);

	// Subtext
	if (subTextStr != null && subTextStr != "") {
		var subText = new FlxText(0, (FlxG.height * 0.38) + 70, FlxG.width, subTextStr);
		subText.setFormat(Paths.font("vcr.ttf"), 32, FlxColor.WHITE, "center");
		subText.setBorderStyle(FlxTextBorderStyle.OUTLINE, FlxColor.BLACK, 3);
		subText.antialiasing = true;
		bannerGroup.add(subText);
	}

	bannerGroup.scale.set(1.8, 1.8);
	bannerGroup.alpha = 0;
	add(bannerGroup);

	// Pop in animation
	FlxTween.tween(bannerGroup.scale, {x: 1.0, y: 1.0}, 0.28, {ease: FlxEase.backOut});
	FlxTween.tween(bannerGroup, {alpha: 1.0}, 0.20, {
		ease: FlxEase.cubeOut,
		onComplete: function(t:FlxTween) {
			new FlxTimer().start(0.85, function(tmr:FlxTimer) {
				FlxTween.tween(bannerGroup, {alpha: 0, y: bannerGroup.y - 50}, 0.50, {
					ease: FlxEase.quadIn,
					onComplete: function(t2:FlxTween) {
						remove(bannerGroup);
						bannerGroup.destroy();
					}
				});
			});
		}
	});
}

function onEvent(event) {
	if (event.event.name == "Round Announcer" || event.event.name == "Round Banner") {
		var params = event.event.params;
		var title:String = (params != null && params.length > 0 && params[0] != null) ? params[0] : "ROUND 2";
		var sub:String = (params != null && params.length > 1 && params[1] != null) ? params[1] : "";
		showRoundBanner(title, sub);
	}
}
