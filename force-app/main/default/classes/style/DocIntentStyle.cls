public class DocIntentStyle {
  private Map<String, String> props = new Map<String, String>();
  private DocIntentSpacing spacingObj;

  public DocIntentStyle() {
  }

  // ===== Core API =====

  // Spacing composition - replaces previous spacing
  public DocIntentStyle spacing(DocIntentSpacing s) {
    this.spacingObj = s;
    return this;
  }

  public DocIntentSpacing getSpacing() {
    if (spacingObj == null) {
      return null;
    }
    return spacingObj.mergeWith(null);
  }

  public DocIntentStyle set(String key, String value) {
    props.put(key, value);
    return this;
  }

  public Map<String, String> properties() {
    return new Map<String, String>(props);
  }

  public DocIntentStyle mergeWith(DocIntentStyle other) {
    DocIntentStyle merged = new DocIntentStyle();
    // Merge strategy: start with this instance as the base, then override
    // with properties from 'other' if provided. This allows callers to
    // layer styles, with the argument taking precedence over the receiver.
    merged.props.putAll(this.props);
    merged.spacingObj = this.spacingObj;
    // If another style is provided, let its properties and spacing override.
    if (other != null) {
      merged.props.putAll(other.props);
      if (other.spacingObj != null) {
        merged.spacingObj = other.spacingObj;
      }
    }
    return merged;
  }

  // ===== Typography =====

  public DocIntentStyle fontFamily(String v) {
    return set('font-family', v);
  }

  public DocIntentStyle fontSize(String v) {
    return set('font-size', v);
  }

  public DocIntentStyle fontWeight(String v) {
    return set('font-weight', v);
  }

  public DocIntentStyle lineHeight(String v) {
    return set('line-height', v);
  }

  public DocIntentStyle textAlign(String v) {
    return set('text-align', v);
  }

  // ===== Text Decoration =====

  public DocIntentStyle bold() {
    props.put('font-weight', 'bold');
    return this;
  }

  public DocIntentStyle italic() {
    props.put('font-style', 'italic');
    return this;
  }

  public DocIntentStyle underline() {
    addTextDecoration('underline');
    return this;
  }

  public DocIntentStyle strike() {
    addTextDecoration('line-through');
    return this;
  }

  // Helper to combine multiple text-decoration values (e.g., "underline line-through").
  private void addTextDecoration(String decoration) {
    String existing = props.get('text-decoration');
    if (String.isBlank(existing)) {
      props.put('text-decoration', decoration);
      return;
    }
    // Avoid adding duplicate decorations.
    List<String> parts = existing.split('\\s+');
    Boolean alreadyPresent = false;
    for (String part : parts) {
      if (part.equals(decoration)) {
        alreadyPresent = true;
        break;
      }
    }
    if (!alreadyPresent) {
      props.put('text-decoration', existing + ' ' + decoration);
    }
  }

  // ===== Color =====

  public DocIntentStyle color(String v) {
    return set('color', v);
  }

  public DocIntentStyle backgroundColor(String v) {
    return set('background-color', v);
  }

  // ===== Spacing =====

  // Margin
  public DocIntentStyle margin(String v) {
    props.put('margin', v);
    return this;
  }

  public DocIntentStyle marginTop(String v) {
    props.put('margin-top', v);
    return this;
  }

  public DocIntentStyle marginBottom(String v) {
    props.put('margin-bottom', v);
    return this;
  }

  public DocIntentStyle marginLeft(String v) {
    props.put('margin-left', v);
    return this;
  }

  public DocIntentStyle marginRight(String v) {
    props.put('margin-right', v);
    return this;
  }

  // Padding
  public DocIntentStyle padding(String v) {
    props.put('padding', v);
    return this;
  }

  public DocIntentStyle paddingTop(String v) {
    props.put('padding-top', v);
    return this;
  }

  public DocIntentStyle paddingBottom(String v) {
    props.put('padding-bottom', v);
    return this;
  }

  public DocIntentStyle paddingLeft(String v) {
    props.put('padding-left', v);
    return this;
  }

  public DocIntentStyle paddingRight(String v) {
    props.put('padding-right', v);
    return this;
  }

  // ===== Border =====

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

  // ===== Layout =====

  public DocIntentStyle width(String v) {
    return set('width', v);
  }

  public DocIntentStyle height(String v) {
    return set('height', v);
  }

  public DocIntentStyle verticalAlign(String v) {
    return set('vertical-align', v);
  }

  public DocIntentStyle whiteSpace(String v) {
    return set('white-space', v);
  }
}
