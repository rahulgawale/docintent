public class RenderState {
  private List<String> chunks = new List<String>();
  private RenderStack stack = new RenderStack();

  public void add(String chunk) {
    chunks.add(chunk);
  }

  public void pushNode(DocIntentNodeType type) {
    stack.push(type);
  }

  public void popNode(DocIntentNodeType expected) {
    stack.pop(); // validation later
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
