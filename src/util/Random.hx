package util;
class RandomNumbers {
    /**
     * Returns a random integer between min and max (inclusive).
     */
    public static function intRange(min:Int, max:Int):Int {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
}
