part of flutter_pdf_designer;

class PdfWidget {
  static pw.Widget generate(Map<String, dynamic> json) {
    final DataModel dataModel;
    dataModel = DataModel.fromJson(json);

    // final Uint8List fontData = File('lib/assets/STC-Regular.ttf')
    //     .readAsBytesSync();
    // final ttf = pw.Font.ttf(fontData.buffer.asByteData());

    return pw.Container(
      width: dataModel.width,
        height: dataModel.height,
      child: pw.Stack(
        children: dataModel.elements!.map<pw.Widget>((e) {
          if (dataModel.elements!.isNotEmpty) {
            switch (e.type) {
              case WidgetType.text:
                {
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.Text(
                      e.text ?? '-',
                      style: pw.TextStyle(
                          fontSize: e.fontSize,
                          color: PdfColor.fromInt(e.color ??
                         0xffFF000000)),
                    ),
                  );
                }
              case WidgetType.image:
                {
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                        child: pw.Image( pw.MemoryImage(
                          e.image,
                        ),height: e.height,width: e.width),
                  );
                }
              case WidgetType.line:
                {
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.Container(
                      color:  PdfColor.fromInt(e.color),
                      height: e.thickness,
                      width: e.width ?? 300  ,
                    ),
                  );
                }
            }
          }
          return pw.Container(color: PdfColors.red,width: 50,height: 50);
        }).toList(),
      ),
      decoration:
          pw.BoxDecoration(color: PdfColors.blue, border: pw.Border.all()),
    );
  }
}
