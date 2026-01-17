package game.objects;

import util.Random.RandomNumbers;

class Geography {
	public var Regions:Map<String, Region> = new Map<String, Region>();

	public function new() {}

	public function Generate() {
		var numRegion = RandomNumbers.intRange(3, 6);
		for (i in 0...numRegion) {
			var r = new Region();
			r.Generate();
			Regions.set(r.Name, r);
		}
	}

	public function GetPrompt():String {
		var prompt = new StringBuf();
		if (Regions.keys().hasNext()) {
			prompt.add('### REGIONS\n');
			for (r in Regions.keys()) {
				prompt.add(Regions[r].GetPrompt());
			}
		}
		return prompt.toString();
	}
}
