package generation;

import hxd.Res;
import util.Random.RandomNumbers;
import game.objects.SettlementTypeData;
import haxe.Json;
import game.objects.SettlementEconomy;
import game.objects.Settlement;

class SettlementGenerator {
	static var prefixes:Array<String>;
	static inline var MIN_POP_EXPORTS:Int = 200;
	static var roots:Array<String>;
	static var suffixes:Array<String>;
	static var settlementTypeData:Array<SettlementTypeData>;
	static var wealthLevels: Array<String>;

	public static function Init() {
		prefixes = Res.settlement.name_prefix.entry.getText().split("\n");
		roots = Res.settlement.name_root.entry.getText().split("\n");
		suffixes = Res.settlement.name_suffix.entry.getText().split("\n");
		wealthLevels = Res.settlement.wealth_levels.entry.getText().split("\n");
		var std = Res.settlement.settlement_type.entry.getText();
		settlementTypeData = Json.parse(std);
		settlementTypeData.sort((a,b) -> Reflect.compare(a.MinPop, b.MinPop));
	}

	public static function GenerateName():String {
		var roll = Math.random();

		var p = getRandom(prefixes);
		var r = getRandom(roots);
		var s = getRandom(suffixes);

		var name = "";

		// Logic adjusted for Settlements (Towns usually favor Root+Suffix)

		if (roll < 0.20) {
			name = p + " " + r;
		} else if (roll < 0.80) {
			name = r + s;
		} else {
			name = p + " " + r + s;
		}

		return name;
	}

	public static function GenerateSettlements() {
		var ses = new Array<Settlement>();
		var num = RandomNumbers.intRange(2, 5);
		for (i in 0...num) {
			var s = new Settlement();
			s.Name = GenerateName();
			s.Population = GeneratePopulation();
			s.Type = GetSettlementType(s.Population);
			s.Economy = GenerateSettlementEconomy(s.Population);
			ses.push(s);
		}
		return ses;
	}
	public static function GeneratePopulation():Int {
		var pop = RandomNumbers.intRange(10,10000);
		return pop;
	}

	public static function GetSettlementType(population: Int):String {
		for(s in settlementTypeData) {
			if (population >= s.MinPop) {
				return s.Type;
			}
		}
		return "Invalid";
	}

	public static function GenerateSettlementEconomy(population: Int):SettlementEconomy{
		var se = new SettlementEconomy();
		se.WealthLevel = wealthLevels[Std.random(wealthLevels.length)];
		if (population >= MIN_POP_EXPORTS) {
			
		}
		return se;
	}

	// --- Helper Functions ---

	static function getRandom(arr:Array<String>):String {
		if (arr.length == 0)
			return "";
		return arr[Math.floor(Math.random() * arr.length)];
	}
}
