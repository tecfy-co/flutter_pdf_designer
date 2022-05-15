part of flutter_pdf_designer;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//
// import '../../models/data_model.dart';

class LineEditDialog extends StatefulWidget {
  final Elements element;
  final void Function() onSubmitted;
  const LineEditDialog(
      {Key? key, required this.element, required this.onSubmitted})
      : super(key: key);

  @override
  State<LineEditDialog> createState() => _LineEditDialogState();
}

class _LineEditDialogState extends State<LineEditDialog> {
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
  void initState() {
    _lineWidthController.text = widget.element.width.toString();
    _lineColorController.text = widget.element.color.toString();
    _lineThicknessController.text = widget.element.thickness.toString();
    pickerColor = Color(widget.element.color);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Edit your Line'),
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
                      if (double.parse(s) >= 11) {
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
                        border: OutlineInputBorder(),
                        hintText: 'Enter Line width (Max 400)'),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ColorPicker(
                    hexInputController: _lineColorController,
                    pickerColor: pickerColor,
                    onColorChanged: changeColor,
                    onHsvColorChanged: (color) {
                      setState(() {
                        selectedColor = color.toColor().value;
                        widget.onSubmitted.call();
                      });
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
                            widget.element.width =
                                double.parse(_lineWidthController.text);
                            widget.element.thickness =
                                double.parse(_lineThicknessController.text);
                            widget.element.color = selectedColor;
                            widget.onSubmitted.call();
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
  }
}
