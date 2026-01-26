public class DocIntentStyle {
  private Map<String, String> props = new Map<String, String>();
  private DocIntentSpacing spacingObj;

  public DocIntentStyle() {
  }

  // Spacing composition - replaces previous spacing
  public DocIntentStyle spacing(DocIntentSpacing s) {
    this.spacingObj = s;
    return this;
  }

  public DocIntentSpacing getSpacing() {
    return spacingObj;
  }

  public DocIntentStyle set(String key, String value) {
    props.put(key, value);
    return this;
  }

  public Map<String, String> properties() {
    return props;
  }

  public DocIntentStyle mergeWith(DocIntentStyle other) {
    DocIntentStyle merged = new DocIntentStyle();
    merged.props.putAll(this.props);
    if (other != null)
      merged.props.putAll(other.props);
    return merged;
  }

  // Allow callers to set any font-family name supported by the PDF renderer.
  public DocIntentStyle fontFamily(String v) {
    return set('font-family', v);
  }

  // Font-size helper
  public DocIntentStyle fontSize(String v) {
    return set('font-size', v);
  }

  // Raw color helpers
  public DocIntentStyle color(String v) {
    return set('color', v);
  }

  public DocIntentStyle backgroundColor(String v) {
    return set('background-color', v);
  }

  // Text style helpers
  public DocIntentStyle bold() {
    props.put('font-weight', 'bold');
    return this;
  }

  public DocIntentStyle italic() {
    props.put('font-style', 'italic');
    return this;
  }

  public DocIntentStyle underline() {
    props.put('text-decoration', 'underline');
    return this;
  }

  public DocIntentStyle strike() {
    props.put('text-decoration', 'line-through');
    return this;
  }

  // Text alignment (raw)
  public DocIntentStyle textAlign(String v) {
    return set('text-align', v);
  }

  // Border helpers
  public DocIntentStyle border(String v) {
    props.put('border', v);
    return this;
  }

  public DocIntentStyle borderTop(String v) {
    props.put('border-top', v);
    return this;
  }

  public DocIntentStyle borderBottom(String v) {
    props.put('border-bottom', v);
    return this;
  }

  public DocIntentStyle borderColor(String v) {
    props.put('border-color', v);
    return this;
  }

  public DocIntentStyle borderWidth(String v) {
    props.put('border-width', v);
    return this;
  }

  public DocIntentStyle borderStyle(String v) {
    props.put('border-style', v);
    return this;
  }

  // Border radius (single helper)
  public DocIntentStyle borderRadius(String v) {
    props.put('border-radius', v);
    return this;
  }

  // Vertical alignment (tables)
  public DocIntentStyle verticalAlign(String v) {
    return set('vertical-align', v);
  }

  // Margin left/right helpers
  public DocIntentStyle marginLeft(String v) {
    props.put('margin-left', v);
    return this;
  }

  public DocIntentStyle marginRight(String v) {
    props.put('margin-right', v);
    return this;
  }

  // Padding helper (shorthand)
  public DocIntentStyle padding(String v) {
    props.put('padding', v);
    return this;
  }

  // Width / height
  public DocIntentStyle width(String v) {
    return set('width', v);
  }

  public DocIntentStyle height(String v) {
    return set('height', v);
  }

  // White-space
  public DocIntentStyle whiteSpace(String v) {
    return set('white-space', v);
  }

  // Font weight (raw, numeric or keywords)
  public DocIntentStyle fontWeight(String v) {
    return set('font-weight', v);
  }

  // Line height
  public DocIntentStyle lineHeight(String v) {
    return set('line-height', v);
  }
}
