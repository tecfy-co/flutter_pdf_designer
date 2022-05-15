part of flutter_pdf_designer;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//
// import '../../models/data_model.dart';

class LineElement extends StatefulWidget {
  final String titleDialog;
  final String outlineBtnName;
  void Function(Elements elements)? onSubmitted;

   LineElement(
      {Key? key, required this.titleDialog, required this.outlineBtnName,this.onSubmitted})
      : super(key: key);

  @override
  State<LineElement> createState() => _LineElementState();
}

class _LineElementState extends State<LineElement> {
  final TextEditingController _lineWidthController = TextEditingController();
  final TextEditingController _lineColorController = TextEditingController();
  final TextEditingController _lineThicknessController =
      TextEditingController();

  var formKey = GlobalKey<FormState>();
  Color pickerColor = const Color(0xff000000);
  Color currentColor = const Color(0xff000000);
  dynamic selectedColor;


  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text(widget.titleDialog),
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(30.0),
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
                                  hintText: 'Enter Line Thickness (Max '
                                      '10)'),
                            ),
                            const SizedBox(height: 30),
                            TextFormField(
                              controller: _lineWidthController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              decoration: const InputDecoration(
                                  border:  OutlineInputBorder(),
                                  hintText: 'Enter Line width (Max 400)'),
                            ),
                            const SizedBox(
                              height: 40,
                            ),
                            ColorPicker(
                              hexInputController: _lineColorController,
                              pickerColor: pickerColor,
                              onColorChanged: changeColor,
                              onHsvColorChanged: (color){
                                selectedColor = color.toColor().value;
                              },
                              displayThumbColor: true,
                               portraitOnly: true,
                            ),
                            const SizedBox(
                              height: 50,
                            ),
                            MaterialButton(
                                color: Colors.deepOrange,
                                onPressed: () {
                                  setState(() {
                                    if (formKey.currentState!.validate()) {
                                      widget.onSubmitted!.call
                                      (Elements(type: WidgetType.line,
                                          thickness: double.parse
                                            (_lineThicknessController.text),
                                          width: double.parse
                                            (_lineWidthController.text),
                                          color: selectedColor));
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
