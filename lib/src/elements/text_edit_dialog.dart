part of flutter_pdf_designer;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_colorpicker/flutter_colorpicker.dart';
//
// import '../../models/data_model.dart';

class TextEditDialog extends StatefulWidget {
  final Elements element;
  final void Function() onSubmitted;

  const TextEditDialog(
      {Key? key, required this.element, required this.onSubmitted})
      : super(key: key);

  @override
  State<TextEditDialog> createState() => _TextEditDialogState();
}

class _TextEditDialogState extends State<TextEditDialog> {
  var formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController();
  final TextEditingController _fontColorController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  Color pickerColor = const Color(0xff000000);
  dynamic selectedColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);

    debugPrint('Change Color to ${pickerColor.value}');
  }

  @override
  void initState() {
    _textController.text = widget.element.text!;
    _fontSizeController.text = widget.element.fontSize!.toString();
    _widthController.text = widget.element.width!.toString();
    _heightController.text = widget.element.height!.toString();
    pickerColor = Color(widget.element.color ?? 0xff000000);
    super.initState();
  }

  @override
  void dispose(){
    _textController.dispose();
    _fontSizeController.dispose();
    _fontColorController.dispose();
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Edit'),
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(children: [
              TextFormField(
                autofocus: true,
                controller: _textController,
                keyboardType: TextInputType.text,
                enableSuggestions: true,
                validator: (s) {
                  if (s!.isEmpty) {
                    return 'Text must be entered';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Enter your text here',
                  labelText: 'Text',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      autofocus: true,
                      controller: _fontSizeController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (s) {
                        if (s!.isEmpty) {
                          return 'Font Size Must be Entered';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enableSuggestions: true,
                      decoration: const InputDecoration(
                        hintText: 'Enter your font size',
                        labelText: 'Font Size',
                        isDense: true,
                        isCollapsed: false,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextFormField(
                    autofocus: true,
                    controller: _widthController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (s) {
                      if (s!.isEmpty) {
                        return 'Width Must be Entered';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Width',
                      labelText: 'Width',
                      isDense: true,
                      isCollapsed: false,
                      border: OutlineInputBorder(),
                    ),
                  )),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      child: TextFormField(
                    autofocus: true,
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: (s) {
                      if (s!.isEmpty) {
                        return 'Height Must be Entered';
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    enableSuggestions: true,
                    decoration: const InputDecoration(
                      hintText: 'Enter your Height',
                      labelText: 'Height',
                      isDense: true,
                      isCollapsed: false,
                      border: OutlineInputBorder(),
                    ),
                  )),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              ColorPicker(
                hexInputController: _fontColorController,
                onHsvColorChanged: (color) {
                  debugPrint('Color = ${color.toColor().value}');
                  debugPrint(_fontColorController.text);
                  selectedColor = color.toColor().value;
                },
                pickerColor: pickerColor,
                onColorChanged: changeColor,
                displayThumbColor: true,
                portraitOnly: true,
                enableAlpha: false,
                pickerAreaHeightPercent: 0.24,
              ),
              const SizedBox(
                height: 10,
              ),
              MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        widget.element.text = _textController.text;
                        widget.element.fontSize =
                            double.parse(_fontSizeController.text);
                        widget.element.color = selectedColor;
                        widget.element.width =
                            double.parse(_widthController.text);
                        widget.element.height =
                            double.parse(_heightController.text);
                        widget.onSubmitted.call();
                        Navigator.pop(context);
                      });
                    }
                  },
                  child: const Text('Save')),
            ]),
          ),
        ),
      ],
    );
  }
}
