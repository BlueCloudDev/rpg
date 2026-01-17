package game.objects;

class SociologicalData {
	public var Factions:Map<String, Faction> = new Map<String, Faction>();

	public function new() {}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		prompt.add('### FACTION DATA');
		if (Factions.keys().hasNext()) {
			for (f in Factions.keys()) {
				prompt.add(Factions[f].GetPrompt());
			}
		}
		return prompt.toString();
	}
}
