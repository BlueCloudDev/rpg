package game.objects;

class Settlement {
	public var ID:String;
	public var Name:String;
	public var Type:String; // "Village", "City", "Fortress", "Hamlet"
	public var Population:Int;
	public var DefenseLevel:String; // "None", "Palisade", "Stone Walls"

	// Data Containers
	public var Economy:SettlementEconomy = new SettlementEconomy();
	// public var Districts: Map<String, District> = new Map<String, District>();
	public var KeyLocations:Map<String, Location> = new Map<String, Location>();

	public function new() {}

	public function GetPrompt():String {
		var b = new StringBuf();
		b.add("### SETTLEMENT $Name\n");
		b.add("Name: " + Name + "\n");
		b.add("Type: " + Type + "\n");
		b.add("Population: " + Population + "\n");
		b.add("Defense Level: " + DefenseLevel + "\n");
		b.add(Economy.GetPrompt());

		// Check if map has keys using iterator
		if (KeyLocations.keys().hasNext()) {
			b.add("\nKey Locations:\n");
			// Iterating a Map in Haxe gives you the Values directly
			for (loc in KeyLocations) {
				b.add("- " + loc.Name + " (" + loc.Type + "):\n");
			}
		}
		return b.toString();
	}
}
