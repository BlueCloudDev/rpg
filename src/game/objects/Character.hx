package game.objects;

import util.PromptHelper;
import generation.PersonalityGenerator;
import generation.ApperanceGenerator.AppearanceTypes;
import generation.ApperanceGenerator.AppearanceGenerator;
import generation.NameGenerator;
import util.Uuid;
import util.Random;
import game.enums.*;

class Character {
	public var ID:String;
	public var Name:String;
	public var Appearance:CharacterAppearance;
	public var Personality:PersonalityProfile;
	public var Relationships:Map<Int, Relationship>;
	public var Age:Int;
	public var Species:String;
	public var Ethnicity:String;
	public var Mood:Int;
	public var Energy:Int;

	public function new() {}

	public function Generate() {
		this.ID = Uuid.create();
		this.Name = NameGenerator.GetRandom();
		this.Appearance = new CharacterAppearance();
		this.Appearance.Generate();
		this.Personality = new PersonalityProfile();
		this.Personality.Generate();
		this.Relationships = new Map<Int, Relationship>();
		this.Age = RandomNumbers.intRange(18, 70);
		this.Species = AppearanceGenerator.GetRandom(AppearanceTypes.Species);
		this.Ethnicity = AppearanceGenerator.GetRandom(AppearanceTypes.Ethnicity);
		this.Energy = 50;
		this.Mood = 5;
	}

	public function GetPrompt() {
		var b = new StringBuf();

		// 1. Core Identity - Clear, factual headers
		b.add("### CHARACTER CORE IDENTITY\n");
		b.add("Name: " + Name + "\n");
		b.add("Demographics: " + Age + " year old " + Ethnicity + " " + Species + "\n");

		// 2. Status - Convert numbers to words (Anchoring)
		b.add("### CHARACTER CURRENT STATUS\n");

		var moodLabel = PromptHelper.GetRelativeDescription(Mood, 6, 3, "Happy/Excited", "Neutral/Calm");
		b.add("Mood: " + Mood + "/10 (" + moodLabel + ")\n");

		// Logic for Semantic Energy Label
		var energyLabel = PromptHelper.GetRelativeDescription(Energy, 70, 30, "Energized", "Exhausted");
		b.add("Energy: " + Energy + "/100 (" + energyLabel + ")\n");

		return b.toString();
	}

	public function GetFullPrompt() {
		var b = new StringBuf();
		b.add(GetPrompt());
		b.add(Appearance.GetPrompt());
		b.add(Personality.GetPrompt());
		return b.toString();
	}
}

class CharacterAppearance {
	public var HairColor:String;
	public var HairStyle:String;
	public var EyeColor:String;
	public var EyeShape:String;
	public var Height:Int;
	public var Weight:Int;
	public var SkinTone:String;
	public var FacialHair:String;
	public var BodyBuild:String;
	public var Scars:Map<BodyLocation, Scar>;
	public var Tattoos:Map<BodyLocation, Tattoo>;
	public var Anomalies:List<String>;
	public var Grooming:Int;
	public var VoicePitch:String;

	public function new() {}

	public function Generate() {
		HairColor = AppearanceGenerator.GetRandom(AppearanceTypes.HairColor);
		HairStyle = AppearanceGenerator.GetRandom(AppearanceTypes.HairStyles);
		EyeColor = AppearanceGenerator.GetRandom(AppearanceTypes.EyeColors);
		EyeShape = AppearanceGenerator.GetRandom(AppearanceTypes.EyeShapes);
		// Random height based on a minimum of 150cm
		Height = Std.int(hxd.Math.random(200 - 150)) + 150;
		// Random weight base on a minimum of 50kg
		Weight = Std.int(hxd.Math.random(110 - 50)) + 50;
		SkinTone = AppearanceGenerator.GetRandom(AppearanceTypes.SkinTones);
		// FacialHair = AppearanceGenerator.getRandom(AppearanceTypes.FacialHair);
		BodyBuild = AppearanceGenerator.GetRandom(AppearanceTypes.BodyBuilds);
	}

	public function GetPrompt() {
		var b = new StringBuf();

		b.add("### CHARACTER PHYSICAL DESCRIPTION\n");

		// Hair & Face - switched to double quotes to be extra safe
		b.add("Hair: " + HairColor + ", " + HairStyle + " style\n");
		b.add("Eyes: " + EyeColor + ", " + EyeShape + " shape\n");
		b.add("Skin tone: " + SkinTone + "\n");

		// Body Stats
		var hDesc = PromptHelper.GetRelativeDescription(Height, 185, 165, "Tall", "Short");
		b.add("Height: " + Height + " cm (" + hDesc + ")\n");

		var wDesc = PromptHelper.GetRelativeDescription(Weight, 90, 60, "Heavy", "Lean");
		b.add("Weight: " + Weight + " kg (" + wDesc + ")\n");

		b.add("Build: " + BodyBuild + "\n");

		return b.toString();
	}

	// public function getPrompt() {
	//   var prompt = "###CHARACTER APPEARANCE\n"
	//     + HairColor + " hair color "
	//     + " with a " + HairStyle + "style.\n"
	//     + EyeColor + " " + EyeShape + " shaped eyes.\n"
	//     + "Standing " + Height + " centimeters tall\n"
	//     + "Weighing " + Weight + " kilograms\n"
	//     + "Body build type is " + BodyBuild + "\n"
	//     + "Skin toe is " + SkinTone +"\n";
	//   return prompt;
	// }
}

class PersonalityProfile {
	public var Openness:Int;
	public var Conscientiousness:Int;
	public var Extraversion:Int;
	public var Agreeableness:Int;
	public var Neuroticism:Int;

	public function new() {}

	public function getSum() {
		return Openness + Conscientiousness + Extraversion + Agreeableness + Neuroticism;
	}

	public function Generate() {
		var p = PersonalityGenerator.GenerateBalanced();
		this.Openness = p.Openness;
		this.Conscientiousness = p.Conscientiousness;
		this.Extraversion = p.Extraversion;
		this.Agreeableness = p.Agreeableness;
		this.Neuroticism = p.Neuroticism;
	}

	public function GetPrompt() {
		var b = new StringBuf();

		// Helper function to map 1-10 values to descriptive adjectives
		// Adjust thresholds (7 and 3) if your scale is different (e.g., 1-100)
		var getTrait = function(val:Int, highStr:String, lowStr:String):String {
			if (val >= 7)
				return highStr;
			if (val <= 3)
				return lowStr;
			return "Balanced";
		};

		b.add("### CHARACTER PERSONALITY TRAITS (Big Five)\n");

		// 1. Openness (Curiosity vs Caution)
		var openDesc = getTrait(Openness, "Curious/Inventive", "Traditional/Cautious");
		b.add("Openness: " + Openness + "/10 (" + openDesc + ")\n");

		// 2. Conscientiousness (Discipline vs Spontaneity)
		var consDesc = getTrait(Conscientiousness, "Organized/Reliable", "Spontaneous/Disorganized");
		b.add("Conscientiousness: " + Conscientiousness + "/10 (" + consDesc + ")\n");

		// 3. Extraversion (Social vs Solitary)
		var extraDesc = getTrait(Extraversion, "Outgoing/Energetic", "Introverted/Reserved");
		b.add("Extraversion: " + Extraversion + "/10 (" + extraDesc + ")\n");

		// 4. Agreeableness (Cooperation vs Competition)
		var agreeDesc = getTrait(Agreeableness, "Compassionate/Friendly", "Competitive/Critical");
		b.add("Agreeableness: " + Agreeableness + "/10 (" + agreeDesc + ")\n");

		// 5. Neuroticism (Sensitivity vs Stability)
		var neuroDesc = getTrait(Neuroticism, "Anxious/Sensitive", "Calm/Confident");
		b.add("Neuroticism: " + Neuroticism + "/10 (" + neuroDesc + ")\n");

		return b.toString();
	}
}

class Relationship {
	public var TargetCharacterID:Int;
	public var Affinity:Int;
	public var Trust:Int;

	// var History: List<>; Not implemented yet, needs more thought
	public function new() {}
}

// Needs more work
class Goal {
	public var Description:String;
	public var Importance:Int;
	public var IsCompleted:Bool;

	public function new() {}
}

class BodyMarking {
	public var ID:String;
	public var Location:BodyLocation;
	public var Visibility:VisibilityLevel;

	public function new() {}

	// Calculated property based on current clothing
	// func IsVisible(currentClothing: Outfit) -> Bool {
	// Logic to check if clothing covers this location
	// }
}

class Scar extends BodyMarking {
	// --- VISUALS ---
	var Shape:String; // e.g., "Jagged", "Straight line", "Star-shaped"
	var TissueType:String; // e.g., "Keloid (raised)", "Atrophic (sunken)", "Burn"
	var Color:String; // e.g., "Angry red", "Pale white", "Purple"
	var Length:Int; // in mm

	// --- NARRATIVE HISTORY ---
	var Cause:String; // e.g., "Sword slash", "Chemical burn", "Dragon claw"
	var OriginStory:String; // The text to display when asked: "I got this at the Battle of Yon..."
	var AgeInYears:Int; // How old is the wound?

	// --- GAMEPLAY/MECHANICS ---
	var IsFresh:Bool; // If true, might reopen/bleed during combat
	var PainLevel:Int; // 0-10. Does it ache when it rains?
	var PhysicalImpairment:String; // Optional: e.g., "Reduced range of motion", "Blindness"

	// --- PSYCHOLOGY ---
	var AssociatedTrauma:Float; // 0.0 to 1.0. How much does this scar upset the character?
}

class Tattoo extends BodyMarking {
	// --- VISUALS ---
	var Description:String; // e.g., "A serpent eating its own tail"
	var InkColor:String; // e.g., "Faded blue", "Vibrant red and black"
	var Style:String; // e.g., "Tribal", "Prison-poke", "Hyper-realistic", "Runes"
	var Quality:Int; // 1 (Amateur/Blurry) to 10 (Masterpiece)

	// --- MEANING ---
	var Meaning:String; // e.g., "Symbol of the Thieves Guild", "Mother's name"
	var EmotionalAttachment:Int;

	// --- SOCIAL SIGNALING ---
	// Critical for faction logic
	var FactionAllegiance:String; // e.g., "SerpentGang". Unaffiliated = null.
	var IntimidationFactor:Int; // e.g., A teardrop tattoo has high intimidation.

	// --- FANTASY ELEMENTS (Optional) ---
	var IsMagical:Bool;
	var MagicEffect:String; // e.g., "Glows when Orcs are near"
}
