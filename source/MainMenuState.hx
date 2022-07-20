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
	var box:FlxSprite;
	var tv:FlxSprite;
	var arrows:FlxSprite;
	var tape1:FlxSprite;
	var tape2:FlxSprite;
	var tape3:FlxSprite;
	var tape4:FlxSprite;
	var tape5:FlxSprite;
	var tape6:FlxSprite;
	var reset:FlxSprite;
	var resetBG:FlxSprite;

	var Grace:Bool = false;
	var Think:Bool = false;
	var ScaryNight:Bool = false;
	var Distraught:Bool = false;
	var Gift:Bool = false;
	var Thonk:Bool = false;
	var GraceSelected:Bool = false;

	var ThinkUnlocked:Bool = false;
	var ScaryNightUnlocked:Bool = false;
	var DistraughtUnlocked:Bool = false;
	var GiftUnlocked:Bool = false;
	var ThonkUnlocked:Bool = false;

	var Rkey:Bool = false;
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

		ThinkUnlocked = ClientPrefs.ThinkUnlocked;
		ScaryNightUnlocked = ClientPrefs.ScaryNightUnlocked;
		DistraughtUnlocked = ClientPrefs.DistraughtUnlocked;
		GiftUnlocked = ClientPrefs.GiftUnlocked;
		ThonkUnlocked = ClientPrefs.ThonkUnlocked;

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

		box = new FlxSprite().loadGraphic(Paths.image('box'));
		box.screenCenter();
		box.antialiasing = ClientPrefs.globalAntialiasing;
		box.cameras = [camAchievement];
		add(box);

		tape1 = new FlxSprite(525, 495).loadGraphic(Paths.image('tapeMenu/grace'));
		tape1.antialiasing = ClientPrefs.globalAntialiasing;
		tape1.cameras = [camAchievement];
		add(tape1);

		if (ThinkUnlocked)
		{
			tape2 = new FlxSprite(800, 495).loadGraphic(Paths.image('tapeMenu/think'));
		}
		else
		{
			tape2 = new FlxSprite(800, 495).loadGraphic(Paths.image('tapeMenu/lockedthink'));
		}
		tape2.antialiasing = ClientPrefs.globalAntialiasing;
		tape2.cameras = [camAchievement];
		add(tape2);

		if (ScaryNightUnlocked)
		{
			tape3 = new FlxSprite(850, 495).loadGraphic(Paths.image('tapeMenu/scarynight'));
		}
		else
		{
			tape3 = new FlxSprite(850, 495).loadGraphic(Paths.image('tapeMenu/lockedscarynight'));
		}	
		tape3.antialiasing = ClientPrefs.globalAntialiasing;
		tape3.cameras = [camAchievement];
		add(tape3);

		if (DistraughtUnlocked)
		{
			tape4 = new FlxSprite(900, 495).loadGraphic(Paths.image('tapeMenu/distraught'));
		}
		else
		{
			tape4 = new FlxSprite(900, 495).loadGraphic(Paths.image('tapeMenu/lockeddistraught'));
		}	
		tape4.antialiasing = ClientPrefs.globalAntialiasing;
		tape4.cameras = [camAchievement];
		add(tape4);

		if (GiftUnlocked)
		{
			tape5 = new FlxSprite(950, 495).loadGraphic(Paths.image('tapeMenu/gift'));
		}
		else
		{
			tape5 = new FlxSprite(950, 495).loadGraphic(Paths.image('tapeMenu/lockedgift'));
		}
		tape5.antialiasing = ClientPrefs.globalAntialiasing;
		tape5.cameras = [camAchievement];
		add(tape5);

		if (ThonkUnlocked)
		{
			tape6 = new FlxSprite(1000, 495).loadGraphic(Paths.image('tapeMenu/thonk'));
		}
		else
		{
			tape6 = new FlxSprite(1000, 495).loadGraphic(Paths.image('tapeMenu/lockedthonk'));
		}	
		tape6.antialiasing = ClientPrefs.globalAntialiasing;
		tape6.cameras = [camAchievement];
		add(tape6);

		//tapes go here

		arrows = new FlxSprite().loadGraphic(Paths.image('tapeMenu/arrow'));
		arrows.screenCenter();
		arrows.antialiasing = ClientPrefs.globalAntialiasing;
		arrows.cameras = [camAchievement];
		arrows.alpha = 0.5;
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
			resetBG = new FlxSprite();
			resetBG.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
			resetBG.cameras = [camAchievement];
			resetBG.alpha = 0;
			add(resetBG);
			
			reset = new FlxSprite(0, 0).loadGraphic(Paths.image('tapeMenu/are'));
			reset.antialiasing = ClientPrefs.globalAntialiasing;
			reset.screenCenter();
			reset.cameras = [camAchievement];
			reset.alpha = 0;
			add(reset);

			new FlxTimer().start(0.5, function(tmr:FlxTimer) {
				FlxTween.tween(resetBG, {alpha: 0.5}, 0.5);
				FlxTween.tween(reset, {alpha: 1}, 0.5);
			});

			canReset = true;
		}

		if (Rkey && FlxG.keys.justPressed.C)
		{
			ClientPrefs.ThinkUnlocked = true;
			ClientPrefs.ScaryNightUnlocked = true;
			ClientPrefs.DistraughtUnlocked = true;
			ClientPrefs.GiftUnlocked = true;
			ClientPrefs.ThonkUnlocked = true;
			ClientPrefs.saveSettings();
			resetBG.alpha = 0;
			reset.alpha = 0;
			canReset = false;
		}

		if (canReset)
		{
			if (FlxG.keys.justPressed.Y)
			{
				ClientPrefs.ThinkUnlocked = false;
				ClientPrefs.ScaryNightUnlocked = false;
				ClientPrefs.DistraughtUnlocked = false;
				ClientPrefs.GiftUnlocked = false;
				ClientPrefs.ThonkUnlocked = false;
				ClientPrefs.saveSettings();
				resetBG.alpha = 0;
				reset.alpha = 0;
				canReset = false;
			}

			if (FlxG.keys.justPressed.N)
			{
				resetBG.alpha = 0;
				reset.alpha = 0;
				canReset = false;
			}
		}

		if (FlxG.keys.justPressed.ONE)
		{
			FlxTween.tween(tape1, {x: 525}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape2, {x: 800}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape3, {x: 850}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape4, {x: 900}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape5, {x: 950}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape6, {x: 1000}, 0.35, {ease: FlxEase.cubeOut});
			trace('Grace');
			Grace = true;
			Think = false;
			ScaryNight = false;
			Distraught = false;
			Gift = false;
			Thonk = false;
			GraceSelected = true;
		}

		if (FlxG.keys.justPressed.TWO)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape2, {x: 525}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape3, {x: 850}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape4, {x: 900}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape5, {x: 950}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape6, {x: 1000}, 0.35, {ease: FlxEase.cubeOut});
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
			GraceSelected = false;
		}

		if (FlxG.keys.justPressed.THREE)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape2, {x: 50}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape3, {x: 525}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape4, {x: 900}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape5, {x: 950}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape6, {x: 1000}, 0.35, {ease: FlxEase.cubeOut});
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
			GraceSelected = false;
		}

		if (FlxG.keys.justPressed.FOUR)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape2, {x: 50}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape3, {x: 100}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape4, {x: 525}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape5, {x: 950}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape6, {x: 1000}, 0.35, {ease: FlxEase.cubeOut});
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
			GraceSelected = false;
		}

		if (FlxG.keys.justPressed.FIVE)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape2, {x: 50}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape3, {x: 100}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape4, {x: 150}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape5, {x: 525}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape6, {x: 1000}, 0.35, {ease: FlxEase.cubeOut});
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
			GraceSelected = false;
		}

		if (FlxG.keys.justPressed.SIX)
		{
			FlxTween.tween(tape1, {x: 0}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape2, {x: 50}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape3, {x: 100}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape4, {x: 150}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape5, {x: 200}, 0.35, {ease: FlxEase.cubeOut});
			FlxTween.tween(tape6, {x: 525}, 0.35, {ease: FlxEase.cubeOut});
			if (ThonkUnlocked)
			{
				Grace = false;
				Think = false;
				ScaryNight = false;
				Distraught = false;
				Gift = false;
				Thonk = true;
			}
			GraceSelected = false;
			trace('Thonk');
		}

		// grace
		// This looks ridiculous, but it works though.
		// I've been trying to get this to work for a while and I was starting to get very frustrated.
		if (FlxG.keys.justPressed.ENTER && !canReset && Grace && GraceSelected)
		{
			arrows.visible = false;
			FlxTween.tween(tape1, {y: 450}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape2, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape3, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape4, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape5, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape6, {y: 50}, 0.95, {ease: FlxEase.cubeIn});

			FlxTween.tween(camAchievement, {angle: 100}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(box, {y: 950}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tv, {y: 150}, 0.55, {ease: FlxEase.cubeOut});
			FlxTween.tween(camAchievement, {zoom: 3.5}, 0.95, {
				ease: FlxEase.cubeIn,
				onComplete: function (twn:FlxTween)
				{
					var black:FlxSprite = new FlxSprite();
					black.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					black.cameras = [camAchievement];
					add(black);

					trace('loading grace');
					PlayState.SONG = Song.loadFromJson('grace', 'grace');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 1;
					PlayState.storyWeek = 1;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					LoadingState.loadAndSwitchState(new PlayState());
				}
			});
		}

		// think
		if (FlxG.keys.justPressed.ENTER && !canReset && Think && ThinkUnlocked && !GraceSelected)
		{
			arrows.visible = false;
			FlxTween.tween(tape1, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape2, {y: 450}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape3, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape4, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape5, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape6, {y: 50}, 0.95, {ease: FlxEase.cubeIn});

			FlxTween.tween(camAchievement, {angle: 100}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(box, {y: 950}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tv, {y: 150}, 0.55, {ease: FlxEase.cubeOut});
			FlxTween.tween(camAchievement, {zoom: 3.5}, 0.95, {
				ease: FlxEase.cubeIn,
				onComplete: function (twn:FlxTween)
				{
					var black:FlxSprite = new FlxSprite();
					black.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					black.cameras = [camAchievement];
					add(black);

					trace("loading think");
					PlayState.SONG = Song.loadFromJson('think-hard', 'think');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 2;
					PlayState.storyWeek = 1;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					LoadingState.loadAndSwitchState(new PlayState());
				}
			});
		}	

		// scary night
		if (FlxG.keys.justPressed.ENTER && !canReset && ScaryNight && ScaryNightUnlocked && !GraceSelected)
		{
			arrows.visible = false;
			FlxTween.tween(tape1, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape2, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape3, {y: 450}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape4, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape5, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape6, {y: 50}, 0.95, {ease: FlxEase.cubeIn});

			FlxTween.tween(camAchievement, {angle: 100}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(box, {y: 950}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tv, {y: 150}, 0.55, {ease: FlxEase.cubeOut});
			FlxTween.tween(camAchievement, {zoom: 3.5}, 0.95, {
				ease: FlxEase.cubeIn,
				onComplete: function (twn:FlxTween)
				{
					var black:FlxSprite = new FlxSprite();
					black.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					black.cameras = [camAchievement];
					add(black);

					trace('loading scary-night');
					PlayState.SONG = Song.loadFromJson('scary-night', 'scary-night');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 1;
					PlayState.storyWeek = 1;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					LoadingState.loadAndSwitchState(new PlayState());
				}
			});
		}

		// distraught
		if (FlxG.keys.justPressed.ENTER && !canReset && Distraught && DistraughtUnlocked && !GraceSelected)
		{
			arrows.visible = false;
			FlxTween.tween(tape1, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape2, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape3, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape4, {y: 450}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape5, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape6, {y: 50}, 0.95, {ease: FlxEase.cubeIn});

			FlxTween.tween(camAchievement, {angle: 100}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(box, {y: 950}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tv, {y: 150}, 0.55, {ease: FlxEase.cubeOut});
			FlxTween.tween(camAchievement, {zoom: 3.5}, 0.95, {
				ease: FlxEase.cubeIn,
				onComplete: function (twn:FlxTween)
				{
					var black:FlxSprite = new FlxSprite();
					black.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					black.cameras = [camAchievement];
					add(black);

					trace('loading distraught');
					PlayState.SONG = Song.loadFromJson('distraught', 'distraught');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 1;
					PlayState.storyWeek = 1;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					LoadingState.loadAndSwitchState(new PlayState());
				}
			});
		}

		// gift
		if (FlxG.keys.justPressed.ENTER && !canReset && Gift && GiftUnlocked && !GraceSelected)
		{
			arrows.visible = false;
			FlxTween.tween(tape1, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape2, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape3, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape4, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape5, {y: 450}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape6, {y: 50}, 0.95, {ease: FlxEase.cubeIn});

			FlxTween.tween(camAchievement, {angle: 100}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(box, {y: 950}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tv, {y: 150}, 0.55, {ease: FlxEase.cubeOut});
			FlxTween.tween(camAchievement, {zoom: 3.5}, 0.95, {
				ease: FlxEase.cubeIn,
				onComplete: function (twn:FlxTween)
				{
					var black:FlxSprite = new FlxSprite();
					black.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					black.cameras = [camAchievement];
					add(black);

					trace('loading gift');
					PlayState.SONG = Song.loadFromJson('gift', 'gift');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 1;
					PlayState.storyWeek = 1;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					LoadingState.loadAndSwitchState(new PlayState());
				}
			});
		}

		// thonk
		if (FlxG.keys.justPressed.ENTER && !canReset && Thonk && ThonkUnlocked && !GraceSelected)
		{
			arrows.visible = false;
			FlxTween.tween(tape1, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape2, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape3, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape4, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape5, {y: 50}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tape6, {y: 450}, 0.95, {ease: FlxEase.cubeIn});

			FlxTween.tween(camAchievement, {angle: 100}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(box, {y: 950}, 0.95, {ease: FlxEase.cubeIn});
			FlxTween.tween(tv, {y: 150}, 0.55, {ease: FlxEase.cubeOut});
			FlxTween.tween(camAchievement, {zoom: 3.5}, 0.95, {
				ease: FlxEase.cubeIn,
				onComplete: function (twn:FlxTween)
				{
					var black:FlxSprite = new FlxSprite();
					black.makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
					black.cameras = [camAchievement];
					add(black);

					trace('loading thonk');
					PlayState.SONG = Song.loadFromJson('thonk', 'thonk');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 1;
					PlayState.storyWeek = 1;
					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

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
				FlxTween.tween(tape1, {x: -500}, 0.75, {ease: FlxEase.cubeIn});
				FlxTween.tween(tape2, {x: -500}, 0.75, {ease: FlxEase.cubeIn});
				FlxTween.tween(tape3, {x: -500}, 0.75, {ease: FlxEase.cubeIn});
				FlxTween.tween(tape4, {x: -500}, 0.75, {ease: FlxEase.cubeIn});
				FlxTween.tween(tape5, {x: -500}, 0.75, {ease: FlxEase.cubeIn});
				FlxTween.tween(tape6, {x: -500}, 0.75, {ease: FlxEase.cubeIn});
				FlxTween.tween(tv, {y: 150}, 0.5, {ease: FlxEase.cubeIn});
				new FlxTimer().start(0.2, function(timer:FlxTimer){
					FlxTween.tween(camAchievement, {x: 1500}, 0.5, {
					ease: FlxEase.cubeIn,
					onComplete:function (twn:FlxTween)
					{
						LoadingState.loadAndSwitchState(new options.OptionsState());
					}});
				});
			}
	
			if (controls.UI_RIGHT_P)
			{
				selectedSomethin = true;
				arrows.visible = false;
				FlxTween.tween(tape1, {x: 1500}, 0.75, {ease: FlxEase.cubeOut});
				FlxTween.tween(tape2, {x: 1500}, 0.75, {ease: FlxEase.cubeOut});
				FlxTween.tween(tape3, {x: 1500}, 0.75, {ease: FlxEase.cubeOut});
				FlxTween.tween(tape4, {x: 1500}, 0.75, {ease: FlxEase.cubeOut});
				FlxTween.tween(tape5, {x: 1500}, 0.75, {ease: FlxEase.cubeOut});
				FlxTween.tween(tape6, {x: 1500}, 0.75, {ease: FlxEase.cubeOut});
				FlxTween.tween(tv, {y: 150}, 0.55, {ease: FlxEase.cubeOut});
				new FlxTimer().start(0.2, function(timer:FlxTimer) {
					FlxTween.tween(camAchievement, {x: -1500}, 0.5, {
					ease: FlxEase.cubeIn,
					onComplete:function (twn:FlxTween)
					{
						MusicBeatState.switchState(new CreditsState());
					}});
			    });
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new TitleState());
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
