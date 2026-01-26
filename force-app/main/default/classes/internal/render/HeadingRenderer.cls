public class HeadingRenderer {
  public static void render(
    RenderState state,
    String value,
    DocIntentHeadingLevel level
  ) {
    String tag = toTag(level);

    DocIntentStyle baseStyle = null;
    try {
      baseStyle = state.resolveStyle('heading.' + level.name());
    } catch (Exception e) {
      // fallback to heading.H1 if not found
      baseStyle = state.resolveStyle('heading.H1');
    }

    DocIntentSpacing spacing = state.resolveSpacing('heading.' + level.name());

    DocIntentStyle merged = state.mergeStyleAndSpacing(baseStyle, spacing);

    state.addTag(tag, merged, state.escape(value));
  }

  public static void render(
    RenderState state,
    String value,
    DocIntentHeadingLevel level,
    DocIntentStyle style
  ) {
    String tag = toTag(level);
    DocIntentSpacing spacing = state.resolveSpacing('heading.' + level.name());
    DocIntentStyle merged = state.mergeStyleAndSpacing(style, spacing);
    state.addTag(tag, merged, state.escape(value));
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
