public class RenderStack {
  private List<DocIntentNodeType> stack = new List<DocIntentNodeType>();

  public void push(DocIntentNodeType type) {
    stack.add(type);
  }

  public DocIntentNodeType peek() {
    return stack.isEmpty() ? null : stack[stack.size() - 1];
  }

  public DocIntentNodeType pop() {
    return stack.remove(stack.size() - 1);
  }
}
