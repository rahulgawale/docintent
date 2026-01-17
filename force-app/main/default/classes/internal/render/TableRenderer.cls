public class TableRenderer {
  public static void openTable(RenderState state) {
    state.add('<table>');
    state.pushNode(DocIntentNodeType.TABLE);
  }

  public static void closeTable(RenderState state) {
    state.add('</table>');
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
    state.add('<td>');
    state.add(state.escape(value));
    state.add('</td>');
  }
}
