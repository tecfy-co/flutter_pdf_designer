import 'package:flutter/material.dart';
import 'package:generate_receipt/models/data_model.dart';
import 'package:generate_receipt/view/pdf_design.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  DataModel? dataModel;
  List<Elements>? elements = [
    Elements(
        type: WidgetType.text,
        text: 'Tecfy.co',
        color: 0xffFF000000,
        fontSize: 20.0),
  ];

  @override
  void initState() {
    dataModel = DataModel(width: 300, height: 300, elements: elements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PdfDesign(
            onChange: (json) {
              debugPrint('Main Screen Json = $json');
            },
            json: dataModel!.toJson(),
            width: dataModel!.width!),
      ),
    );
  }
}
