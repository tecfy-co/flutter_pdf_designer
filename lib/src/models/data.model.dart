part of flutter_pdf_designer;

class PdfModel {
  double? width;
  double? height;
  String? printerName;
  List<PdfElement>? elements;

  PdfModel({this.width, this.height, this.printerName, this.elements});

  PdfModel.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    printerName = json['printerName'];

    if (json['elements'] != null) {
      elements = <PdfElement>[];
      json['elements'].forEach((v) {
        elements!.add(PdfElement.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['width'] = width;
    data['height'] = height;
    data['printerName'] = printerName;
    if (elements != null) {
      data['elements'] = elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
