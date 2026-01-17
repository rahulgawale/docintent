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
doc.section().heading('Total: $60', DocIntentHeadingLevel.H2).endSection();

// Render PDF
Blob pdf = doc.buildPdf();

ContentVersion cv = new ContentVersion();
cv.Title = 'Invoice';
cv.PathOnClient = 'Invoice.pdf';
cv.VersionData = pdf;
cv.IsMajorVersion = true;

insert cv;
