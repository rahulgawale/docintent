public class DocIntentFontScale {
  private static String scaleToPx(Integer n) {
    if (n == null || n < 1)
      n = 1;
    if (n > 12)
      n = 12;

    List<Integer> sizeMap = new List<Integer>{
      10,
      11,
      12,
      13,
      14,
      16,
      18,
      20,
      22,
      24,
      26,
      28
    };

    return String.valueOf(sizeMap[n - 1]) + 'px';
  }

  // ===== Scale API =====

  public static DocIntentStyle size(Integer n) {
    return new DocIntentStyle().fontSize(scaleToPx(n));
  }

  // ===== Aliases =====

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
