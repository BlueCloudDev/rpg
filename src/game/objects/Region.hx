package game.objects;

import generation.SettlementGenerator;
import util.Random.RandomNumbers;
import generation.RegionGenerator;

class Region {
	public var Name:String;
	public var Biome:String; // Swamp, Tundra, Desert
	public var Settlements:Map<String, Settlement> = new Map<String, Settlement>(); // List of city IDs

	public function new() {}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		prompt.add('Name: $Name\n');
		prompt.add('Biome: $Biome\n');
		if (Settlements.iterator().hasNext()) {
			prompt.add('### $Name SETTLEMENTS\n');
			for (name => settlement in Settlements) {
				prompt.add('\n');
			}
		}
		return prompt.toString();
	}

}
