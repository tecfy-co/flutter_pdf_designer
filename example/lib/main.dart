import 'package:flutter/material.dart';
import 'package:flutter_pdf_designer/flutter_pdf_designer.dart';
import 'package:flutter_pdf_designer/src/data_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
   MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDF Design',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        body: PdfDesign(onChange: (json){},json:{"width":300.0,"height":300.0,
          'elements':[{'type':WidgetType.text,'text':"Galal",'fontSize':30.0,'xPo'
              'sition':0.0,'yPosition':0.0}
          ]},width: 100,height: 200,),
      ),
    );
  }
}