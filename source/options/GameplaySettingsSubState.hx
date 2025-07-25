package options;

import flixel.FlxG;

using StringTools;

class GameplaySettingsSubState extends BaseOptionsMenu
{
	public function playHitsound():Void {
		if(ClientPrefs.hitSounds != "OFF" && _timer > 0.125) {
			FlxG.sound.play(Paths.sound("hitsounds/" + ClientPrefs.hitSounds.toLowerCase()), ClientPrefs.hitsoundVolume);
			_timer = 0;
		}
	}
	public function new()
	{
		title = 'Gameplay Settings';
		rpcTitle = 'Gameplay Settings Menu'; //for Discord Rich Presence
		var option:Option = new Option('Hitsounds: ',
			"The sound that plays when you hit a note. Not recommended if you have an audio delay.",
			'hitSounds',
			'string',
			'OFF', ['OFF',
			'DAVE',
			'ANDROMEDA',
			'CAMELLIA',
			'OSU!MANIA'
		]);
		option.onChange = playHitsound;
		addOption(option);
		var option:Option = new Option('Hitsound Volume: ',
			"The volume of your hitsounds.", 
			"hitsoundVolume",
			"percent",
			1
		);
		option.onChange = playHitsound;
		option.scrollSpeed = 1.6;
		option.minValue = 0;
		option.maxValue = 1;
		option.changeValue = 0.05;
		option.decimals = 2;
		addOption(option);
		var option:Option = new Option('Controller Mode',
			'Check this if you want to play with\na controller instead of using your Keyboard.',
			'controllerMode',
			'bool',
			false);
		addOption(option);

		//I'd suggest using "Downscroll" as an example for making your own option since it is the simplest here
		var option:Option = new Option('Downscroll', //Name
			'If checked, notes go Down instead of Up, simple enough.', //Description
			'downScroll', //Save data variable name
			'bool', //Variable type
			false); //Default value
		addOption(option);

		var option:Option = new Option('Middlescroll',
			'If checked, your notes get centered.',
			'middleScroll',
			'bool',
			false);
		addOption(option);

		var option:Option = new Option('Opponent Notes',
			'If unchecked, opponent notes get hidden.',
			'opponentStrums',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Ghost Tapping',
			"If checked, you won't get misses from pressing keys\nwhile there are no notes able to be hit.",
			'ghostTapping',
			'bool',
			true);
		addOption(option);

		var option:Option = new Option('Disable Reset Button',
			"If checked, pressing Reset won't do anything.",
			'noReset',
			'bool',
			false);
		addOption(option);


		var option:Option = new Option('Rating Offset',
			'Changes how late/early you have to hit for a "Sick!"\nHigher values mean you have to hit later.',
			'ratingOffset',
			'int',
			0);
		option.displayFormat = '%vms';
		option.scrollSpeed = 20;
		option.minValue = -30;
		option.maxValue = 30;
		addOption(option);

		var option:Option = new Option('Marv Hit Window',
		'Changes the amount of time you have\nfor hitting a blue-colored "Sick!" in milliseconds.',
		'marvWindow',
		'int',
		20);
		option.displayFormat = '%vms';
		option.scrollSpeed = 10;
		option.minValue = 5;
		option.maxValue = 15;
		addOption(option);


		var option:Option = new Option('Sick! Hit Window',
			'Changes the amount of time you have\nfor hitting a "Sick!" in milliseconds.',
			'sickWindow',
			'int',
			45);
		option.displayFormat = '%vms';
		option.scrollSpeed = 15;
		option.minValue = 15;
		option.maxValue = 45;
		addOption(option);

		var option:Option = new Option('Good Hit Window',
			'Changes the amount of time you have\nfor hitting a "Good" in milliseconds.',
			'goodWindow',
			'int',
			90);
		option.displayFormat = '%vms';
		option.scrollSpeed = 30;
		option.minValue = 15;
		option.maxValue = 90;
		addOption(option);

		var option:Option = new Option('Bad Hit Window',
			'Changes the amount of time you have\nfor hitting a "Bad" in milliseconds.',
			'badWindow',
			'int',
			135);
		option.displayFormat = '%vms';
		option.scrollSpeed = 60;
		option.minValue = 15;
		option.maxValue = 135;
		addOption(option);

		var option:Option = new Option('Safe Frames',
			'Changes how many frames you have for\nhitting a note earlier or late.',
			'safeFrames',
			'float',
			10);
		option.scrollSpeed = 5;
		option.minValue = 2;
		option.maxValue = 10;
		option.changeValue = 0.1;
		addOption(option);

		super(0xffffffff);
	}

	var _timer:Float = 0;
	override public function update(elapsed:Float) {
		super.update(elapsed);
		_timer += elapsed;
	}

}