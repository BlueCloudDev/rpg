package game.services;

import game.objects.Character;
import h2d.TextInput;
import sys.thread.Deque;
import haxe.io.Bytes;

enum ThreadMsg {
	ModelLoaded;
	Response(text:String);
	Error(err:String);
}

class Gemma {
	static var messageQueue:Deque<ThreadMsg> = new Deque<ThreadMsg>();
	static var input:h2d.TextInput;
	static var outputText:h2d.Text;
	static var isModelLoaded:Bool = false;
	static var isThinking:Bool = false;

	@:hlNative("gemma", "init")
	static function _init(modelPath:hl.Bytes):Void {}

	@:hlNative("gemma", "query")
	static function _query(prompt:hl.Bytes):hl.Bytes {
		return null;
	}

	// ------------------------------------------------
	// Public Helper API (Use these in your game!)
	// ------------------------------------------------

	public static function load():Void {
		var relativePath = "res/model/gemma-3-1b.gguf";
		try {
			if (!sys.FileSystem.exists(relativePath)) {
				throw "File not found at: " + relativePath;
			}
			var absPath = sys.FileSystem.absolutePath(relativePath);

			trace("Found model at: " + absPath);
			trace("Loading LLM (this may freeze for a moment)...");

			// ------------------------------------------------
			// 3. Initialize Gemma (Native Bridge)
			// ------------------------------------------------
			// We pass the String 'absPath' directly because our updated Gemma.hx
			// handles the conversion to bytes internally.

			// Force a render so the user sees the "Loading" text
			sys.thread.Thread.create(function() {
				try {
					game.services.Gemma.init(absPath);
					trace("Added ModelLoaded to messageQueue");
					messageQueue.add(ModelLoaded);
				} catch (e:Dynamic) {
					trace("Error in Gemma Init thread");
					messageQueue.add(Error(Std.string(e)));
				}
			});
		} catch (e:Dynamic) {
			trace("ERROR: Could not load model.\n" + e);
		}
	}

	public static function update(scene:h2d.Scene):Void {
		// pop(false) means "don't wait, just return null if empty"
		var msg = messageQueue.pop(false);

		if (msg != null) {
			switch (msg) {
				case ModelLoaded:
					isModelLoaded = true;
					// Inside your init() or a setup function
					var font = hxd.res.DefaultFont.get(); // Get a basic font
					if (input == null) {
						input = new TextInput(font, scene);
					}
					input.backgroundColor = 0x80808080;
					//  input.inputWidth = 100;

					input.text = "Click to edit";
					input.textColor = 0xAAAAAA;

					input.scale(2);
					input.x = 300;
					input.y = 50;

					input.onFocus = function(_) {
						input.textColor = 0xFFFFFF;
					}
					input.onFocusLost = function(_) {
						input.textColor = 0xAAAAAA;
					}

				case Response(text):
					trace("Gemma: " + text);
					isThinking = false;
				case Error(err):
					trace("Error: " + err);
					isThinking = false;
			}
		}

		// Only allow input if the model is ready
		if (!isModelLoaded || isThinking)
			return;

		// Simple Input: Press Space to send a preset query
		if (hxd.Key.isPressed(hxd.Key.ENTER)) {
			var c = new Character();
			c.Generate();
			var prompt = c.GetFullPrompt();
			prompt = prompt + "### TASK\n" + input.text;
			Gemma.sendQuery(prompt);
		}
	}

	public static function init(modelPath:String):Void {
		// Convert Haxe String to raw UTF8 bytes for C++
		var bytes = Bytes.ofString(modelPath + String.fromCharCode(0));
		_init(bytes);
	}

	public static function sendQuery(prompt:String):Void {
		if (isThinking)
			return;
		isThinking = true;
		trace("\nUser: " + prompt);
		trace("Gemma is thinking...");
		// RUN IN THREAD: The Inference
		sys.thread.Thread.create(function() {
			// This blocks this background thread, but NOT the game window
			// We force a string copy ("" + val) to ensure the string
			// is safely owned by Haxe and not a lingering C pointer.
			var response = Gemma.ask(prompt);
			messageQueue.add(Response(prompt));
			messageQueue.add(Response("" + response));
		});
	}

	public static function ask(prompt:String):String {
		var safePrompt = prompt + String.fromCharCode(0);
		// 1. Convert Prompt to Bytes
		var inputBytes = Bytes.ofString(safePrompt);

		// 2. Call Native
		var resultBytes = _query(inputBytes);

		if (resultBytes == null)
			return "Error: Native returned null";

		// 3. Convert Result Bytes back to Haxe String
		// We use @:privateAccess to safely create a string from the C pointer
		return @:privateAccess String.fromUTF8(resultBytes);
	}
}
