public class DocIntentSpacingScale {
  private static String pxValue(Integer n) {
    if (n == null || n < 1)
      n = 1;
    if (n > 12)
      n = 12;
    Integer px = 4 * n;
    return String.valueOf(px) + 'px';
  }

  // ===== Padding =====

  public static DocIntentSpacing p(Integer n) {
    return new DocIntentSpacing().padding(pxValue(n));
  }

  public static DocIntentSpacing px(Integer n) {
    return new DocIntentSpacing().paddingX(pxValue(n));
  }

  public static DocIntentSpacing py(Integer n) {
    return new DocIntentSpacing().paddingY(pxValue(n));
  }

  public static DocIntentSpacing pt(Integer n) {
    return new DocIntentSpacing().paddingTop(pxValue(n));
  }

  public static DocIntentSpacing pb(Integer n) {
    return new DocIntentSpacing().paddingBottom(pxValue(n));
  }

  public static DocIntentSpacing pl(Integer n) {
    return new DocIntentSpacing().paddingLeft(pxValue(n));
  }

  public static DocIntentSpacing pr(Integer n) {
    return new DocIntentSpacing().paddingRight(pxValue(n));
  }

  // ===== Margin =====

  public static DocIntentSpacing m(Integer n) {
    return new DocIntentSpacing().margin(pxValue(n));
  }

  public static DocIntentSpacing mx(Integer n) {
    return new DocIntentSpacing().marginX(pxValue(n));
  }

  public static DocIntentSpacing my(Integer n) {
    return new DocIntentSpacing().marginY(pxValue(n));
  }

  public static DocIntentSpacing mt(Integer n) {
    return new DocIntentSpacing().marginTop(pxValue(n));
  }

  public static DocIntentSpacing mb(Integer n) {
    return new DocIntentSpacing().marginBottom(pxValue(n));
  }

  public static DocIntentSpacing ml(Integer n) {
    return new DocIntentSpacing().marginLeft(pxValue(n));
  }

  public static DocIntentSpacing mr(Integer n) {
    return new DocIntentSpacing().marginRight(pxValue(n));
  }
}
