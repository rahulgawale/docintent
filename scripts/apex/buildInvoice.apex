// Professional Invoice Example - Forcetrails Inc.
// Execute from Anonymous Apex

public class InvoiceStyles implements DocIntentBaseStyles {
  public Map<String, DocIntentStyle> styles() {
    Map<String, DocIntentStyle> m = new Map<String, DocIntentStyle>();

    m.put(
      'document.base',
      new DocIntentStyle()
        .fontFamily('Arial, sans-serif')
        .fontSize('11px')
        .color('#222222')
    );

    m.put(
      'heading.H1',
      new DocIntentStyle().fontSize('28px').bold().color('#0176D3')
    );

    m.put(
      'heading.H2',
      new DocIntentStyle().fontSize('16px').bold().color('#333333')
    );

    m.put(
      'table.base',
      new DocIntentStyle().width('100%').border('1px solid #CCCCCC')
    );

    return m;
  }
}

DocIntentDocument doc = DocIntentDocument.create()
  .withBaseStyles(new InvoiceStyles());

String borderCell = '1px solid #DDDDDD';

// Letterhead Section
doc.section(
  new DocIntentStyle()
    .backgroundColor('#0176D3')
    .spacing(DocIntentSpacingScale.p(5))
);
doc.heading(
  'Forcetrails Inc.',
  DocIntentHeadingLevel.H1,
  new DocIntentStyle().color('#FFFFFF').fontSize('32px').set('margin', '0')
);
doc.paragraph(
  '123 Cloud Street, San Francisco, CA 94105',
  new DocIntentStyle().color('#FFFFFF').fontSize('12px')
);
doc.paragraph(
  'Phone: (415) 555-0100 | Email: billing@forcetrails.com',
  new DocIntentStyle().color('#FFFFFF').fontSize('12px')
);
doc.endSection();

// Invoice Info and Customer Info Section
doc.section(new DocIntentStyle().spacing(DocIntentSpacingScale.pt(4)));
doc.table();

// Invoice details (left) and Customer details (right)
doc.row();
doc.cell(
  'Invoice #INV-2026-001',
  new DocIntentStyle().bold().fontSize('14px').padding('8px')
);
doc.cell(
  'Bill To:',
  new DocIntentStyle().bold().fontSize('14px').padding('8px').textAlign('right')
);

doc.row();
doc.cell('Date: January 27, 2026', new DocIntentStyle().padding('8px'));
doc.cell(
  'ACME Inc.',
  new DocIntentStyle().padding('8px').textAlign('right').bold()
);

doc.row();
doc.cell('Due Date: February 26, 2026', new DocIntentStyle().padding('8px'));
doc.cell(
  '456 Enterprise Way, New York, NY 10001',
  new DocIntentStyle().padding('8px').textAlign('right')
);

doc.endSection();

// Items Table
doc.section(new DocIntentStyle().spacing(DocIntentSpacingScale.my(4)));
doc.heading('Items', DocIntentHeadingLevel.H2);
doc.table();

// Header row
DocIntentStyle headerStyle = new DocIntentStyle()
  .backgroundColor('#F4F6F9')
  .bold()
  .padding('12px')
  .border(borderCell);

doc.row();
doc.cell('Description', headerStyle);
doc.cell('Quantity', headerStyle.textAlign('center'));
doc.cell('Unit Price', headerStyle.textAlign('right'));
doc.cell('Amount', headerStyle.textAlign('right'));

// Item rows
DocIntentStyle cellStyle = new DocIntentStyle()
  .padding('10px')
  .border(borderCell);

DocIntentStyle cellCenterStyle = new DocIntentStyle()
  .padding('10px')
  .border(borderCell)
  .textAlign('center');

DocIntentStyle cellRightStyle = new DocIntentStyle()
  .padding('10px')
  .border(borderCell)
  .textAlign('right');

doc.row();
doc.cell('Salesforce Implementation Services', cellStyle);
doc.cell('40', cellCenterStyle);
doc.cell('$150.00', cellRightStyle);
doc.cell('$6,000.00', cellRightStyle);

doc.row();
doc.cell('Custom Lightning Components', cellStyle);
doc.cell('20', cellCenterStyle);
doc.cell('$175.00', cellRightStyle);
doc.cell('$3,500.00', cellRightStyle);

doc.row();
doc.cell('API Integration Development', cellStyle);
doc.cell('15', cellCenterStyle);
doc.cell('$200.00', cellRightStyle);
doc.cell('$3,000.00', cellRightStyle);

doc.row();
doc.cell('Training and Support', cellStyle);
doc.cell('10', cellCenterStyle);
doc.cell('$125.00', cellRightStyle);
doc.cell('$1,250.00', cellRightStyle);

// Subtotal, Tax, Total
DocIntentStyle totalLabelStyle = new DocIntentStyle()
  .padding('10px')
  .border(borderCell)
  .bold()
  .textAlign('right');

DocIntentStyle totalValueStyle = new DocIntentStyle()
  .padding('10px')
  .border(borderCell)
  .textAlign('right');

doc.row();
doc.cell('', cellStyle);
doc.cell('', cellStyle);
doc.cell('Subtotal:', totalLabelStyle);
doc.cell('$13,750.00', totalValueStyle);

doc.row();
doc.cell('', cellStyle);
doc.cell('', cellStyle);
doc.cell('Tax (8.5%):', totalLabelStyle);
doc.cell('$1,168.75', totalValueStyle);

doc.row();
doc.cell('', cellStyle);
doc.cell('', cellStyle);
doc.cell(
  'Total Due:',
  totalLabelStyle.backgroundColor('#0176D3').color('#FFFFFF').fontSize('14px')
);
doc.cell(
  '$14,918.75',
  totalValueStyle
    .backgroundColor('#0176D3')
    .color('#FFFFFF')
    .bold()
    .fontSize('14px')
);

doc.endSection();

// Payment Terms - Fine Print
doc.section(new DocIntentStyle().spacing(DocIntentSpacingScale.my(4)));
doc.heading('Payment Terms', DocIntentHeadingLevel.H2);
doc.paragraph(
  'Payment is due within 30 days of invoice date. Please include invoice number with payment.',
  DocIntentFontScale.sm()
);
doc.paragraph(
  'Late payments are subject to a 1.5% monthly interest charge. All payments should be made via wire transfer or check to Forcetrails Inc.',
  DocIntentFontScale.sm()
);
doc.paragraph(
  'For questions regarding this invoice, please contact billing@forcetrails.com or call (415) 555-0100.',
  DocIntentFontScale.xs().italic()
);
doc.endSection();

// Footer
doc.section(
  new DocIntentStyle()
    .backgroundColor('#F4F6F9')
    .spacing(DocIntentSpacingScale.p(3))
    .textAlign('center')
);
doc.paragraph(
  'Thank you for your business!',
  new DocIntentStyle().bold().color('#0176D3')
);
doc.paragraph(
  'Forcetrails Inc. | www.forcetrails.com',
  DocIntentFontScale.xs()
);
doc.endSection();

// Render PDF
Blob pdf = doc.toPdf();

ContentVersion cv = new ContentVersion();
cv.Title = 'Invoice-INV-2026-001';
cv.PathOnClient = 'Invoice-INV-2026-001.pdf';
cv.VersionData = pdf;
cv.IsMajorVersion = true;

insert cv;
