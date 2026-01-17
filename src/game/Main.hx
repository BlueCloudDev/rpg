package game;

import haxe.Json;
import h3d.scene.World;
import game.services.Gemma;
import sys.thread.Deque;
import generation.NameGenerator;
import generation.ApperanceGenerator;
import generation.SettlementGenerator;
import generation.RegionGenerator;
import generation.WorldGenerator;

class Main extends hxd.App {
	var outputText:h2d.Text;

	var responseQueue:Deque<String> = new Deque<String>();

	override function init() {
		// ------------------------------------------------
		// 1. Setup the UI (Text Display)
		// ------------------------------------------------
		hxd.Res.initLocal();
		Gemma.load();
		var font = hxd.res.DefaultFont.get();

		outputText = new h2d.Text(font, s2d);
		outputText.text = "Initializing System...\n";
		outputText.scale(2); // Make text bigger
		outputText.textColor = 0xFFFFFF;

		// NameGenerator.generateNameFile();
		NameGenerator.Init();
		AppearanceGenerator.Init();
		RegionGenerator.Init();
		SettlementGenerator.Init();
		WorldGenerator.Init();
		trace("cool");
		var w = new game.objects.World();
		w.Generate();
		trace(Json.stringify(w));
	}

	override function update(dt:Float) {
		Gemma.update(s2d);
	}

	static function main() {
		new Main();
	}
}
