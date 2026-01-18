package generation;
import game.objects.World;

enum WorldGenerationTypes {
	Genre;
	Tone;
	TechLevel;
	MagicLevel;
	Name;
}

class WorldGenerator {
	static var genres:Array<String>;
	static var tones:Array<String>;
	static var techLevels:Array<String>;
	static var magicLevels:Array<String>;
	static var prefixes:Array<String>;
	static var roots:Array<String>;
	static var suffixes:Array<String>;

	public static function Init() {
		var content = hxd.Res.world.genres.entry.getText();
		genres = content.split("\n");
		content = hxd.Res.world.tones.entry.getText();
		tones = content.split("\n");
		content = hxd.Res.world.tech_levels.entry.getText();
		techLevels = content.split("\n");
		content = hxd.Res.world.magic_levels.entry.getText();
		magicLevels = content.split("\n");
		prefixes = hxd.Res.world.name_prefix.entry.getText().split("\n");
		roots = hxd.Res.world.name_root.entry.getText().split("\n");
		suffixes = hxd.Res.world.name_prefix.entry.getText().split("\n");
	}

	public static function Generate(type:WorldGenerationTypes) {
		switch (type) {
			case Genre:
				return genres[Std.random(genres.length)];
			case Tone:
				return tones[Std.random(tones.length)];
			case TechLevel:
				return techLevels[Std.random(techLevels.length)];
			case MagicLevel:
				return magicLevels[Std.random(magicLevels.length)];
			case Name:
				return GenerateName();
			default:
				trace("Invalid world generation type");
				return "";
		}
	}

	public static function GenerateWorld():World {
		var w = new World();
		w.Meta.Generate();
		w.Geography.Generate();
		return w;
	}

	/**
	 * Generates a random fantasy name.
	 * @param complex If true, adds a chance for a 3-part name (Prefix-Middle-Suffix).
	 */
	public static function GenerateName(complex:Bool = true):String {
		var name = "";

		// Pick a prefix
		var p = prefixes[Std.random(prefixes.length)];

		// Pick a suffix
		var s = suffixes[Std.random(suffixes.length)];

		// Occasionally add a middle syllable for complexity
		if (complex && Std.random(100) > 40) { // 60% chance of 3 syllables
			var m = roots[Std.random(roots.length)];
			name = p + m + s;
		} else {
			name = p + s;
		}

		// Capitalize first letter, lowercase the rest (just in case)
		name = formatName(name);

		return name;
	}


	static function formatName(s:String):String {
		if (s.length == 0)
			return "";
		return s.substr(0, 1).toUpperCase() + s.substr(1).toLowerCase();
	}
}
