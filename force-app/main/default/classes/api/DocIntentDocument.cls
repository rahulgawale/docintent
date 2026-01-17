public class DocIntentDocument {
  private RenderState state = new RenderState();

  private DocIntentDocument() {
    state.pushNode(DocIntentNodeType.DOCUMENT);
    state.add('<html>');
    state.add('<body>');
  }

  public static DocIntentDocument create() {
    return new DocIntentDocument();
  }

  // ===== Public fluent API =====

  public DocIntentDocument section() {
    state.add('<div>');
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

  public DocIntentDocument heading(String value, DocIntentHeadingLevel level) {
    HeadingRenderer.render(state, value, level);
    return this;
  }

  public DocIntentDocument heading(String value) {
    return heading(value, DocIntentHeadingLevel.H1);
  }

  public DocIntentDocument table() {
    TableRenderer.openTable(state);
    return this;
  }

  public DocIntentDocument row() {
    TableRenderer.openRow(state);
    return this;
  }

  public DocIntentDocument cell(String value) {
    TableRenderer.cell(state, value);
    return this;
  }

  // ===== Lifecycle =====

  public Blob buildPdf() {
    state.closeAllUntil(DocIntentNodeType.DOCUMENT);
    state.add('</body>');
    state.add('</html>');
    return Blob.toPdf(state.buildHtml());
  }

  public String buildHtml() {
    state.closeAllUntil(DocIntentNodeType.DOCUMENT);
    state.add('</body>');
    state.add('</html>');
    return state.buildHtml();
  }
}
