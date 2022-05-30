part of flutter_pdf_designer;

class PdfWidget {
  static pw.Widget generate(
      Map<String, dynamic> json, Map<String, dynamic> data, font) {
    final DataModel dataModel;
    dataModel = DataModel.fromJson(json);
    print(data);
    var barcodeData = data['barcode'];
    print(barcodeData);
    final ttf = pw.Font.ttf(font.buffer.asByteData());

    return pw.Container(
      width: dataModel.width,
      height: dataModel.height,
      child: pw.Stack(
        children: dataModel.elements!.map<pw.Widget>((e) {
          print(e.type);

          if (dataModel.elements!.isNotEmpty) {
            switch (e.type) {
              case WidgetType.text:
                {
                  print('it\'s Text !');
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.Text(
                      e.text == 'CustomerName'
                          ? data.values.first.toString()
                          : e.text!,
                      style: pw.TextStyle(
                          font: ttf,
                          fontSize: e.fontSize,
                          color: PdfColor.fromInt(e.color ?? 0xffFF000000)),
                    ), );
                }
              case WidgetType.image:
                {
                  print('it\'s Image !');
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: e.image != null
                        ? pw.Image(
                            pw.MemoryImage(
                              e.image!,
                            ),
                            height: e.height,
                            width: e.width)
                        : pw.Container(
                            color: PdfColors.red, width: 100, height: 100),
                  );
                }
              case WidgetType.line:
                {
                  print('it\'s Line !');
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.Container(
                      color: PdfColor.fromInt(e.color),
                      height: e.height,
                      width: e.width ?? 300,
                    ),
                  );
                }
              case WidgetType.barcode:
                {
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.BarcodeWidget(
                        height: e.height,
                        width: e.width,
                        barcode: e.barcode!,
                        data: barcodeData),
                  );
                }
            }
          }
          return pw.Container(color: PdfColors.red, width: 50, height: 50);
        }).toList(),
      ),
    );
  }

  static Future<ByteData> loadFont(String fontPath) async {
    final font = await rootBundle.load(fontPath);
    return font;
  }
}
