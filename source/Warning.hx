package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import lime.app.Application;
import flixel.addons.transition.FlxTransitionableState;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;

class Warning extends MusicBeatState
{
	var leftState:Bool = false;
	var warning:FlxSprite;

	override function create()
	{
		super.create();

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		add(bg);

		warning = new FlxSprite(0, 100).loadGraphic(Paths.image('tapeMenu/warning'));
		warning.screenCenter();
		warning.antialiasing = ClientPrefs.globalAntialiasing;
		warning.alpha = 0;
		add(warning);

		FlxG.sound.music.pause();
		FlxG.sound.play(Paths.sound('scary'));

		new FlxTimer().start(3.25, function(tmr:FlxTimer)
		{
			FlxTween.tween(warning, {alpha: 1}, 1);
			FlxG.sound.music.resume();
		});
	}

	override function update(elapsed:Float)
	{
		if(!leftState) {
			if (controls.ACCEPT) {
				leftState = true;
			}
			
			if(controls.BACK) {
				leftState = true;
			}
		}

		if(leftState)
		{
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new MainMenuState());
		}

		super.update(elapsed);
	}
}
