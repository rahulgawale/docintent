public class TableRenderer {
  public static void openTable(RenderState state) {
    DocIntentStyle baseStyle = null;
    try {
      baseStyle = state.resolveStyle('table.base');
    } catch (Exception e) {
      baseStyle = null;
    }

    DocIntentSpacing spacing = state.resolveSpacing('table.base');
    DocIntentStyle merged = state.mergeStyleAndSpacing(baseStyle, spacing);

    state.addOpenTag('table', merged);
    state.pushNode(DocIntentNodeType.TABLE);
  }

  public static void closeTable(RenderState state) {
    state.addCloseTag('table');
    state.popNode(DocIntentNodeType.TABLE);
  }

  public static void openRow(RenderState state) {
    state.add('<tr>');
    state.pushNode(DocIntentNodeType.ROW);
  }

  public static void closeRow(RenderState state) {
    state.add('</tr>');
    state.popNode(DocIntentNodeType.ROW);
  }

  public static void cell(RenderState state, String value) {
    DocIntentStyle baseStyle = null;
    try {
      baseStyle = state.resolveStyle('cell.base');
    } catch (Exception e) {
      baseStyle = null;
    }

    DocIntentSpacing spacing = state.resolveSpacing('cell.base');
    DocIntentStyle merged = state.mergeStyleAndSpacing(baseStyle, spacing);

    state.addTag('td', merged, state.escape(value));
  }

  public static void cell(
    RenderState state,
    String value,
    DocIntentStyle style
  ) {
    DocIntentSpacing spacing = state.resolveSpacing('cell.base');
    DocIntentStyle merged = state.mergeStyleAndSpacing(style, spacing);
    state.addTag('td', merged, state.escape(value));
  }
}
