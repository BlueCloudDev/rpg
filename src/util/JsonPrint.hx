package util;

import haxe.Json;

class JsonPrint {
	/**
	 * Returns a random integer between min and max (inclusive).
	 */
	public static function Pretty(ob:Dynamic) {
		trace(Json.stringify(ob, null, "  "));
	}
}
