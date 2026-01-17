package game.objects;

import generation.SettlementGenerator;
import util.Random.RandomNumbers;
import generation.RegionGenerator;

class Region {
	public var Name:String;
	public var Biome:String; // Swamp, Tundra, Desert
	public var Settlements:Array<String> = new Array<String>(); // List of city IDs

	public function new() {}

	public function Generate() {
		Name = RegionGenerator.GenerateName();
		Biome = RegionGenerator.GetRandomBiome();
		GenerateSettlements();
	}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		prompt.add('Name: $Name\n');
		prompt.add('Biome: $Biome\n');
		if (Settlements.length > 0) {
			prompt.add('### $Name SETTLEMENTS\n');
			for (s in Settlements) {
				prompt.add('\n');
			}
		}
		return prompt.toString();
	}

	public function GenerateSettlements() {
		var settlements = RandomNumbers.intRange(2, 5);
		for (i in 0...settlements) {
			var name = SettlementGenerator.GenerateName();
			Settlements.push(name);
		}
	}
}
