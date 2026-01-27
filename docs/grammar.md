# DocIntent DSL Grammar

This document defines the DocIntent document structure language and provides usage examples.

---

## Grammar

```
Document      ::= DocIntentDocument.create()
                  [ .withBaseStyles(DocIntentBaseStyles) ]
                  Section+

Section       ::= .section()
                | .section(DocIntentStyle)
                  Content*
                  .endSection()

Content       ::= Heading
                | Paragraph
                | Table
                | Text

Heading       ::= .heading(String)
                | .heading(String, DocIntentHeadingLevel)
                | .heading(String, DocIntentHeadingLevel, DocIntentStyle)

Paragraph     ::= .paragraph(String)
                | .paragraph(String, DocIntentStyle)

Text          ::= .text(String)
                | .text(String, DocIntentStyle)

Table         ::= .table()
                  Row+

Row           ::= .row()
                  Cell+

Cell          ::= .cell(String)
                | .cell(String, DocIntentStyle)

Render        ::= .toPdf()   // returns Blob
                | .toHtml()  // returns String

Style         ::= new DocIntentStyle()
                  [ .set(String key, String value) ]
                  [ .color(String) ]
                  [ .backgroundColor(String) ]
                  [ .fontSize(String) ]
                  [ .fontFamily(String) ]
                  [ .bold() ]
                  [ .italic() ]
                  [ .underline() ]
                  [ .strike() ]
                  [ .border(String) ]
                  [ .borderTop(String) ]
                  [ .borderBottom(String) ]
                  [ .padding(String) ]
                  [ .margin(String) ]
                  [ .width(String) ]
                  [ .height(String) ]
                  [ .textAlign(String) ]
                  [ .spacing(DocIntentSpacing) ]
                  [ ... ]

                  Note: All style setters are order-independent.
                  Later calls overwrite earlier values for the same property.

                  IMPORTANT: Spacing always takes precedence over style properties.
                  If both .set('padding-left', '12px') and .spacing(...paddingX('20px'))
                  are used, the spacing value wins regardless of call order.

Spacing       ::= new DocIntentSpacing()
                  [ .margin(String) ]
                  [ .marginTop(String) ]
                  [ .marginBottom(String) ]
                  [ .marginLeft(String) ]
                  [ .marginRight(String) ]
                  [ .marginX(String) ]
                  [ .marginY(String) ]
                  [ .padding(String) ]
                  [ .paddingTop(String) ]
                  [ .paddingBottom(String) ]
                  [ .paddingLeft(String) ]
                  [ .paddingRight(String) ]
                  [ .paddingX(String) ]
                  [ .paddingY(String) ]

                  Note: All spacing setters are order-independent.
                  Later calls overwrite earlier values for the same property.

                  Spacing properties always override equivalent style properties
                  (e.g., .paddingX() overrides .set('padding-left', ...)).
                  This ensures consistent layout control.
```

---

## API Methods

### Document Creation

```apex
DocIntentDocument doc = DocIntentDocument.create();
```

### Custom Base Styles

```apex
doc.withBaseStyles(new MyCustomBaseStyles());
```

### Sections

```apex
// Basic section
doc.section()
  .heading('Title')
  .paragraph('Content')
  .endSection();

// Section with inline style
doc.section(new DocIntentStyle().backgroundColor('#F5F5F5'))
  .heading('Styled Section')
  .endSection();
```

### Headings

```apex
// Default heading (H1)
doc.heading('Title');

// Specific level
doc.heading('Subtitle', DocIntentHeadingLevel.H2);

// With inline style
doc.heading(
  'Styled Heading',
  DocIntentHeadingLevel.H1,
  new DocIntentStyle().color('#0176D3').fontSize('32px')
);
```

### Paragraphs

```apex
// Basic paragraph
doc.paragraph('This is a paragraph.');

// With inline style
doc.paragraph(
  'Styled paragraph',
  new DocIntentStyle().fontSize('14px').italic()
);
```

### Text

```apex
// Basic text span
doc.text('Plain text');

// With inline style
doc.text(
  'Styled text',
  new DocIntentStyle().color('#FF0000').bold()
);
```

**Note:** `text()` produces a `<span>` element. Use `paragraph()` for block-level text with margins.

### Tables

```apex
doc.section()
  .table()
    .row()
      .cell('Header 1')
      .cell('Header 2')
    .row()
      .cell('Data 1')
      .cell('Data 2')
  .endSection();
```

### Inline Styles

```apex
DocIntentStyle style = new DocIntentStyle()
  .fontSize('16px')
  .color('#333333')
  .backgroundColor('#F0F0F0')
  .padding('12px')
  .border('1px solid #CCCCCC')
  .bold();

doc.heading('Styled Heading', DocIntentHeadingLevel.H2, style);
```

### Spacing

```apex
// Create spacing
DocIntentSpacing spacing = new DocIntentSpacing()
  .marginBottom('16px')
  .paddingX('12px');

// Apply to style
DocIntentStyle style = new DocIntentStyle()
  .fontSize('14px')
  .spacing(spacing);
```

### Font Scale Helpers

```apex
// Predefined sizes (1-12)
DocIntentStyle size6 = DocIntentFontScale.size(6);  // 16px

// Named aliases
DocIntentStyle xs = DocIntentFontScale.xs();  // 11px (size 2)
DocIntentStyle sm = DocIntentFontScale.sm();  // 13px (size 4)
DocIntentStyle md = DocIntentFontScale.md();  // 16px (size 6)
DocIntentStyle lg = DocIntentFontScale.lg();  // 20px (size 8)
DocIntentStyle xl = DocIntentFontScale.xl();  // 24px (size 10)
```

### Spacing Scale Helpers

```apex
// Padding helpers (multiples of 4px)
DocIntentSpacing p4 = DocIntentSpacingScale.p(4);   // padding: 16px
DocIntentSpacing px3 = DocIntentSpacingScale.px(3); // padding-x: 12px
DocIntentSpacing py2 = DocIntentSpacingScale.py(2); // padding-y: 8px

// Margin helpers (multiples of 4px)
DocIntentSpacing m6 = DocIntentSpacingScale.m(6);   // margin: 24px
DocIntentSpacing mx4 = DocIntentSpacingScale.mx(4); // margin-x: 16px
DocIntentSpacing my3 = DocIntentSpacingScale.my(3); // margin-y: 12px
```

---

## Complete Examples

### Simple Invoice

```apex
DocIntentDocument doc = DocIntentDocument.create();

doc.section()
  .heading('Invoice #12345', DocIntentHeadingLevel.H1)
  .paragraph('Date: January 26, 2026')
  .endSection();

doc.section()
  .heading('Items', DocIntentHeadingLevel.H2)
  .table()
    .row()
      .cell('Item')
      .cell('Price')
    .row()
      .cell('Product A')
      .cell('$100')
  .endSection();

Blob pdf = doc.toPdf();
```

### Styled Account Report

Complete example showing document-level base styles with CSS inheritance:

```apex
// Define custom base styles for this document
public class AccountReportStyles implements DocIntentBaseStyles {
  private String border = '1px solid #909090';

  public Map<String, DocIntentStyle> styles() {
    Map<String, DocIntentStyle> m = new Map<String, DocIntentStyle>();

    // Document base - applied to <body>, inherited by all children
    m.put('document.base', new DocIntentStyle()
      .fontFamily('sans-serif')
      .fontSize('12px')
      .color('#000000')
    );

    m.put('heading.H1', new DocIntentStyle()
      .fontSize('30px')
      .set('letter-spacing', '1px')
      .set('margin', '0')
      .color('#FFFFFF')
    );

    m.put('table.base', new DocIntentStyle()
      .backgroundColor('#FFFFFF')
      .border(border)
      .width('100%')
    );

    m.put('cell.base', new DocIntentStyle()
      .padding('12px')
      .border(border)
    );

    return m;
  }
}

DocIntentDocument doc = DocIntentDocument.create()
  .withBaseStyles(new AccountReportStyles());

// Header section with blue background
doc.section(
  new DocIntentStyle()
    .backgroundColor('#0176D3')
    .spacing(DocIntentSpacingScale.p(6))
)
  .heading(
    'DocIntent PDF Generation',
    DocIntentHeadingLevel.H1,
    new DocIntentStyle()
      .fontSize('30px')
      .set('letter-spacing', '1px')
      .set('margin', '0')
      .color('#FFFFFF')
  )
  .paragraph(
    'DocIntent is a PDF generation DSL...',
    new DocIntentStyle().color('#FFFFFF')  // Inherits sans-serif font
  )
  .endSection();

// Data table
String border = '1px solid #909090';
DocIntentStyle labelStyle = new DocIntentStyle()
  .padding('12px')
  .border(border)
  .bold();  // Inherits font-family and font-size from document.base

doc.section()
  .table()
    .row()
      .cell('Account Name', labelStyle)
      .cell(acc.Name)
  .endSection();

// Footer - uses document.base styles (no inline style needed)
doc.section()
  .paragraph('PDF generated using DocIntent')
  .endSection();

Blob pdf = doc.toPdf();
```

### Custom Base Styles (Primary Extensibility Pattern)

**This is the correct way to customize styles in DocIntent.**

Base styles are resolved at document creation through the `DocIntentBaseStyles` interface. This preserves immutability and explicit structure.

```apex
public class MyBaseStyles implements DocIntentBaseStyles {
  public Map<String, DocIntentStyle> styles() {
    Map<String, DocIntentStyle> m = new Map<String, DocIntentStyle>();

    // Document-level base styles (emitted as inline style on <body>)
    m.put('document.base', new DocIntentStyle()
      .fontFamily('Inter, Arial, sans-serif')
      .fontSize('12px')
      .color('#111111')
      .set('line-height', '1.5')
      .set('margin', '0')
      .set('padding', '0')
    );

    m.put('heading.H1', new DocIntentStyle()
      .fontSize('32px')
      .bold()
      .color('#0176D3')
    );

    m.put('heading.H2', new DocIntentStyle()
      .fontSize('24px')
      .bold()
      .color('#0176D3')
    );

    m.put('table.base', new DocIntentStyle()
      .border('1px solid #CCCCCC')
      .width('100%')
    );

    return m;
  }
}

// Use the custom base styles
DocIntentDocument doc = DocIntentDocument.create()
  .withBaseStyles(new MyBaseStyles());
```

**Key architectural points:**

- **One document style per document** — `document.base` is emitted once on `<body>`
- **CSS cascade handles inheritance** — child elements inherit typography unless overridden
- **Inline styles only override what they specify** — bold/color/size override, font-family inherits
- **No runtime merging** — styles are static, rendering is deterministic
- **Configuration before rendering** — base styles set via `withBaseStyles()` before document structure

**How `document.base` works:**

- Emitted once as `<body style="...">` inline attribute
- Defines global typography that cascades to all child elements
- Elements inherit unless they override with inline styles
- Avoids repeating font-family/font-size on every element
- Standard CSS cascade — no runtime magic

**Override pattern:**

```apex
// Document has base font: Inter, 12px
// This paragraph inherits font but overrides color
doc.paragraph(
  'Red text with base font',
  new DocIntentStyle().color('#FF0000')
);
```

---

## Stack Validation

DocIntent enforces document structure using a stack-based validator:

**Valid:**

```apex
doc.section()      // PUSH SECTION
  .table()         // PUSH TABLE
    .row()         // PUSH ROW
      .cell('X')   // Valid: cell inside row
  .endSection();   // POP until SECTION
```

**Invalid:**

```apex
doc.table()        // Error: table outside section
```

**Invalid:**

```apex
doc.section()
  .row()           // Error: row outside table
```

The stack ensures:

- Sections are properly opened and closed
- Tables are inside sections
- Rows are inside tables
- Cells are inside rows
- Document structure is deterministic

---

## Style Keys (Internal Resolution)

Style keys are used internally by DocIntent to resolve base styles from your `DocIntentBaseStyles` provider. **These are not public registry keys** — they define what the rendering engine looks for when applying default styles.

### Document-Level Styles

- `document.base` — Global document styles emitted as inline style on `<body>` tag
  - Defines typography defaults (font-family, font-size, line-height, color)
  - Applies margin/padding reset
  - Creates CSS cascade gravity — all child elements inherit unless explicitly overridden
  - **Emitted once per document** as inline style attribute

### Base Styles

- `section.base` — Applied to section containers (`<div>`)
- `paragraph.base` — Spacing for paragraphs (spacing, not style)
- `table.base` — Applied to tables
- `cell.base` — Applied to table cells

### Heading Styles

- `heading.H1` through `heading.H6` — Applied to respective heading levels

### Custom Styles

You can define any key you want in your `DocIntentBaseStyles` implementation:

```apex
public class MyBaseStyles implements DocIntentBaseStyles {
  public Map<String, DocIntentStyle> styles() {
    Map<String, DocIntentStyle> m = new Map<String, DocIntentStyle>();

    // Standard keys
    m.put('base.text', ...);
    m.put('heading.H1', ...);

    // Custom keys (not automatically used by engine)
    m.put('alert.warning',
      new DocIntentStyle().backgroundColor('#FFF3CD').color('#856404')
    );

    return m;
  }
}
```

**Important:** Custom keys like `'alert.warning'` are not automatically applied. They exist only if you explicitly reference them in custom renderers or future extensibility points. The engine only resolves the documented keys (`base.text`, `heading.H*`, `table.base`, etc.).

---

## Rendering

### PDF Output

```apex
Blob pdf = doc.toPdf();

// Save to ContentVersion
ContentVersion cv = new ContentVersion();
cv.Title = 'MyDocument';
cv.PathOnClient = 'MyDocument.pdf';
cv.VersionData = pdf;
insert cv;
```

### HTML Output

```apex
String html = doc.toHtml();
System.debug(html);
```

---

## Best Practices

1. **Always close sections** with `.endSection()`
2. **Use inline styles** for one-off customizations
3. **Register styles** for reusable patterns
4. **Use spacing helpers** (`DocIntentSpacingScale`) for consistency
5. **Test HTML first** before generating PDF
6. **Keep structure explicit** — no hidden state or magic
7. **Fail fast** — invalid structure throws immediately

---

## Limitations

### Blob.toPdf() CSS Support

Salesforce's `Blob.toPdf()` has limited CSS support. Requires **Spring '26 (API 66.0+)** for:

- Background colors
- Text colors
- Basic borders
- Modern CSS properties

Earlier releases may render only basic styles (fonts, sizes, borders).

### Not Supported

- JavaScript
- External stylesheets
- CSS classes (inline styles only)
- Flexbox / Grid layouts
- Advanced selectors or pseudo-elements

---

## Types Reference

This section documents implementation types used in the DSL. These are Apex-specific details, not core grammar concepts.

### DocIntentHeadingLevel

Enum values for heading levels:

```apex
DocIntentHeadingLevel.H1
DocIntentHeadingLevel.H2
DocIntentHeadingLevel.H3
DocIntentHeadingLevel.H4
DocIntentHeadingLevel.H5
DocIntentHeadingLevel.H6
```

### DocIntentBaseStyles

Interface for providing base styles:

```apex
public interface DocIntentBaseStyles {
  Map<String, DocIntentStyle> styles();
}
```

Implement this interface to customize default styles for your document.

---

## See Also

- [README.md](../README.md) — Project overview
- [CONTRIBUTING.md](../CONTRIBUTING.md) — Contribution guidelines
- [AGENTS.md](../AGENTS.md) — AI agent contribution rules
