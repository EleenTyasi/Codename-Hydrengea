public var newHealthBarBG:FunkinSprite;

function postCreate()
{
    newHealthBarBG = new FunkinSprite(0, FlxG.height == 720 ? 635 : 655);
    //newHealthBarBG.frames = Paths.getSparrowAtlas("game/yourhpbar"); <- use if animated
    newHealthBarBG.loadGraphic(Paths.image("game/healthbarSacorg")); // <- use if static
    insert(members.indexOf(healthBar) + 1, newHealthBarBG).screenCenter(FlxAxes.X);
    //newHealthBarBG.animation.addByPrefix("bar", "bar", 24, true); <- use if animated
    //newHealthBarBG.animation.play("bar"); <- use if animated
    newHealthBarBG.camera = camHUD;
    newHealthBarBG.antialiasing = Options.antialiasing;
    remove(healthBarBG.destroy());
    healthBar.scale.set(1, 2); // set ur scale here
}