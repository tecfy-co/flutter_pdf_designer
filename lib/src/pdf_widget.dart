part of flutter_pdf_designer;

class PdfWidget {
  static pw.Widget generate(
      Map<String, dynamic> json, Map<String, dynamic> data, font) {
    final PdfModel dataModel;
    dataModel = PdfModel.fromJson(json);
    print(dataModel.toJson());
    //   print(data);
    var barcodeData = data['barcode'];
    //  print(barcodeData);
    final ttf = pw.Font.ttf(font.buffer.asByteData());

    return pw.Container(
      width: dataModel.width! * PdfPageFormat.inch,
      height: dataModel.height! * PdfPageFormat.inch,
      child: pw.Stack(
        children: dataModel.elements!.map<pw.Widget>((e) {
          print(e.type);

          if (dataModel.elements!.isNotEmpty) {
            switch (e.type) {
              case PdfElementType.text:
                {
                  print('it\'s Text !');
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.Container(
                      alignment: getAlignment(e.alignment!),
                      width: e.width,
                      height: e.height,
                      child: pw.Text(
                        e.text == 'Customer Name'
                            ? getPrintText(data)!
                            : e.text!,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: e.fontSize,
                          color: PdfColor.fromInt(e.color ?? 0xffFF000000),
                        ),
                      ),
                    ),
                  );
                }
              case PdfElementType.image:
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
              case PdfElementType.line:
                {
                  print('it\'s Line !');
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.Container(
                      color: PdfColor.fromInt(e.color ?? 0xffFF000000),
                      height: e.height,
                      width: e.width ?? 300,
                    ),
                  );
                }
              case PdfElementType.barcode:
                {
                  return pw.Positioned(
                    left: e.xPosition,
                    top: e.yPosition,
                    child: pw.BarcodeWidget(
                      height: e.height,
                      width: e.width,
                      barcode: e.barcode!,
                      textStyle: pw.TextStyle(
                        fontSize: e.fontSize ?? 6,
                      ),
                      data: barcodeData,
                      color: PdfColor.fromInt(e.color ?? 0xffFF000000),
                    ),
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

  static pw.Alignment getAlignment(PdfAlign align) {
    switch (align) {
      case PdfAlign.bottomRight:
        return pw.Alignment.bottomRight;
      case PdfAlign.center:
        return pw.Alignment.center;

      case PdfAlign.bottomCenter:
        return pw.Alignment.bottomCenter;

      case PdfAlign.topCenter:
        return pw.Alignment.topCenter;

      case PdfAlign.topRight:
        return pw.Alignment.topRight;

      case PdfAlign.centerRight:
        return pw.Alignment.centerRight;

      case PdfAlign.centerLeft:
        return pw.Alignment.centerLeft;

      case PdfAlign.bottomLeft:
        return pw.Alignment.bottomLeft;

      case PdfAlign.topLeft:
        return pw.Alignment.topLeft;

      default:
        return pw.Alignment.topLeft;
    }
  }

  static String? getPrintText(Map<String, dynamic> data) {
    try {
      for (MapEntry e in data.entries) {
        print("Key ${e.key}, Value ${e.value}");
        if (e.key.contains('Customer')) {
          return data[e.key];
        }
      }
    } catch (e, st) {
      print(e);
      print(st);
    }
    return null;
  }
}
