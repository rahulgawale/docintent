public class DefaultBaseStyles implements DocIntentBaseStyles {
  public DefaultBaseStyles() {
  }

  public Map<String, DocIntentStyle> styles() {
    Map<String, DocIntentStyle> m = new Map<String, DocIntentStyle>();

    m.put(
      'base.text',
      new DocIntentStyle()
        .set('font-family', 'Helvetica')
        .set('font-size', '12px')
    );

    m.put(
      'heading.H1',
      new DocIntentStyle()
        .set('font-size', '20px')
        .set('font-weight', 'bold')
        .set('margin-bottom', '8px')
    );

    m.put(
      'heading.H2',
      new DocIntentStyle()
        .set('font-size', '18px')
        .set('font-weight', 'bold')
        .set('margin-bottom', '7px')
    );

    m.put(
      'heading.H3',
      new DocIntentStyle()
        .set('font-size', '16px')
        .set('font-weight', 'bold')
        .set('margin-bottom', '6px')
    );

    m.put(
      'heading.H4',
      new DocIntentStyle()
        .set('font-size', '14px')
        .set('font-weight', 'bold')
        .set('margin-bottom', '5px')
    );

    m.put(
      'heading.H5',
      new DocIntentStyle()
        .set('font-size', '12px')
        .set('font-weight', 'bold')
        .set('margin-bottom', '4px')
    );

    m.put(
      'heading.H6',
      new DocIntentStyle()
        .set('font-size', '11px')
        .set('font-weight', 'bold')
        .set('margin-bottom', '3px')
    );

    m.put(
      'table.base',
      new DocIntentStyle()
        .set('border-collapse', 'collapse')
        .set('width', '100%')
    );

    m.put('section.base', new DocIntentStyle());

    return m;
  }
}
