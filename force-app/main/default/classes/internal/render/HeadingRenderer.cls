public class HeadingRenderer {
  public static void render(
    RenderState state,
    String value,
    DocIntentHeadingLevel level
  ) {
    String tag = toTag(level);

    state.add('<' + tag + '>');
    state.add(state.escape(value));
    state.add('</' + tag + '>');
  }

  private static String toTag(DocIntentHeadingLevel level) {
    switch on level {
      when H1 {
        return 'h1';
      }
      when H2 {
        return 'h2';
      }
      when H3 {
        return 'h3';
      }
      when H4 {
        return 'h4';
      }
      when H5 {
        return 'h5';
      }
      when H6 {
        return 'h6';
      }
    }
    // logically unreachable
    return 'h1';
  }
}
