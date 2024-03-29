part of flutter_pdf_designer;

class PdfElement {
  PdfElementType? type;
  late GlobalKey key;
  String? dynamicFieldKey;
  String? text;
  double? fontSize;
  List<int>? image;
  late double xPosition;
  late double yPosition;
  double? height;
  double? width;
  dynamic color;
  BarcodeType? barcode;
  PdfAlign? alignment;

  PdfElement({
    required this.type,
    this.text,
    this.fontSize,
    this.image,
    this.xPosition = 10,
    this.yPosition = 10,
    this.height,
    this.width,
    this.color,
    this.barcode,
    this.alignment,
    this.dynamicFieldKey,
  }) {
    key = GlobalKey();
  }

  PdfElement.text({
    required this.type,
    required this.text,
    this.fontSize,
    this.width = 50,
    this.height = 50,
    this.xPosition = 0,
    this.yPosition = 0,
    this.color,
    this.alignment = PdfAlign.topLeft,
    this.dynamicFieldKey,
  }) {
    key = GlobalKey();
  }

  PdfElement.image({
    required this.image,
    this.type = PdfElementType.image,
    this.width = 100,
    this.height = 100,
    this.xPosition = 0,
    this.yPosition = 0,
    this.dynamicFieldKey,
  }) {
    key = GlobalKey();
  }

  PdfElement.line({
    this.type = PdfElementType.line,
    this.width = 100,
    this.height = 10,
    this.color,
    this.xPosition = 0,
    this.yPosition = 0,
    this.dynamicFieldKey,
  }) {
    key = GlobalKey();
  }

  PdfElement.fromJson(Map<String, dynamic> json) {
    type = PdfElementType.values[json['type']];
    xPosition = json['xPosition'] ?? 0;
    yPosition = json['yPosition'] ?? 0;
    width = json['width'] ?? 50;
    height = json['height'] ?? 50;
    dynamicFieldKey = json['dynamicFieldKey'];
    if (type == PdfElementType.text) {
      text = json['text'];
      fontSize = json['fontSize'];
      color = json['color'];
      alignment = PdfAlign.values[json['alignment'] ?? 0];
    } else if (type == PdfElementType.image) {
      image = Uint8List.fromList(
          (json['image'] ?? []).map<int>((e) => e as int).toList());
    } else if (type == PdfElementType.line) {
      color = json['color'];
    } else {
      text = json['text'];
      barcode = BarcodeType.values[json['barcode'] ?? 0];
      color = json['color'];
      fontSize = json['fontSize'];
    }
    key = GlobalKey();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type!.index;

    data['xPosition'] = xPosition;
    data['yPosition'] = yPosition;
    data['width'] = width;
    data['height'] = height;
    data['dynamicFieldKey'] = dynamicFieldKey;

    if (type == PdfElementType.text) {
      data['text'] = text;
      data['fontSize'] = fontSize;
      data['color'] = color;
      data['alignment'] = alignment?.index;
    } else if (type == PdfElementType.image) {
      data['image'] = image as List<int>;
    } else if (type == PdfElementType.line) {
      data['color'] = color;
    } else {
      data['text'] = text;
      data['barcode'] = barcode?.index;
      data['color'] = color;
      data['fontSize'] = fontSize;
    }
    return data;
  }
}
