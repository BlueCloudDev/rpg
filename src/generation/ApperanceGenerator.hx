package generation;

enum AppearanceTypes {
	HairColor;
	HairStyles;
	EyeShapes;
	EyeColors;
	SkinTones;
	FacialHair;
	BodyBuilds;
	Ethnicity;
	Species;
}

class AppearanceGenerator {
	static var hairColors:Array<String>;
	static var hairStyles:Array<String>;
	static var eyeShapes:Array<String>;
	static var eyeColors:Array<String>;
	static var skinTones:Array<String>;
	static var facialHair:Array<String>;
	static var bodyBuilds:Array<String>;
	static var ethnicity:Array<String>;
	static var species:Array<String>;

	public static function Init() {
		var content = hxd.Res.character.hair_colors.entry.getText();
		hairColors = content.split("\n");
		content = hxd.Res.character.hair_styles.entry.getText();
		hairStyles = content.split("\n");
		content = hxd.Res.character.eye_colors.entry.getText();
		eyeColors = content.split("\n");
		content = hxd.Res.character.eye_shapes.entry.getText();
		eyeShapes = content.split("\n");
		content = hxd.Res.character.skin_tones.entry.getText();
		skinTones = content.split("\n");
		content = hxd.Res.character.facial_hair.entry.getText();
		facialHair = content.split("\n");
		content = hxd.Res.character.body_builds.entry.getText();
		bodyBuilds = content.split("\n");
		content = hxd.Res.character.ethnicity.entry.getText();
		ethnicity = content.split("\n");
		content = hxd.Res.character.species.entry.getText();
		species = content.split("\n");
	}

	public static function GetRandom(appearanceType:AppearanceTypes):String {
		switch (appearanceType) {
			case HairColor:
				return hairColors[Std.random(hairColors.length)];
			case HairStyles:
				return hairStyles[Std.random(hairStyles.length)];
			case EyeShapes:
				return eyeShapes[Std.random(eyeShapes.length)];
			case EyeColors:
				return eyeColors[Std.random(eyeColors.length)];
			case SkinTones:
				return skinTones[Std.random(skinTones.length)];
			case FacialHair:
				return facialHair[Std.random(facialHair.length)];
			case BodyBuilds:
				return bodyBuilds[Std.random(bodyBuilds.length)];
			case Ethnicity:
				return ethnicity[Std.random(ethnicity.length)];
			case Species:
				return species[Std.random(species.length)];
			default:
				trace("Error: Invalid appearance type");
		}
	}
}
