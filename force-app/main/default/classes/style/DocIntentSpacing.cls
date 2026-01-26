public class DocIntentSpacing {
  private Map<String, String> props = new Map<String, String>();

  public DocIntentSpacing() {
  }

  // Margins
  public DocIntentSpacing margin(String v) {
    props.put('margin', v);
    return this;
  }

  public DocIntentSpacing marginTop(String v) {
    props.put('margin-top', v);
    return this;
  }

  public DocIntentSpacing marginBottom(String v) {
    props.put('margin-bottom', v);
    return this;
  }

  public DocIntentSpacing marginLeft(String v) {
    props.put('margin-left', v);
    return this;
  }

  public DocIntentSpacing marginRight(String v) {
    props.put('margin-right', v);
    return this;
  }

  // Margin X-Y
  public DocIntentSpacing marginX(String v) {
    props.put('margin-left', v);
    props.put('margin-right', v);
    return this;
  }

  public DocIntentSpacing marginY(String v) {
    props.put('margin-top', v);
    props.put('margin-bottom', v);
    return this;
  }

  // Paddings
  public DocIntentSpacing padding(String v) {
    props.put('padding', v);
    return this;
  }

  public DocIntentSpacing paddingLeft(String v) {
    props.put('padding-left', v);
    return this;
  }

  public DocIntentSpacing paddingRight(String v) {
    props.put('padding-right', v);
    return this;
  }

  public DocIntentSpacing paddingTop(String v) {
    props.put('padding-top', v);
    return this;
  }

  public DocIntentSpacing paddingBottom(String v) {
    props.put('padding-bottom', v);
    return this;
  }

  // Padding X-Y
  public DocIntentSpacing paddingX(String v) {
    props.put('padding-left', v);
    props.put('padding-right', v);
    return this;
  }

  public DocIntentSpacing paddingY(String v) {
    props.put('padding-top', v);
    props.put('padding-bottom', v);
    return this;
  }

  public Map<String, String> properties() {
    return props;
  }
}
