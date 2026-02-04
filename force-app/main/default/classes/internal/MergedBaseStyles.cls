// Package-private merged provider: combine defaults and custom with last-write-wins
public class MergedBaseStyles implements DocIntentBaseStyles {
  private Map<String, DocIntentStyle> merged = new Map<String, DocIntentStyle>();

  public MergedBaseStyles(
    DocIntentBaseStyles defaults,
    DocIntentBaseStyles custom
  ) {
    if (defaults != null && defaults.styles() != null) {
      for (String k : defaults.styles().keySet()) {
        merged.put(k, defaults.styles().get(k));
      }
    }

    if (custom != null && custom.styles() != null) {
      for (String k : custom.styles().keySet()) {
        // override default with custom
        merged.put(k, custom.styles().get(k));
      }
    }
  }

  public Map<String, DocIntentStyle> styles() {
    return merged;
  }
}
