# DocIntent

DocIntent is an open-source **document intent engine** for Salesforce.

It provides a structured, deterministic way to generate PDFs in Apex using Salesforce’s native `Blob.toPdf()` API, without relying on Visualforce, templates, or macro-based tools.

---

## Why DocIntent exists

Generating PDFs on Salesforce today usually means:

- Visualforce hacks
- HTML strings in Apex
- fragile template tools
- opaque macro languages

DocIntent takes a different approach.

It separates:

- **what** a document is (intent)
- from **how** it is rendered (PDF, later formats)

---

## Core principles

- Streaming rendering, not DOM building
- Explicit structure enforced by a stack
- Business logic lives in Apex
- Rendering is deterministic
- Inline styles only
- Fail fast on invalid document structure
- **Fluent DSL with immutable structure**
- **No mutation after construction**

No magic. No hidden scope.

---

## DSL and Immutability

**DocIntent enforces a strict fluent DSL with immutable structure.**

### Rules

1. **Method chaining is required** — All fluent methods return `this` or the builder instance
2. **No mutation after construction** — Documents cannot be modified after `toPdf()` or `toHtml()` is called
3. **Configuration before rendering** — Base styles are set via `withBaseStyles()` before any document structure is created
4. **Write-once structure** — Sections, tables, and content cannot be edited after being added
5. **Immediate validation** — Invalid structure throws immediately, no deferred errors

### What this means

```apex
// ✅ CORRECT: Configuration first, then build
DocIntentDocument doc = DocIntentDocument.create()
  .withBaseStyles(new MyStyles())
  .section()
    .heading('Title')
    .paragraph('Content')
  .endSection();

Blob pdf = doc.toPdf();
```

```apex
// ❌ FORBIDDEN: No mutation after construction
DocIntentDocument doc = DocIntentDocument.create();
doc.section().heading('Title').endSection();
doc.registerStyle('heading.H1', ...);  // Method doesn't exist
doc.toPdf();
```

**Style customization is done via `DocIntentBaseStyles` providers, not runtime registries.**

For complete DSL rules and contribution guidelines, see [CONTRIBUTING.md](CONTRIBUTING.md) and [AGENTS.md](AGENTS.md).

---

## What DocIntent is (and is not)

**DocIntent is:**

- a low-level Apex library
- suitable for developers and system-generated documents
- designed to be composed and reused

---

## Important: PDF Styling Requirements

**⚠️ Styling Limitation:** Full CSS styling support (colors, backgrounds, borders, etc.) in generated PDFs requires Salesforce **Spring '26 (API 66.0) or later**.

Orgs running releases before Spring '26 may experience:

- Missing background colors
- Missing text colors
- Limited border rendering
- Other CSS property omissions

**Note:** Even with Spring '26+, `Blob.toPdf()` does not have complete parity with HTML/CSS rendering. Some advanced styles (e.g., flexbox, grid layouts, complex selectors, certain pseudo-elements) may not render identically in PDF format. Always test your generated PDFs to verify styling appears as expected.

If you're on an older release, styles will appear correctly in the HTML output but may not render in the PDF. Consider upgrading to Spring '26+ for improved styling support.

---

## Invoice example

The repository includes a complete Apex example showing how to build a simple invoice using DocIntent. See the script at [scripts/apex/buildInvoice.apex](scripts/apex/buildInvoice.apex).

```apex
// Example of how to use DocIntent, execute this from Anonymous Apex

DocIntentDocument doc = DocIntentDocument.create();

// Invoice header
doc
  .section()
    .heading('Invoice', DocIntentHeadingLevel.H1)
    .heading('ACME Corp', DocIntentHeadingLevel.H3)
  .endSection();

// Items table
doc
  .section()
    .heading('Items', DocIntentHeadingLevel.H2)
    .table()
      .row()
        .cell('Item')
        .cell('Quantity')
        .cell('Price')
      .row()
        .cell('Product A')
        .cell('2')
        .cell('$40')
      .row()
        .cell('Product B')
        .cell('1')
        .cell('$20')
  .endSection();

// Total
doc
  .section()
    .heading('Total: $60', DocIntentHeadingLevel.H2)
  .endSection();

// Render PDF
Blob pdf = doc.toPdf();

ContentVersion cv = new ContentVersion();
cv.Title = 'Invoice';
cv.PathOnClient = 'Invoice.pdf';
cv.VersionData = pdf;
cv.IsMajorVersion = true;

insert cv;
```

## Documentation

For complete API grammar and examples, see [docs/grammar.md](docs/grammar.md).

## Document-Level Base Styles

DocIntent applies global document styles as an inline style attribute on `<body>`, providing CSS cascade to all child elements. This ensures consistent typography without repeating properties on every element.

### Default document styles

```apex
DocIntentDocument doc = DocIntentDocument.create();
// Uses default: sans-serif font, 12px, black text
```

### Override document styles

```apex
public class InvoiceStyles implements DocIntentBaseStyles {
  public Map<String, DocIntentStyle> styles() {
    Map<String, DocIntentStyle> m = new Map<String, DocIntentStyle>();

    // Global document base - applied as inline style on <body>
    m.put('document.base', new DocIntentStyle()
      .fontFamily('Inter, Arial, sans-serif')
      .fontSize('11px')
      .color('#111111')
      .set('line-height', '1.5')
    );

    m.put('heading.H1', new DocIntentStyle()
      .fontSize('24px')
      .bold()
    );

    return m;
  }
}

DocIntentDocument doc = DocIntentDocument.create()
  .withBaseStyles(new InvoiceStyles());
```

**How it works:**

- `document.base` → applied once as `<body style="...">` inline attribute
- All child elements inherit typography (font-family, font-size, color, line-height)
- Inline styles override specific properties while preserving inheritance
- Standard CSS cascade — deterministic, no runtime merging

## Overriding styles inline

You can override inherited or base styles for a single element by passing a `DocIntentStyle`:

```apex
DocIntentDocument doc = DocIntentDocument.create()
  .withBaseStyles(new InvoiceStyles());

doc.section()
  .heading(
    'Custom Title',
    DocIntentHeadingLevel.H1,
    new DocIntentStyle().fontSize('32px').color('#0176D3')
  )
  .paragraph(
    'This paragraph inherits Inter font from document.base',
    new DocIntentStyle().italic()  // Only overrides font-style
  )
  .endSection();
```

## License

Licensed under the Apache License, Version 2.0.
