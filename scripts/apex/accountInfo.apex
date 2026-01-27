// Anonymous Apex: build an Account info PDF using DocIntent
// Replace the Id below with a real Account Id in your org.
Id acctId = '001Ws000052afDpIAI';

Account acc = [
  SELECT Id, Name, Industry, Phone, Website
  FROM Account
  WHERE Id = :acctId
  LIMIT 1
];

// Define custom base styles for this document
class AccountReportStyles implements DocIntentBaseStyles {
  private String border = '1px solid #909090';

  public Map<String, DocIntentStyle> styles() {
    Map<String, DocIntentStyle> m = new Map<String, DocIntentStyle>();

    m.put(
      'document.base',
      new DocIntentStyle()
        .fontFamily('sans-serif')
        .fontSize('12px')
        .color('#000000')
    );

    m.put(
      'heading.H1',
      new DocIntentStyle()
        .fontSize('30px')
        .set('letter-spacing', '1px')
        .set('margin', '0')
        .color('#FFFFFF')
    );

    m.put(
      'table.base',
      new DocIntentStyle()
        .backgroundColor('#FFFFFF')
        .border(border)
        .width('100%')
    );

    m.put('cell.base', new DocIntentStyle().padding('12px').border(border));

    return m;
  }
}

String border = '1px solid #909090';
DocIntentDocument doc = DocIntentDocument.create()
  .withBaseStyles(new AccountReportStyles());

// Build header
doc.section(
  new DocIntentStyle()
    .backgroundColor('#0176D3')
    .spacing(DocIntentSpacingScale.p(6))
);
doc.heading(
  'DocIntent PDF Generation',
  DocIntentHeadingLevel.H1,
  new DocIntentStyle()
    .fontSize('30px')
    .set('letter-spacing', '1px')
    .set('margin', '0')
    .color('#FFFFFF')
);
doc.paragraph(
  'DocIntent is a PDF generation DSL that lets you safely build reusable document blocks and assemble any PDF without touching fragile HTML.',
  new DocIntentStyle().color('#FFFFFF')
);
doc.endSection();

// Main card/table
doc.section();
doc.table();

DocIntentStyle titleCellStyle = new DocIntentStyle()
  .padding('14px')
  .fontSize('15px')
  .backgroundColor('#EEF4FF')
  .border(border);
DocIntentStyle labelStyle = new DocIntentStyle()
  .padding('12px')
  .border(border)
  .bold();
DocIntentStyle valueStyle = new DocIntentStyle().padding('12px').border(border);

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

System.debug(doc.toHtml());
ContentVersion cv = new ContentVersion();
cv.Title = 'Account Info';
cv.PathOnClient = 'AccountInfo.pdf';
cv.VersionData = pdf;
cv.IsMajorVersion = true;

insert cv;
