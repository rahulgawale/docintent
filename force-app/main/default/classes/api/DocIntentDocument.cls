public class DocIntentDocument {
  private RenderState state;
  private Boolean isBuilt = false;
  private String cachedHtml;
  private DocIntentBaseStyles baseStylesProvider;

  private DocIntentDocument() {
    // defer RenderState creation until first use so callers may supply
    // custom base styles via withBaseStyles(...)
    this.baseStylesProvider = null;
  }

  public static DocIntentDocument create() {
    return new DocIntentDocument();
  }

  // Allow callers to supply a base styles provider. Must be called before
  // any rendering operations (section/paragraph/heading/table...).
  public DocIntentDocument withBaseStyles(DocIntentBaseStyles styles) {
    this.baseStylesProvider = styles;
    return this;
  }

  // Lazily create RenderState using default + optional custom provider
  private void ensureState() {
    if (state != null)
      return;

    DocIntentBaseStyles resolved;
    if (this.baseStylesProvider == null) {
      resolved = new DefaultBaseStyles();
    } else {
      resolved = new MergedBaseStyles(
        new DefaultBaseStyles(),
        this.baseStylesProvider
      );
    }

    state = new RenderState(resolved);
    state.pushNode(DocIntentNodeType.DOCUMENT);
    state.add('<html>');
    state.add('<body>');
  }

  // ===== Public fluent API =====

  public DocIntentDocument section() {
    ensureState();

    DocIntentStyle baseStyle = null;
    try {
      baseStyle = state.resolveStyle('section.base');
    } catch (Exception e) {
      baseStyle = null;
    }

    DocIntentSpacing spacing = state.resolveSpacing('section.base');
    DocIntentStyle merged = state.mergeStyleAndSpacing(baseStyle, spacing);

    state.addOpenTag('div', merged);
    state.pushNode(DocIntentNodeType.SECTION);
    return this;
  }

  public DocIntentDocument section(DocIntentStyle style) {
    ensureState();

    DocIntentSpacing spacing = state.resolveSpacing('section.base');
    DocIntentStyle merged = state.mergeStyleAndSpacing(style, spacing);
    state.addOpenTag('div', merged);
    state.pushNode(DocIntentNodeType.SECTION);
    return this;
  }

  public DocIntentDocument endSection() {
    state.closeCurrentSection();
    return this;
  }

  public DocIntentDocument text(String value) {
    state.add('<span>');
    state.add(state.escape(value));
    state.add('</span>');
    return this;
  }

  public DocIntentDocument paragraph(String value) {
    ensureState();

    DocIntentStyle baseStyle = null;
    try {
      baseStyle = state.resolveStyle('base.text');
    } catch (Exception e) {
      baseStyle = null;
    }

    DocIntentSpacing spacing = state.resolveSpacing('paragraph.base');
    DocIntentStyle merged = state.mergeStyleAndSpacing(baseStyle, spacing);

    state.addTag('p', merged, state.escape(value));
    return this;
  }

  public DocIntentDocument paragraph(String value, DocIntentStyle style) {
    ensureState();

    DocIntentSpacing spacing = state.resolveSpacing('paragraph.base');
    DocIntentStyle merged = state.mergeStyleAndSpacing(style, spacing);
    state.addTag('p', merged, state.escape(value));
    return this;
  }

  public DocIntentDocument heading(String value, DocIntentHeadingLevel level) {
    ensureState();
    HeadingRenderer.render(state, value, level);
    return this;
  }

  public DocIntentDocument heading(String value) {
    return heading(value, DocIntentHeadingLevel.H1);
  }

  public DocIntentDocument heading(
    String value,
    DocIntentHeadingLevel level,
    DocIntentStyle style
  ) {
    ensureState();
    HeadingRenderer.render(state, value, level, style);
    return this;
  }

  public DocIntentDocument table() {
    ensureState();
    TableRenderer.openTable(state);
    return this;
  }

  public DocIntentDocument row() {
    ensureState();
    TableRenderer.openRow(state);
    return this;
  }

  public DocIntentDocument cell(String value) {
    ensureState();
    TableRenderer.cell(state, value);
    return this;
  }

  public DocIntentDocument cell(String value, DocIntentStyle style) {
    ensureState();
    TableRenderer.cell(state, value, style);
    return this;
  }

  // Expose style & spacing registration for callers
  public DocIntentDocument registerStyle(String name, DocIntentStyle style) {
    ensureState();
    state.registerStyle(name, style);
    return this;
  }

  public DocIntentDocument registerSpacing(
    String name,
    DocIntentSpacing spacing
  ) {
    ensureState();
    state.registerSpacing(name, spacing);
    return this;
  }

  // ===== Lifecycle =====

  private void ensureBuilt() {
    if (isBuilt)
      return; // idempotent
    ensureState();
    state.closeAllUntil(DocIntentNodeType.DOCUMENT);
    state.add('</body>');
    state.add('</html>');
    cachedHtml = state.buildHtml();
    isBuilt = true;
  }

  public Blob toPdf() {
    ensureBuilt();
    return Blob.toPdf(cachedHtml);
  }

  public String toHtml() {
    ensureBuilt();
    return cachedHtml;
  }
}
