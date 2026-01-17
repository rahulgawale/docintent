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

**DocIntent is not:**
- a drag-and-drop UI
- an admin-facing tool
- a template or macro engine
- a replacement for document design tools

---

## Simple example

```apex
PdfDocument doc = PdfDocument.create()
    .section()
        .text('Invoice', Styles.heading())
        .table()
            .row()
                .cell('Item')
                .cell('Amount');

for (LineItem__c item : items) {
    doc.row()
        .cell(item.Name)
        .cell(item.Amount__c);
}

Blob pdf = doc.buildPdf();


## License

Licensed under the Apache License, Version 2.0.
