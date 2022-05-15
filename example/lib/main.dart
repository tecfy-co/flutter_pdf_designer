import 'package:flutter/material.dart';
//First import flutter_pdf_designer
import 'package:flutter_pdf_designer/flutter_pdf_designer.dart';
// Second import data_model
import 'package:flutter_pdf_designer/src/data_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  //declare dataModel as late to initialize lately at initState function and
  late DataModel dataModel;
  // initialize List of Elements
  List<Elements>? elements = [
  Elements(
  type: WidgetType.text,
  text: 'Tecfy.co',
  color: 0xffFF000000,
  fontSize: 20.0),];

  @override
  void initState() {
    // initialize dataModel
    dataModel = DataModel(width: 200,height: 200,elements:elements);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Design',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        //call PdfDesign in your widget tree, pass to it width and height to
        // make box of printing box's size
        body: PdfDesign(onChange: (json){},json: dataModel.toJson(),width: 100,
          height: 200,),
      ),
    );
  }
}