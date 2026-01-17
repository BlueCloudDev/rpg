package game.objects;

import util.Random.RandomNumbers;
import generation.WorldGenerator;
import generation.RegionGenerator;
import generation.SettlementGenerator;

class World {
	public var Meta:WorldMetadata = new WorldMetadata();
	public var Chronology:Chronology = new Chronology();
	public var Geography:Geography = new Geography();
	public var Society:SociologicalData = new SociologicalData();

	public function new() {}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		prompt.add(Meta.GetPrompt());
		prompt.add(Chronology.GetPrompt());
		prompt.add(Geography.GetPrompt());
		prompt.add(Society.GetPrompt());
		return prompt.toString();
	}

	public function Generate() {
		Meta.Generate();
		Geography.Generate();
	}
}

class WorldMetadata {
	public var Name:String;
	public var Genre:String; // e.g., "Dark Fantasy", "Cyberpunk"
	public var Tone:String; // e.g., "Gritty", "Whimsical", "Eldritch"
	public var TechLevel:String; // e.g., "Iron Age", "Steam Age"
	public var MagicLevel:String; // e.g., "High Magic", "Low Magic"

	public function new() {}

	public function Generate() {
		Name = WorldGenerator.Generate(WorldGenerationTypes.Name);
		Genre = WorldGenerator.Generate(WorldGenerationTypes.Genre);
		Tone = WorldGenerator.Generate(WorldGenerationTypes.Tone);
		TechLevel = WorldGenerator.Generate(WorldGenerationTypes.TechLevel);
		MagicLevel = WorldGenerator.Generate(WorldGenerationTypes.MagicLevel);
	}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		prompt.add('### WORLD CONTEXT\n');
		prompt.add('Name: $Name\n');
		prompt.add('Genre: $Genre \n');
		prompt.add('Tone: $Tone \n');
		prompt.add('Tech: $TechLevel\n');
		prompt.add('Magic: $MagicLevel\n');
		return prompt.toString();
	}
}
