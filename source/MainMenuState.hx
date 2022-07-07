package;

#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import flixel.util.FlxTimer;
import flixel.util.FlxSave;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.5.2h'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	var daChoice:String = '';

	//sprites
	var tv:FlxSprite;
	var arrows:FlxSprite;
	var tape1:FlxSprite;
	var tape2:FlxSprite;
	var tape3:FlxSprite;
	var tape4:FlxSprite;
	var tape5:FlxSprite;
	var tape6:FlxSprite;
	var reset:FlxSprite;

	var Grace:Bool = false;
	var Think:Bool = false;
	var ScaryNight:Bool = false;
	var Distraught:Bool = false;
	var Gift:Bool = false;
	var Thonk:Bool = false;

	var ThinkUnlocked:Bool = false;
	var ScaryNightUnlocked:Bool = false;
	var DistraughtUnlocked:Bool = false;
	var GiftUnlocked:Bool = false;
	var ThonkUnlocked:Bool = false;

	var Rkey:Bool = false;
	var Ckey:Bool = false;
	var canReset:Bool = false;
	
	var optionShit:Array<String> = [
		'story_mode',
		'freeplay',
		#if MODS_ALLOWED 'mods', #end
		#if ACHIEVEMENTS_ALLOWED 'awards', #end
		'credits',
		#if !switch 'donate', #end
		'options'
	];

	var camFollow:FlxObject;
	var camFollowPos:FlxObject;
	var debugKeys:Array<FlxKey>;

	override function create()
	{
		WeekData.loadTheFirstEnabledMod();

		ThinkUnlocked = FlxG.save.data.think = true;
		ScaryNightUnlocked = FlxG.save.data.scarynight = true;
		DistraughtUnlocked = FlxG.save.data.distraught = true;
		GiftUnlocked = FlxG.save.data.gift = true;
		ThonkUnlocked = FlxG.save.data.thonk = true;

		Grace = true;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement);
		FlxCamera.defaultCameras = [camGame];

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);

		camFollow = new FlxObject(0, 0, 1, 1);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		add(camFollow);
		add(camFollowPos);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		var bg:FlxSprite = new FlxSprite();
		bg.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
		bg.cameras = [camAchievement];
		add(bg);

		tv = new FlxSprite(0, 50).loadGraphic(Paths.image('tv'));
		tv.screenCenter(X);
		tv.antialiasing = ClientPrefs.globalAntialiasing;
		tv.cameras = [camAchievement];
		add(tv);

		var box:FlxSprite = new FlxSprite().loadGraphic(Paths.image('box'));
		box.screenCenter();
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.cameras = [camAchievement];
		add(box);

		tape1 = new FlxSprite(525, 425).loadGraphic(Paths.image('tapeMenu/grace'));
		tape1.antialiasing = ClientPrefs.globalAntialiasing;
		tape1.cameras = [camAchievement];
		add(tape1);

		if (ThinkUnlocked)
		{
			tape2 = new FlxSprite(800, 425).loadGraphic(Paths.image('tapeMenu/think'));
		}
		else
		{
			tape2 = new FlxSprite(800, 425).loadGraphic(Paths.image('tapeMenu/lockedthink'));
		}	
		tape2.antialiasing = ClientPrefs.globalAntialiasing;
		tape2.cameras = [camAchievement];
		add(tape2);

		if (ScaryNightUnlocked)
		{
			tape3 = new FlxSprite(850, 425).loadGraphic(Paths.image('tapeMenu/scarynight'));
		}
		else
		{
			tape3 = new FlxSprite(850, 425).loadGraphic(Paths.image('tapeMenu/lockedscarynight'));
		}	
		tape3.antialiasing = ClientPrefs.globalAntialiasing;
		tape3.cameras = [camAchievement];
		add(tape3);

		if (DistraughtUnlocked)
		{
			tape4 = new FlxSprite(900, 425).loadGraphic(Paths.image('tapeMenu/distraught'));
		}
		else
		{
			tape4 = new FlxSprite(900, 425).loadGraphic(Paths.image('tapeMenu/lockeddistraught'));
		}	
		tape4.antialiasing = ClientPrefs.globalAntialiasing;
		tape4.cameras = [camAchievement];
		add(tape4);

		if (GiftUnlocked)
		{
			tape5 = new FlxSprite(950, 425).loadGraphic(Paths.image('tapeMenu/gift'));
		}
		else
		{
			tape5 = new FlxSprite(950, 425).loadGraphic(Paths.image('tapeMenu/lockedgift'));
		}	
		tape5.antialiasing = ClientPrefs.globalAntialiasing;
		tape5.cameras = [camAchievement];
		add(tape5);

		if (ThonkUnlocked)
		{
			tape6 = new FlxSprite(1000, 425).loadGraphic(Paths.image('tapeMenu/thonk'));
		}
		else
		{
			tape6 = new FlxSprite(1000, 425).loadGraphic(Paths.image('tapeMenu/lockedthonk'));
		}	
		tape6.antialiasing = ClientPrefs.globalAntialiasing;
		tape6.cameras = [camAchievement];
		add(tape6);

		//tapes go here

		arrows = new FlxSprite().loadGraphic(Paths.image('tapeMenu/arrow'));
		arrows.screenCenter();
		arrows.antialiasing = ClientPrefs.globalAntialiasing;
		arrows.cameras = [camAchievement];
		add(arrows);

		var scale:Float = 1;
		/*if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var offset:Float = 108 - (Math.max(optionShit.length, 4) - 4) * 80;
			var menuItem:FlxSprite = new FlxSprite(0, (i * 140)  + offset);
			menuItem.scale.x = scale;
			menuItem.scale.y = scale;
			menuItem.frames = Paths.getSparrowAtlas('mainmenu/menu_' + optionShit[i]);
			menuItem.animation.addByPrefix('idle', optionShit[i] + " basic", 24);
			menuItem.animation.addByPrefix('selected', optionShit[i] + " white", 24);
			menuItem.animation.play('idle');
			menuItem.ID = i;
			menuItem.screenCenter(X);
			menuItems.add(menuItem);
			menuItems.visible = false;
			var scr:Float = (optionShit.length - 4) * 0.135;
			if(optionShit.length < 6) scr = 0;
		}

		FlxG.camera.follow(camFollowPos, null, 1);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		#if ACHIEVEMENTS_ALLOWED
		Achievements.loadAchievements();
		var leDate = Date.now();
		if (leDate.getDay() == 5 && leDate.getHours() >= 18) {
			var achieveID:Int = Achievements.getAchievementIndex('friday_night_play');
			if(!Achievements.isAchievementUnlocked(Achievements.achievementsStuff[achieveID][2])) { //It's a friday night. WEEEEEEEEEEEEEEEEEE
				Achievements.achievementsMap.set(Achievements.achievementsStuff[achieveID][2], true);
				giveAchievement();
				ClientPrefs.saveSettings();
			}
		}
		#end

		super.create();
	}

	#if ACHIEVEMENTS_ALLOWED
	// Unlocks "Freaky on a Friday Night" achievement
	function giveAchievement() {
		add(new AchievementObject('friday_night_play', camAchievement));
		FlxG.sound.play(Paths.sound('confirmMenu'), 0.7);
		trace('Giving achievement "friday_night_play"');
	}
	#end

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		if (FlxG.keys.justPressed.R)
		{
			Rkey = true;

			if (!Ckey)
			{
				reset = new FlxSprite(0, 0).loadGraphic(Paths.image('tapeMenu/are'));
				reset.antialiasing = ClientPrefs.globalAntialiasing;
				reset.screenCenter();
				reset.cameras = [camAchievement];
				add(reset);

				canReset = true;
			}
		}
		if (FlxG.keys.justPressed.C)
		{
			Ckey = true;
		}

		if (Rkey && Ckey)
		{
			FlxG.save.data.think = true;
			FlxG.save.data.think = true;
			FlxG.save.data.scarynight = true;
			FlxG.save.data.distraught = true;
			FlxG.save.data.gift = true;
			FlxG.save.data.think = true;
		}

		if (canReset)
		{
			if (FlxG.keys.justPressed.ENTER)
			{
				FlxG.save.data.think = false;
				FlxG.save.data.scarynight = false;
				FlxG.save.data.distraught = false;
				FlxG.save.data.gift = false;
				FlxG.save.data.thonk = false;

				canReset = false;
			}	

			if (FlxG.keys.justPressed.ESCAPE || FlxG.keys.justPressed.BACKSPACE)
			{
				canReset = false;
			}
		}

		if (FlxG.keys.justPressed.ONE)
		{
			FlxTween.tween(tape1, {x: 525}, 0.35);
			FlxTween.tween(tape2, {x: 800}, 0.35);
			FlxTween.tween(tape3, {x: 850}, 0.35);
			FlxTween.tween(tape4, {x: 900}, 0.35);
			FlxTween.tween(tape5, {x: 950}, 0.35);
			FlxTween.tween(tape6, {x: 1000}, 0.35);
			trace('Grace');
			Grace = true;
			Think = false;
			ScaryNight = false;
			Distraught = false;
			Gift = false;
			Thonk = false;
		}

		if (FlxG.keys.justPressed.TWO)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35);
			FlxTween.tween(tape2, {x: 525}, 0.35);
			FlxTween.tween(tape3, {x: 850}, 0.35);
			FlxTween.tween(tape4, {x: 900}, 0.35);
			FlxTween.tween(tape5, {x: 950}, 0.35);
			FlxTween.tween(tape6, {x: 1000}, 0.35);
			trace('Think'); 			
			if (ThinkUnlocked)
			{
				Grace = false;
				Think = true;
				ScaryNight = false;
				Distraught = false;
				Gift = false;
				Thonk = false;
			}
		}

		if (FlxG.keys.justPressed.THREE)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35);
			FlxTween.tween(tape2, {x: 50}, 0.35);
			FlxTween.tween(tape3, {x: 525}, 0.35);
			FlxTween.tween(tape4, {x: 900}, 0.35);
			FlxTween.tween(tape5, {x: 950}, 0.35);
			FlxTween.tween(tape6, {x: 1000}, 0.35);
			trace('Scary Night');
			if (ScaryNightUnlocked)
			{
				Grace = false;
				Think = false;
				ScaryNight = true;
				Distraught = false;
				Gift = false;
				Thonk = false;
			}
		}

		if (FlxG.keys.justPressed.FOUR)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35);
			FlxTween.tween(tape2, {x: 50}, 0.35);
			FlxTween.tween(tape3, {x: 100}, 0.35);
			FlxTween.tween(tape4, {x: 525}, 0.35);
			FlxTween.tween(tape5, {x: 950}, 0.35);
			FlxTween.tween(tape6, {x: 1000}, 0.35);
			trace('Distraught');			
			if (DistraughtUnlocked)
			{
				Grace = false;
				Think = false;
				ScaryNight = false;
				Distraught = true;
				Gift = false;
				Thonk = false;
			}
		}

		if (FlxG.keys.justPressed.FIVE)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35);
			FlxTween.tween(tape2, {x: 50}, 0.35);
			FlxTween.tween(tape3, {x: 100}, 0.35);
			FlxTween.tween(tape4, {x: 150}, 0.35);
			FlxTween.tween(tape5, {x: 525}, 0.35);
			FlxTween.tween(tape6, {x: 1000}, 0.35);
			trace('Gift');			
			if (GiftUnlocked)
			{
				Grace = false;
				Think = false;
				ScaryNight = false;
				Distraught = false;
				Gift = true;
				Thonk = false;
			}
		}

		if (FlxG.keys.justPressed.SIX)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35);
			FlxTween.tween(tape2, {x: 50}, 0.35);
			FlxTween.tween(tape3, {x: 100}, 0.35);
			FlxTween.tween(tape4, {x: 150}, 0.35);
			FlxTween.tween(tape5, {x: 200}, 0.35);
			FlxTween.tween(tape6, {x: 525}, 0.35);
			if (ThonkUnlocked)
			{
				Grace = false;
				Think = false;
				ScaryNight = false;
				Distraught = false;
				Gift = false;
				Thonk = true;
			}
			trace('Thonk');
		}

		if (FlxG.keys.justPressed.ENTER && !canReset)
		{
			FlxTween.tween(tape1, {y: 350}, 0.55);
			FlxTween.tween(tape2, {y: 350}, 0.55);
			FlxTween.tween(tape3, {y: 350}, 0.55);
			FlxTween.tween(tape4, {y: 350}, 0.55);
			FlxTween.tween(tape5, {y: 350}, 0.55);
			FlxTween.tween(tape6, {y: 350}, 0.55);

			FlxTween.tween(camAchievement, {angle: 100}, 0.55);
			FlxTween.tween(camAchievement, {zoom: 2.5}, 0.55, {onComplete:
				function (twn:FlxTween)
				{
					var black:FlxSprite = new FlxSprite();
					black.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					black.cameras = [camAchievement];
					add(black);

					if (Grace)
					{
						trace('loading grace');
						PlayState.SONG = Song.loadFromJson('grace', 'grace');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;
						PlayState.storyWeek = 1;
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
					}

					if (Think && ThinkUnlocked)
					{
						PlayState.SONG = Song.loadFromJson('think-hard', 'think');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 2;
						PlayState.storyWeek = 1;
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
					}

					if (ScaryNight && ScaryNightUnlocked)
					{
						trace('loading scary-night');
						PlayState.SONG = Song.loadFromJson('scary-night', 'scary-night');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;
						PlayState.storyWeek = 1;
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
					}

					if (Distraught && DistraughtUnlocked)
					{
						trace('loading distraught');
						PlayState.SONG = Song.loadFromJson('distraught', 'distraught');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;
						PlayState.storyWeek = 1;
						FlxTransitionableState.skipNextTransIn = true;
					    FlxTransitionableState.skipNextTransOut = true;
					}

					if (Gift && GiftUnlocked)
					{
						trace('loading gift');
						PlayState.SONG = Song.loadFromJson('gift', 'gift');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;
						PlayState.storyWeek = 1;
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;
					}

					if (Thonk && ThonkUnlocked)
					{
						trace('loading thonk');
						PlayState.SONG = Song.loadFromJson('thonk', 'thonk');
						PlayState.isStoryMode = false;
						PlayState.storyDifficulty = 1;
						PlayState.storyWeek = 1;
						FlxTransitionableState.skipNextTransIn = true;
						FlxTransitionableState.skipNextTransOut = true;	
					}

					LoadingState.loadAndSwitchState(new PlayState());
				}
			});
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
		camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_UP_P)
			{
				//FlxG.sound.play(Paths.sound('scrollMenu'));
				//changeItem(-1);
			}

			if (controls.UI_DOWN_P)
			{
				//FlxG.sound.play(Paths.sound('scrollMenu'));
				//changeItem(1);
			}

			if (controls.UI_LEFT_P)
			{
				selectedSomethin = true;
				arrows.visible = false;
				FlxTween.tween(tape1, {x: -500}, 0.35);
				FlxTween.tween(tape2, {x: -500}, 0.35);
				FlxTween.tween(tape3, {x: -500}, 0.35);
				FlxTween.tween(tape4, {x: -500}, 0.35);
				FlxTween.tween(tape5, {x: -500}, 0.35);
				FlxTween.tween(tape6, {x: -500}, 0.35);
				FlxTween.tween(tv, {y: 150}, 0.35, {onComplete:
					function (twn:FlxTween)
					{
						FlxTween.tween(camAchievement, {x: 1500}, 0.4, {onComplete:
							function (twn:FlxTween)
							{
							    LoadingState.loadAndSwitchState(new options.OptionsState());
						    }});
					}});
			}
	
			if (controls.UI_RIGHT_P)
			{
				selectedSomethin = true;
				arrows.visible = false;
				FlxTween.tween(tape1, {x: 1500}, 0.35);
				FlxTween.tween(tape2, {x: 1500}, 0.35);
				FlxTween.tween(tape3, {x: 1500}, 0.35);
				FlxTween.tween(tape4, {x: 1500}, 0.35);
				FlxTween.tween(tape5, {x: 1500}, 0.35);
				FlxTween.tween(tape6, {x: 1500}, 0.35);
				FlxTween.tween(tv, {y: 150}, 0.35, {onComplete:
					function (twn:FlxTween)
					{
						FlxTween.tween(camAchievement, {x: -1500}, 0.4, {onComplete:
							function (twn:FlxTween)
							{
								MusicBeatState.switchState(new CreditsState());
						    }});
					}});
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
			{
				if (optionShit[curSelected] == 'donate')
				{
					//CoolUtil.browserLoad('https://ninja-muffin24.itch.io/funkin');
				}
			}
			#if desktop
			else if (FlxG.keys.anyJustPressed(debugKeys))
			{
				selectedSomethin = true;
				MusicBeatState.switchState(new MasterEditorMenu());
			}
			#end
		}

		super.update(elapsed);

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.screenCenter(X);
		});
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		menuItems.forEach(function(spr:FlxSprite)
		{
			spr.animation.play('idle');
			spr.updateHitbox();

			if (spr.ID == curSelected)
			{
				spr.animation.play('selected');
				var add:Float = 0;
				if(menuItems.length > 4) {
					add = menuItems.length * 8;
				}
				camFollow.setPosition(spr.getGraphicMidpoint().x, spr.getGraphicMidpoint().y - add);
				spr.centerOffsets();
			}
		});
	}
}
