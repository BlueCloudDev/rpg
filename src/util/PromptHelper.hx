package util;

class PromptHelper {
	// Helper to get descriptive labels without breaking the parser
	public static function GetRelativeDescription(val:Int, high:Int, low:Int, highStr:String, lowStr:String):String {
		if (val > high) {
			return highStr;
		}
		if (val < low) {
			return lowStr;
		}
		return "Average";
	};
}
