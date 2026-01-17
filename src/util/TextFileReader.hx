package util;

import sys.FileSystem;
import sys.io.File;
import haxe.io.Path;

class TextFileReader {
	static inline var RES_PATH = "res/";

	public static function ReadResFile(resPath:String):Array<String> {
		var fullPath = Path.join([RES_PATH, resPath]);
		return ReadLines(fullPath);
	}

	public static function ReadLines(relativePath:String):Array<String> {
		// Check if the file exists first to avoid errors
		if (FileSystem.exists(relativePath)) {
			// Read the entire content as a string
			var content = File.getContent(relativePath);

			// Split by newline to get an array of syllables
			var lines = content.split("\n");
			return lines;
		} else {
			trace("File not found!");
			return [];
		}
	}
}
