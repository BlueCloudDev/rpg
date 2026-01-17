package generation;

import game.objects.Character.PersonalityProfile;
import util.Random.RandomNumbers;

class PersonalityGenerator {
	public static function GenerateBalanced():PersonalityProfile {
		var p:PersonalityProfile = new PersonalityProfile();
		var isValid:Bool = false;

		// Define our "Balance" acceptable range.
		// Max total possible is 50 (5 * 10). Average is 25.
		// We reject characters with a sum < 15 (Too weak) or > 35 (Too perfect).
		var minTotal = 15;
		var maxTotal = 35;

		while (!isValid) {
			// 1. Generate random values (0 to 10 inclusive)
			// Std.random(11) returns 0 to 10.
			p.Openness = RandomNumbers.intRange(0, 10);
			p.Conscientiousness = RandomNumbers.intRange(0, 10);
			p.Extraversion = RandomNumbers.intRange(0, 10);
			p.Agreeableness = RandomNumbers.intRange(0, 10);
			p.Neuroticism = RandomNumbers.intRange(0, 10);

			// 2. Check Balance
			var totalScore = p.getSum();

			// 3. Optional: Prevent "Monotone" extremes.
			// (e.g. ensures we don't accidentally get [5,5,5,5,5])
			// This checks that at least one trait is distinct from the average.
			var hasVariance = (p.Openness != p.Conscientiousness);

			if (totalScore >= minTotal && totalScore <= maxTotal && hasVariance) {
				isValid = true;
			}
		}

		return p;
	}
}
