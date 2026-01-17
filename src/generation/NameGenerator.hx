package generation;

class NameGenerator {
	static var prefixes:Array<String>;
	static var roots:Array<String>;
	static var suffixes:Array<String>;

	public static function Init() {
		prefixes = hxd.Res.name.name_prefix.entry.getText().split("\n");
		roots = hxd.Res.name.name_root.entry.getText().split("\n");
		suffixes = hxd.Res.name.name_suffix.entry.getText().split("\n");
	}

	public static function GetRandom():String {
		var name = prefixes[Std.random(prefixes.length)] + roots[Std.random(roots.length)] + suffixes[Std.random(suffixes.length)];
		return name;
	}
}
