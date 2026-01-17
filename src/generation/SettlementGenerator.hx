package generation;

import hxd.Res;

class SettlementGenerator {
	static var prefixes:Array<String>;
	static var roots:Array<String>;
	static var suffixes:Array<String>;

	public static function Init() {
		prefixes = Res.settlement.name_prefix.entry.getText().split("\n");
		roots = Res.settlement.name_root.entry.getText().split("\n");
		suffixes = Res.settlement.name_suffix.entry.getText().split("\n");
	}

	public static function GenerateName():String {
		var roll = Math.random();

		var p = getRandom(prefixes);
		var r = getRandom(roots);
		var s = getRandom(suffixes);

		var name = "";

		// Logic adjusted for Settlements (Towns usually favor Root+Suffix)

		if (roll < 0.20) {
			name = p + " " + r;
		} else if (roll < 0.80) {
			name = r + s;
		} else {
			name = p + " " + r + s;
		}

		return name;
	}

	// --- Helper Functions ---

	static function getRandom(arr:Array<String>):String {
		if (arr.length == 0)
			return "";
		return arr[Math.floor(Math.random() * arr.length)];
	}
}
