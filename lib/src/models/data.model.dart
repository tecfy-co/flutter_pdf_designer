part of flutter_pdf_designer;

class PdfModel {
  double? width;
  double? height;
  List<PdfElement>? elements;

  PdfModel({this.width = 1.5, this.height = 1, this.elements});

  PdfModel.fromJson(Map<String, dynamic> json) {
    width = json['width'] ?? 1;
    height = json['height'] ?? 1;

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
    if (elements != null) {
      data['elements'] = elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
