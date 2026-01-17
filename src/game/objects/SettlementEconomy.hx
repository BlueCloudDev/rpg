package game.objects;

class SettlementEconomy {
	public var WealthLevel:String; // "Destitute", "Average", "Wealthy"
	public var MainExport:String;
	public var MainImport:String;
	public var Corruption:Int;

	public function new() {}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		prompt.add("### SETTLEMENT ECONOMY DATA \n");
		prompt.add('WealthLevel: $WealthLevel\n');
		prompt.add('Main Export: $MainExport\n');
		prompt.add('Corruption: $Corruption/10\n');
		return prompt.toString();
	}
}
