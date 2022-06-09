import 'package:flutter/material.dart';
//First import flutter_pdf_designer
import 'package:flutter_pdf_designer/flutter_pdf_designer.dart';
// Second import data_model
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
  // late PdfModel dataModel;
  // // initialize List of Elements
  // List<PdfElement>? elements = [
  //   PdfElement(
  //     type: PdfElementType.text,
  //     text: 'Tecfy.co',
  //     // color: 0xffFF000000,
  //     // fontSize: 40.0,
  //     // height: 250,
  //     // width: 250,
  //     alignment: PdfAlign.topRight,
  //   ),
  // ];
  late Map<String, dynamic> json;

  @override
  void initState() {
    json = {};
    // // initialize dataModel
    // dataModel = PdfModel(elements: elements);
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
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 600,
                  child: PdfDesign(
                    onChange: (json) {
                      print(json);
                      this.json = json;
                    },
                    json: json,
                    width: 1.5,
                    height: 1,
                    variableList: [
                      PdfDynamicField(
                          type: PdfElementType.text,
                          key: 'customerName',
                          name: 'إسم العميل',
                          designValue: 'Customer Name'),
                      PdfDynamicField(
                          type: PdfElementType.text,
                          key: 'branchName',
                          name: 'إسم الفرع',
                          designValue: 'إسم الفرع باللغة العربية'),
                      PdfDynamicField(
                          type: PdfElementType.image,
                          key: 'logo',
                          name: 'صورة',
                          designValue: ''
                              'Your Logo Here'),
                      PdfDynamicField(
                          type: PdfElementType.barcode,
                          key: 'bar'
                              'code',
                          name: 'باركود',
                          designValue: 'Barcode Data'),
                      PdfDynamicField(
                          type: PdfElementType.text,
                          key: 'date',
                          name: 'تاريخ الإنتاج / الإنتهاء',
                          designValue: '2/2/'
                              '2222'),
                      PdfDynamicField(
                          type: PdfElementType.text,
                          key: 'price',
                          name: 'السعر',
                          designValue: '30'),
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    // pass font path as a String in loadFont Function after
                    // adding it in your pupspec.ymal
                    await PdfWidget.loadFont('assets/fonts/STC-Regular.ttf')
                        .then((value) async {
                      final doc = pw.Document();
                      doc.addPage(pw.Page(
                          // pageFormat: PdfPageFormat(dataModel
                          //     .width!*PdfPageFormat.inch,
                          //     dataModel.height!*PdfPageFormat.inch),
                          //pageFormat: PdfPageFormat.roll57,
                          textDirection: pw.TextDirection.rtl,
                          build: (context) {
                            return pw.Column(
                              children: [
                                pw.Text('Header'),
                                PdfWidget.generate(
                                    json,
                                    {
                                      'logo': [1, 1, 1, 2],
                                      'barcode': 'wa.me/+201119369127',
                                      'customerName': 'Ahmed',
                                    },
                                    value,
                                    false)
                              ],
                            );
                          }));
                      await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async =>
                              doc.save()); // Page
                      print('Printing');
                    });
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
