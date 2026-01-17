package game.objects;

class Location {
	public var ID:String;
	public var Name:String;
	public var Type:String;

	public function new() {}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		prompt.add('### LOCATION DATA\n');
		prompt.add('Name: $Name\n');
		prompt.add('Type: $Type\n');
		return prompt.toString();
	}
}
