package game.objects;

class Chronology {
	public var CurrentYear:Int;
	public var MajorEvents:Map<Int, String> = new Map<Int, String>(); // Year -> Event Description

	public function new() {}

	public function AddEvent(year:Int, desc:String) {
		MajorEvents.set(year, desc);
	}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		prompt.add('### WORLD CHRONOLOGY\n');
		prompt.add('Current Year: $CurrentYear\n');
		if (MajorEvents.keys().hasNext()) {
			prompt.add('### CHRONOLOGY MAJOR EVENTS\n');
			for (e in MajorEvents.keys()) {
				prompt.add('Year: $e, Event: ${MajorEvents[e]}\n');
			}
		}
		return prompt.toString();
	}
}
