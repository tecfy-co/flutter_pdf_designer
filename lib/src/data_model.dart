import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/cupertino.dart';

class DataModel {
  double? width;
  double? height;
  List<Elements>? elements;

  DataModel({this.width, this.height, this.elements});

  DataModel.fromJson(Map<String, dynamic> json) {
    width = json['width'];
    height = json['height'];
    if (json['elements'] != null) {
      elements = <Elements>[];
      json['elements'].forEach((v) {
        elements!.add(new Elements.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['width'] = this.width;
    data['height'] = this.height;
    if (this.elements != null) {
      data['elements'] = this.elements!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

enum WidgetType { text, image, line, barcode }

class Elements {
  WidgetType? type;
  late GlobalKey key;
  String? text;
  double? fontSize;
  dynamic image;
  late double xPosition;
  late double yPosition;
  double? height;
  double? width;
  dynamic color;
  Barcode? barcode;

  Elements({
    required this.type,
    this.text,
    this.fontSize,
    this.image,
    this.xPosition = 0,
    this.yPosition = 0,
    this.height,
    this.width,
    this.color,
    this.barcode,
  }) {
    key = GlobalKey();
  }

  Elements.text({
    required this.type,
    required this.text,
    this.fontSize,
    this.xPosition = 0,
    this.yPosition = 0,
    this.color,
  }) {
    key = GlobalKey();
  }

  Elements.image({
    required this.image,
    this.type = WidgetType.image,
    this.width = 100,
    this.height = 100,
    this.xPosition = 0,
    this.yPosition = 0,
  }) {
    key = GlobalKey();
  }

  Elements.line({
    this.type = WidgetType.line,
    this.width = 100,
    this.height = 10,
    this.color,
    this.xPosition = 0,
    this.yPosition = 0,
  }) {
    key = GlobalKey();
  }

  Elements.fromJson(Map<String, dynamic> json) {
    type = WidgetType.values[json['type']];
    xPosition = json['xPosition'];
    yPosition = json['yPosition'];
    width = json['width'];
    height = json['height'];
    if (type == WidgetType.text) {
      text = json['text'];
      fontSize = json['fontSize'];
      color = json['color'];
    } else if (type == WidgetType.image) {
      image = json['image'];
    } else if (type == WidgetType.line) {
      color = json['color'];
    } else {
      text = json['text'];
      barcode = json['barcode'];
      color = json['color'];
    }
    key = GlobalKey();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['type'] = type!.index;

    data['xPosition'] = xPosition;
    data['yPosition'] = yPosition;
    data['width'] = width;
    data['height'] = height;

    if (type == WidgetType.text) {
      data['text'] = text;
      data['fontSize'] = fontSize;
      data['color'] = color;
    } else if (type == WidgetType.image) {
      data['image'] = image;
    } else if (type == WidgetType.line) {
      data['color'] = color;
    } else {
      data['text'] = text;
      data['barcode'] = barcode;
      data['color'] = color;
    }
    return data;
  }
}
