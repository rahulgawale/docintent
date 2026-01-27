public class RenderState {
  private List<String> chunks = new List<String>();
  private RenderStack stack = new RenderStack();
  private Map<String, DocIntentStyle> styles = new Map<String, DocIntentStyle>();
  private Map<String, DocIntentSpacing> spacings = new Map<String, DocIntentSpacing>();

  public RenderState(DocIntentBaseStyles baseStyles) {
    if (baseStyles != null && baseStyles.styles() != null) {
      for (String k : baseStyles.styles().keySet()) {
        styles.put(k, baseStyles.styles().get(k));
      }
    }

    registerSpacing(
      'paragraph.base',
      new DocIntentSpacing().marginBottom('8px')
    );
  }

  // ===== Buffer Management =====

  public void add(String chunk) {
    chunks.add(chunk);
  }

  public String buildHtml() {
    return String.join(chunks, '');
  }

  // ===== Style Registry =====

  public void registerStyle(String name, DocIntentStyle style) {
    styles.put(name, style);
  }

  public DocIntentStyle resolveStyle(String name) {
    if (!styles.containsKey(name)) {
      throw new RenderException('Unknown style: ' + name);
    }
    return styles.get(name);
  }

  public String getDocumentStyleString() {
    DocIntentStyle documentStyle = null;
    try {
      documentStyle = resolveStyle('document.base');
    } catch (Exception e) {
      return null;
    }
    return serializeStyle(documentStyle);
  }

  // ===== Spacing Registry =====

  public void registerSpacing(String name, DocIntentSpacing spacing) {
    spacings.put(name, spacing);
  }

  public DocIntentSpacing resolveSpacing(String name) {
    if (!spacings.containsKey(name)) {
      return new DocIntentSpacing();
    }
    return spacings.get(name);
  }

  // ===== Style Merging =====

  public DocIntentStyle mergeStyles(
    DocIntentStyle base,
    DocIntentStyle overridden
  ) {
    if (base == null) {
      return overridden;
    }
    if (overridden == null) {
      return base;
    }
    return base.mergeWith(overridden);
  }

  public DocIntentStyle mergeStyleAndSpacing(
    DocIntentStyle style,
    DocIntentSpacing registeredSpacing
  ) {
    DocIntentSpacing callerSpacing = (style != null)
      ? style.getSpacing()
      : null;
    DocIntentSpacing mergedSpacing = new DocIntentSpacing();

    if (registeredSpacing != null) {
      for (String k : registeredSpacing.properties().keySet()) {
        mergedSpacing.set(k, registeredSpacing.properties().get(k));
      }
    }

    if (callerSpacing != null) {
      for (String k : callerSpacing.properties().keySet()) {
        mergedSpacing.set(k, callerSpacing.properties().get(k));
      }
    }

    DocIntentStyle spacingAsStyle = new DocIntentStyle();
    for (String k : mergedSpacing.properties().keySet()) {
      spacingAsStyle.set(k, mergedSpacing.properties().get(k));
    }

    if (style == null)
      return spacingAsStyle;
    return style.mergeWith(spacingAsStyle);
  }

  // ===== HTML Generation =====

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
    if (style == null) {
      return '';
    }
    List<String> parts = new List<String>();
    for (String key : style.properties().keySet()) {
      parts.add(key + ':' + style.properties().get(key));
    }
    return String.join(parts, ';');
  }

  public String escape(String value) {
    if (value == null)
      return '';
    return value
      .replace('&', '&amp;')
      .replace('<', '&lt;')
      .replace('>', '&gt;');
  }

  // ===== Stack Management =====

  public void pushNode(DocIntentNodeType type) {
    stack.push(type);
  }

  public void popNode(DocIntentNodeType expected) {
    stack.pop();
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

  public void closeCurrentSection() {
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
