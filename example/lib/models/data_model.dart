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

enum WidgetType { text, image, line }

class Elements {
  late final WidgetType type;
  late GlobalKey key;
  String? text;
  double? fontSize;
  dynamic image;
  late double xPosition;
  late double yPosition;
  double? height;
  double? thickness;
  double? width;
  dynamic color;

  Elements(
      {required this.type,
      this.text,
      this.fontSize,
      this.image,
      this.xPosition = 0,
      this.yPosition = 0,
      this.height,
      this.thickness,
      this.width,
      this.color}) {
    key = GlobalKey();
  }
  Elements.fromJson(Map<String, dynamic> json) {
    type = json['type'] ?? WidgetType.text;
    if (type == WidgetType.text) {
      text = json['text'];
      fontSize = json['fontSize'];
      color = json['color'];
      xPosition = json['xPosition'];
      yPosition = json['yPosition'];
    } else if (type == WidgetType.image) {
      image = json['image'];
      height = json['height'];
      width = json['width'];
      xPosition = json['xPosition'];
      yPosition = json['yPosition'];
    } else {
      thickness = json['thickness'];
      width = json['width'];
      color = json['color'];
    }
    key = GlobalKey();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (type == WidgetType.text) {
      data['text'] = this.text;
      data['fontSize'] = this.fontSize;
      data['color'] = this.color;
      data['xPosition'] = this.xPosition;
      data['yPosition'] = this.yPosition;
    } else if (type == WidgetType.image) {
      data['image'] = this.image;
      data['xPosition'] = this.xPosition;
      data['yPosition'] = this.yPosition;
      data['width'] = this.width;
      data['height'] = this.height;
    } else {
      data['thickness'] = this.thickness;
      data['width'] = this.width;
      data['color'] = this.color;
      data['xPosition'] = this.xPosition;
      data['yPosition'] = this.yPosition;
    }
    return data;
  }
}
