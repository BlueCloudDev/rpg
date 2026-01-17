package game.objects;

class Faction {
	public var Name:String;
	public var Type:String; // "Guild", "Empire", "Cult"
	public var Goal:String;
	public var Relationships:Map<String, Int> = new Map<String, Int>(); // FactionID -> -100 to 100 (Hostility)

	public function GetPrompt():String {
		var b = new StringBuf();
		b.add('### FACTION $Name\n');
		b.add('Name: $Name\n');
		b.add('Type: $Type\n');
		b.add('Goal: $Goal\n');
		if (Relationships.keys().hasNext()) {
			b.add('### FACTION RELATIONSHIPS\n');
			for (r in Relationships.keys()) {
				b.add('Faction Name: $r');
				b.add('Hostility: ${Relationships[r]}');
			}
		}
		return b.toString();
	}
}
