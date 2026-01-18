package generation;

import hxd.Res;
import game.objects.Region;

class RegionGenerator {
	static var prefixes:Array<String>;
	static var roots:Array<String>;
	static var suffixes:Array<String>;
	static var biomes:Array<String>;

	public static function Init() {
		prefixes = Res.region.name_prefix.entry.getText().split("\n");
		roots = Res.region.name_root.entry.getText().split("\n");
		suffixes = Res.region.name_suffix.entry.getText().split("\n");
		biomes = Res.region.biome.entry.getText().split("\n");
	}

	public static function GenerateRegion() {
		var r = new Region();
		r.Name = GenerateName();
		r.Biome = GetRandomBiome();
		var ss = SettlementGenerator.GenerateSettlements();
		for (s in ss) {
			r.Settlements.set(s.Name, s);
		}
		return r;
	}

	public static function GenerateName():String {
		var roll = Math.random();

		var p = getRandom(prefixes);
		var r = getRandom(roots);
		var s = getRandom(suffixes);

		var name = "";

		// Pattern 1 (40%): Prefix + Root (e.g., "Darkwood")
		if (roll < 0.40) {
			name = p + r.toLowerCase();
		}
		// Pattern 2 (40%): Root + Suffix (e.g., "Woodgard")
		else if (roll < 0.80) {
			name = capitalize(r) + s;
		}
		// Pattern 3 (20%): Prefix + Root + Suffix (e.g., "Northumbria")
		else {
			name = p + r.toLowerCase() + s;
		}

		return name;
	}

	public static function GetRandomBiome():String {
		return biomes[Std.random(prefixes.length)];
	}

	// --- Helper Functions ---
	// Haxe doesn't have a built-in "random choice from array", so we make one
	static function getRandom(arr:Array<String>):String {
		if (arr.length == 0)
			return "";
		return arr[Math.floor(Math.random() * arr.length)];
	}

	// Helper to capitalize first letter, lower case the rest
	static function capitalize(str:String):String {
		if (str.length == 0)
			return "";
		return str.substring(0, 1).toUpperCase() + str.substring(1).toLowerCase();
	}
}
