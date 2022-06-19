//First import flutter_pdf_designer
import 'package:flutter_pdf_designer/flutter_pdf_designer.dart';
import 'package:flutter/material.dart';
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
  late Map<String, dynamic> json;

  @override
  void initState() {
    json = {};
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
        //call PdfDesign in your widget tree
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                PdfInsertWidgets(
                  translate: (val) {
                    return val;
                  },
                  key: UniqueKey(),
                  onChange: (json) {
                    print('insert Widget json = $json');
                    setState(() {
                      this.json = json;
                    });
                  },
                  json: json,
                  heightLabel: 'Height in Inches',
                  textFieldBorder: OutlineInputBorder(),
                  widthLabel: 'Width in Inches',
                  dynamicVariableList: [
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
                SizedBox(
                  height: 600,
                  child: PdfBoxDesign(
                    key: UniqueKey(),
                    onChange: (json) {
                      print('Design json = $json');
                      this.json = json;
                      setState(() {});
                    },
                    json: json,
                    alignment: Alignment.center,
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    // pass font path as a String in getAssetFont Function after
                    // adding it in your pupspec.ymal
                    await PdfWidget.getAssetFont('assets/fonts/STC-Regular.ttf')
                        .then((font) async {
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
                                PdfWidget.generatePrintWidget(
                                    json,
                                    {
                                      'logo': [1, 1, 1, 2],
                                      'barcode': 'wa.me/+201119369127',
                                      'customerName': 'Ahmed',
                                    },
                                    font,
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
