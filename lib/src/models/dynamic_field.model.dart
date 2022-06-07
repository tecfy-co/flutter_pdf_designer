part of flutter_pdf_designer;

class PdfDynamicField {
  PdfElementType? type;
  late String key;
  late String name;
  String? designValue;

  PdfDynamicField({
    required this.type,
    required this.key,
    required this.name,
    this.designValue,
  });

  PdfDynamicField.fromJson(Map<String, dynamic> json) {
    type = PdfElementType.values[json['type']];
    key = json['key'];
    name = json['name'];
    designValue = json['designValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type!.index;
    data['key'] = key;
    data['name'] = name;
    data['designValue'] = designValue;
    return data;
  }
}
