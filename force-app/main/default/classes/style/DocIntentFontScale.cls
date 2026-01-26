public class DocIntentFontScale {
  private static String scaleToPx(Integer n) {
    if (n == null || n < 1)
      n = 1;
    if (n > 12)
      n = 12;

    List<Integer> sizeMap = new List<Integer>{
      10, // 1
      11, // 2
      12, // 3
      13, // 4
      14, // 5
      16, // 6
      18, // 7
      20, // 8
      22, // 9
      24, // 10
      26, // 11
      28 // 12
    };

    return String.valueOf(sizeMap[n - 1]) + 'px';
  }

  public static DocIntentStyle size(Integer n) {
    return new DocIntentStyle().fontSize(scaleToPx(n));
  }

  // Convenience aliases
  public static DocIntentStyle xs() {
    return size(2);
  }
  public static DocIntentStyle sm() {
    return size(4);
  }
  public static DocIntentStyle md() {
    return size(6);
  }
  public static DocIntentStyle lg() {
    return size(8);
  }
  public static DocIntentStyle xl() {
    return size(10);
  }
}
