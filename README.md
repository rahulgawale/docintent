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

No magic. No hidden scope.

---

## What DocIntent is (and is not)

**DocIntent is:**

- a low-level Apex library
- suitable for developers and system-generated documents
- designed to be composed and reused

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
Blob pdf = doc.buildPdf();

ContentVersion cv = new ContentVersion();
cv.Title = 'Invoice';
cv.PathOnClient = 'Invoice.pdf';
cv.VersionData = pdf;
cv.IsMajorVersion = true;

insert cv;
```

## License

Licensed under the Apache License, Version 2.0.
