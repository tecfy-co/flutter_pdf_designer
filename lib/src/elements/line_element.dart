part of flutter_pdf_designer;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//
// import '../../models/data_model.dart';

class LineElement extends StatefulWidget {
  final String titleDialog;
  final String outlineBtnName;
  final double lineWidth;
  void Function(PdfElement elements)? onSubmitted;

  LineElement(
      {Key? key,
      required this.titleDialog,
      required this.outlineBtnName,
      this.onSubmitted,
      required this.lineWidth})
      : super(key: key);

  @override
  State<LineElement> createState() => _LineElementState();
}

class _LineElementState extends State<LineElement> {
  final TextEditingController _lineWidthController =
      TextEditingController(text: 300.toString());
  final TextEditingController _lineColorController = TextEditingController();
  final TextEditingController _lineThicknessController =
      TextEditingController(text: 10.toString());

  var formKey = GlobalKey<FormState>();
  Color pickerColor = const Color(0xff000000);
  Color currentColor = const Color(0xff000000);
  dynamic selectedColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    _lineWidthController.dispose();
    _lineThicknessController.dispose();
    _lineColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text(widget.titleDialog),
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              controller: _lineThicknessController,
                              keyboardType: TextInputType.number,
                              validator: (s) {
                                if (s!.isEmpty) {
                                  return 'Line Thickness must'
                                      ' be entered';
                                }
                                if (int.parse(s) >= 11) {
                                  return 'Line Thickness must'
                                      ' be lower than 11';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText: 'Enter Line Thickness',
                                  labelText: 'Thickness'),
                              //   initialValue: 20.toString(),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _lineWidthController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  hintText:
                                      'Enter Line width (Max ${widget.lineWidth.toInt()})',
                                  labelText: 'Width'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ColorPicker(
                              hexInputController: _lineColorController,
                              enableAlpha: false,
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                              onHsvColorChanged: (color) {
                                selectedColor = color.toColor().value;
                              },
                              // displayThumbColor: true,
                              portraitOnly: true,
                              pickerAreaHeightPercent: 0.24,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            MaterialButton(
                                color: Theme.of(context).primaryColor,
                                onPressed: () {
                                  setState(() {
                                    if (formKey.currentState!.validate()) {
                                      widget.onSubmitted?.call(PdfElement(
                                          type: PdfElementType.line,
                                          height: double.parse(
                                              _lineThicknessController.text),
                                          width: double.parse(
                                              _lineWidthController.text),
                                          color: selectedColor,
                                          yPosition: 0,
                                          xPosition: 0));
                                      _lineWidthController.clear();
                                      _lineThicknessController.clear();
                                      _lineColorController.clear();
                                      Navigator.pop(context);
                                    }
                                  });
                                },
                                child: const Text('Save')),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            });
      },
      child: Text(widget.outlineBtnName),
    );
  }
}
