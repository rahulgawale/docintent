// PDF Fonts Test Page
// Tests all available fonts in Salesforce Blob.toPdf() rendering
// Reference: https://developer.salesforce.com/docs/atlas.en-us.pages.meta/pages/pages_output_pdf_supported_fonts.htm

DocIntentDocument doc = DocIntentDocument.create();

doc.section()
  .heading('PDF Fonts Test Page', DocIntentHeadingLevel.H1)
  .paragraph(
    'This text, which has no styles applied, is styled in the default font for the Visualforce PDF rendering engine.'
  )
  .paragraph(
    'The fonts available when rendering a page as a PDF are as follows. The first listed font-family value for each typeface is the recommended choice.'
  )
  .endSection();

// Fonts table
doc.section()
  .table()
  .row()
  .cell(
    'Font Name',
    new DocIntentStyle().bold().padding('6px').border('1px solid #000')
  )
  .cell(
    'Style font-family Value to Use (Synonyms)',
    new DocIntentStyle().bold().padding('6px').border('1px solid #000')
  )
  .row()
  .cell(
    'Arial Unicode MS',
    new DocIntentStyle()
      .fontFamily('Arial Unicode MS')
      .fontSize('14pt')
      .padding('6px')
      .border('1px solid #000')
  )
  .cell(
    'Arial Unicode MS',
    new DocIntentStyle()
      .fontFamily('Arial Unicode MS')
      .fontSize('14pt')
      .padding('6px')
      .border('1px solid #000')
  )
  .row()
  .cell(
    'Helvetica',
    new DocIntentStyle()
      .fontFamily('Helvetica')
      .fontSize('14pt')
      .padding('6px')
      .border('1px solid #000')
  )
  .cell(
    'sans-serif, SansSerif, Dialog',
    new DocIntentStyle().padding('6px').border('1px solid #000')
  )
  .row()
  .cell(
    'Times',
    new DocIntentStyle()
      .fontFamily('Times')
      .fontSize('14pt')
      .padding('6px')
      .border('1px solid #000')
  )
  .cell(
    'serif, Times',
    new DocIntentStyle().padding('6px').border('1px solid #000')
  )
  .row()
  .cell(
    'Courier',
    new DocIntentStyle()
      .fontFamily('Courier')
      .fontSize('14pt')
      .padding('6px')
      .border('1px solid #000')
  )
  .cell(
    'monospace, Courier, Monospaced, DialogInput',
    new DocIntentStyle().padding('6px').border('1px solid #000')
  )
  .endSection();

// Notes section
doc.section()
  .paragraph('Notes:', new DocIntentStyle().bold())
  .paragraph(
    '• These rules apply to server-side PDF rendering. You might see different results when viewing this page in a web browser.'
  )
  .paragraph(
    '• Text styled with any value besides those listed above receives the default font style, Times. This means that, ironically, while Helvetica\'s synonyms render as Helvetica, using "Helvetica" for the font-family style renders as Times. We recommend using "sans-serif".'
  )
  .paragraph(
    '• Arial Unicode MS is the only multibyte font available, providing support for the extended character sets of languages that don\'t use the Latin character set.'
  )
  .endSection();

// Render and save
Blob pdf = doc.toPdf();

ContentVersion cv = new ContentVersion();
cv.Title = 'PDF Fonts Test';
cv.PathOnClient = 'PDFFontsTest.pdf';
cv.VersionData = pdf;
cv.IsMajorVersion = true;

insert cv;

System.debug('PDF Fonts Test generated successfully');
