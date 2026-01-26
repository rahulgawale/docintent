public class RenderState {
  private List<String> chunks = new List<String>();
  private RenderStack stack = new RenderStack();
  private Map<String, DocIntentStyle> styles = new Map<String, DocIntentStyle>();
  private Map<String, DocIntentSpacing> spacings = new Map<String, DocIntentSpacing>();

  // RenderState consumes a resolved base styles provider. It performs no
  // merging or defaulting; it simply imports the provided styles map.
  public RenderState(DocIntentBaseStyles baseStyles) {
    if (baseStyles != null && baseStyles.styles() != null) {
      for (String k : baseStyles.styles().keySet()) {
        styles.put(k, baseStyles.styles().get(k));
      }
    }

    // Default spacing for paragraph remains engine-owned for now
    registerSpacing(
      'paragraph.base',
      new DocIntentSpacing().marginBottom('8px')
    );
  }

  public void add(String chunk) {
    chunks.add(chunk);
  }

  // Style registry
  public void registerStyle(String name, DocIntentStyle style) {
    styles.put(name, style);
  }

  public DocIntentStyle resolveStyle(String name) {
    if (!styles.containsKey(name)) {
      throw new RenderException('Unknown style: ' + name);
    }
    return styles.get(name);
  }

  // Spacing registry
  public void registerSpacing(String name, DocIntentSpacing spacing) {
    spacings.put(name, spacing);
  }

  public DocIntentSpacing resolveSpacing(String name) {
    if (!spacings.containsKey(name)) {
      // return empty spacing rather than throw; spacing is optional
      return new DocIntentSpacing();
    }
    return spacings.get(name);
  }

  public void addOpenTag(String tag, DocIntentStyle style) {
    if (style != null) {
      add('<' + tag + ' style="' + serializeStyle(style) + '">');
      return;
    }
    add('<' + tag + '>');
  }

  public void addCloseTag(String tag) {
    add('</' + tag + '>');
  }

  public void addTag(String tag, DocIntentStyle style, String content) {
    add('<' + tag);

    if (style != null) {
      add(' style="' + serializeStyle(style) + '"');
    }

    add('>');
    add(content);
    add('</' + tag + '>');
  }

  public String serializeStyle(DocIntentStyle style) {
    List<String> parts = new List<String>();
    for (String key : style.properties().keySet()) {
      parts.add(key + ':' + style.properties().get(key));
    }
    return String.join(parts, ';');
  }

  public DocIntentStyle mergeStyleAndSpacing(
    DocIntentStyle style,
    DocIntentSpacing registeredSpacing
  ) {
    // Priority: style.spacing > registeredSpacing > none
    DocIntentSpacing finalSpacing = null;
    if (style != null && style.getSpacing() != null) {
      finalSpacing = style.getSpacing();
    } else if (registeredSpacing != null) {
      finalSpacing = registeredSpacing;
    }

    DocIntentStyle spacingAsStyle = new DocIntentStyle();
    if (finalSpacing != null) {
      for (String k : finalSpacing.properties().keySet()) {
        spacingAsStyle.set(k, finalSpacing.properties().get(k));
      }
    }

    if (style == null)
      return spacingAsStyle;
    return style.mergeWith(spacingAsStyle);
  }

  public void pushNode(DocIntentNodeType type) {
    stack.push(type);
  }

  public void popNode(DocIntentNodeType expected) {
    // TODO validation later
    stack.pop();
  }

  public String escape(String value) {
    if (value == null)
      return '';
    return value
      .replace('&', '&amp;')
      .replace('<', '&lt;')
      .replace('>', '&gt;');
  }

  private void close(DocIntentNodeType type) {
    switch on type {
      when SECTION {
        add('</div>');
      }
      when TABLE {
        add('</table>');
      }
      when ROW {
        add('</tr>');
      }
      when DOCUMENT {
        // should never be closed here
        throw new RenderException(
          'Attempted to close DOCUMENT node explicitly'
        );
      }
    }
  }

  public void closeAllUntil(DocIntentNodeType boundary) {
    while (true) {
      DocIntentNodeType current = stack.peek();

      if (current == null) {
        throw new RenderException(
          'Document stack underflow while closing nodes'
        );
      }

      if (current == boundary) {
        return;
      }

      close(stack.pop());
    }
  }

  public String buildHtml() {
    return String.join(chunks, '');
  }

  public void closeCurrentSection() {
    // First: unwind inner structures (table, row, etc.)
    while (true) {
      DocIntentNodeType current = stack.peek();

      if (current == null) {
        throw new RenderException('No open section to close');
      }

      if (current == DocIntentNodeType.SECTION) {
        stack.pop();
        add('</div>');
        return;
      }

      close(stack.pop());
    }
  }
}
