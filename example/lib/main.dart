import 'package:flutter/material.dart';
//First import flutter_pdf_designer
import 'package:flutter_pdf_designer/flutter_pdf_designer.dart';
// Second import data_model
import 'package:flutter_pdf_designer/src/data_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
        fontSize: 20.0),
  ];
  var json;
  @override
  void initState() {
    // initialize dataModel
    dataModel = DataModel(width: 400, height: 400, elements: elements);
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                PdfDesign(
                  onChange: (json) {
                    print(json);
                    this.json = json;
                  },
                  json: dataModel.toJson(),
                  width: 400,
                  height: 400,
                  variableList: const {
                    "CustomerName": WidgetType.text,
                    "Logo": WidgetType.image,
                    'invoiceBarcode': WidgetType.barcode
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                MaterialButton(
                  onPressed: () async {
                    final doc = pw.Document();
                    doc.addPage(pw.Page(
                      build: (context) => pw.Column(
                        children: [
                          pw.Text('Header'),
                          PdfWidget.generate(json, {
                            'CustomerName': 'Ahmed',
                            'logo': [1, 1, 1, 2],
                            'barcode': 'wa.me/+201119369127'
                          })
                        ],
                      ),
                      // pageFormat: PdfPageFormat(dataModel.width!,dat, '
                      // aModel
                      // .height!)
                      //
                    ));
                    await Printing.layoutPdf(
                        onLayout: (PdfPageFormat format) async =>
                            doc.save()); // Page
                    print('Printing');
                  },
                  color: Colors.blue,
                  child: const Text('Print'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
