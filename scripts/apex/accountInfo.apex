// Anonymous Apex: build an Account info PDF using DocIntent
// Replace the Id below with a real Account Id in your org.
Id acctId = '001000000000000AAA';

Account acc = [
  SELECT Id, Name, Industry, Phone, Website
  FROM Account
  WHERE Id = :acctId
  LIMIT 1
];

DocIntentDocument doc = DocIntentDocument.create();

// register styles & spacings used for this document
doc.registerStyle(
  'heading.H1',
  new DocIntentStyle()
    .fontSize('30px')
    .set('letter-spacing', '1px')
    .set('margin', '0')
    .color('#FFFFFF')
);

doc.registerStyle(
  'section.base',
  new DocIntentStyle()
    .backgroundColor('#0176D3')
    .color('#FFFFFF')
    .spacing(DocIntentSpacingScale.p(6)) // 24px
);

doc.registerStyle(
  'table.base',
  new DocIntentStyle()
    .backgroundColor('#FFFFFF')
    .set('margin-top', '22px')
    .border('1px solid #D8DDE6')
    .borderRadius('8px')
    .width('92%')
    .marginLeft('auto')
    .marginRight('auto')
);

doc.registerStyle(
  'cell.base',
  new DocIntentStyle().padding('12px').borderBottom('1px solid #E5E5E5')
);

// Build header
doc.section();
doc.heading('SALESFORCE GEEK', DocIntentHeadingLevel.H1);
doc.paragraph('PDF generated using DocIntent');
doc.endSection();

// Reset base text
doc.registerStyle(
  'base.text',
  new DocIntentStyle().fontFamily('Helvetica').fontSize('12px').color('#000000')
);
doc.registerSpacing(
  'paragraph.base',
  new DocIntentSpacing().marginBottom('8px')
);

// Main card/table
doc.section();
doc.table();

DocIntentStyle titleCellStyle = new DocIntentStyle()
  .padding('14px')
  .fontSize('15px')
  .backgroundColor('#EEF4FF');
DocIntentStyle labelStyle = new DocIntentStyle()
  .padding('12px')
  .borderBottom('1px solid #E5E5E5')
  .bold();
DocIntentStyle valueStyle = new DocIntentStyle()
  .padding('12px')
  .borderBottom('1px solid #E5E5E5');

doc.row();
doc.cell('Account Information', titleCellStyle);
doc.cell('', titleCellStyle);

doc.row();
doc.cell('Account Name', labelStyle);
doc.cell(acc.Name == null ? '' : acc.Name, valueStyle);

doc.row();
doc.cell('Industry', labelStyle);
doc.cell(acc.Industry == null ? '' : acc.Industry, valueStyle);

doc.row();
doc.cell('Phone', labelStyle);
doc.cell(acc.Phone == null ? '' : acc.Phone, valueStyle);

doc.row();
doc.cell('Website', labelStyle);
doc.cell(acc.Website == null ? '' : acc.Website, valueStyle);

doc.endSection();

// Footer
doc.section();
doc.paragraph('PDF generated using DocIntent');
doc.endSection();

// Render PDF and save as ContentVersion
Blob pdf = doc.toPdf();

ContentVersion cv = new ContentVersion();
cv.Title = 'Account Info';
cv.PathOnClient = 'AccountInfo.pdf';
cv.VersionData = pdf;
cv.IsMajorVersion = true;

insert cv;
