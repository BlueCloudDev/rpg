package game;

import util.JsonPrint;
import game.services.Gemma;
import sys.thread.Deque;
import generation.NameGenerator;
import generation.ApperanceGenerator;
import generation.SettlementGenerator;
import generation.RegionGenerator;
import generation.WorldGenerator;
import game.scenes.MainMenu;

class Main extends hxd.App {
	var outputText:h2d.Text;

	var responseQueue:Deque<String> = new Deque<String>();

	override function init() {
		// ------------------------------------------------
		// 1. Setup the UI (Text Display)
		// ------------------------------------------------
		hxd.Res.initLocal();
		Gemma.load();

		NameGenerator.Init();
		AppearanceGenerator.Init();
		RegionGenerator.Init();
		SettlementGenerator.Init();
		WorldGenerator.Init();
		var w = new game.objects.World();
		w.Generate();

		var mainMenu = new MainMenu();
		this.setScene(mainMenu);
	}

	override function update(dt:Float) {
		Gemma.update(s2d);
	}

	static function main() {
		new Main();
	}
}
