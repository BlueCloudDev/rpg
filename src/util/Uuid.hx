package util;
class Uuid {
    public static function create():String {
        var sb = new StringBuf();
        var chars = "0123456789ABCDEF";
        for (i in 0...36) {
            if (i == 8 || i == 13 || i == 18 || i == 23) {
                sb.add("-");
            } else if (i == 14) {
                sb.add("4"); // UUID version 4
            } else if (i == 19) {
                sb.add(chars.charAt((Std.random(4)) | 8)); // 8, 9, A, or B
            } else {
                sb.add(chars.charAt(Std.random(16)));
            }
        }
        return sb.toString();
    }
}
