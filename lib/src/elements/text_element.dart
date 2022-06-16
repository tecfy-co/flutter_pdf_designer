part of flutter_pdf_designer;

class TextElement extends StatefulWidget {
  final void Function(PdfElement elements)? onSubmitted;
  final String Function(String val)? translate;

  TextElement({Key? key, this.onSubmitted, this.translate}) : super(key: key);

  @override
  State<TextElement> createState() => _TextElementState();
}

class _TextElementState extends State<TextElement> {
  var formKey = GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _fontSizeController =
      TextEditingController(text: 4.toString());
  final TextEditingController _fontColorController = TextEditingController();
  final TextEditingController _widthController =
      TextEditingController(text: 50.toString());
  final TextEditingController _heightController =
      TextEditingController(text: 10.toString());

  Color pickerColor = const Color(0xff000000);
  Color currentColor = const Color(0xff000000);
  dynamic selectedColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void dispose() {
    _textController.dispose();
    _fontSizeController.dispose();
    _fontColorController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.translate!('Insert Text'),
      child: IconButton(
        icon: Icon(Icons.text_fields, color: Theme.of(context).primaryColor),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(widget.translate!('Insert Text')),
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
                                return widget
                                    .translate!('Text must be entered');
                              }
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (String submittedText) {
                              // widget.onSubmitted!.call(submittedText);
                              // _textController.clear();
                            },
                            decoration: InputDecoration(
                              hintText:
                                  widget.translate!('Enter your text here'),
                              labelText: widget.translate!('Text'),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        const SizedBox(height: 10),
                        Row(children: [
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
                                  return widget.translate!(
                                        'Font Size Must be Entered');
                                  }
                              },
                                textInputAction: TextInputAction.next,
                                enableSuggestions: true,
                                onFieldSubmitted: (String submittedText,
                                    [size]) {
                                  // widget.onSubmitted!.call(submittedText,data: [size]);
                                  // _textController.clear();
                                  // _fontSizeController.clear();
                                },
                                onEditingComplete: () {
                                  print('OnEditingComplete');
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      widget.translate!('Enter your font size'),
                                  labelText: widget.translate!('Font Size'),
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
                                  return widget
                                        .translate!('Width Must be Entered');
                                  }
                              },
                                textInputAction: TextInputAction.next,
                                enableSuggestions: true,
                                onFieldSubmitted: (String submittedText,
                                    [size]) {
                                  // widget.onSubmitted!.call(submittedText,data: [size]);
                                  // _textController.clear();
                                  // _fontSizeController.clear();
                                },
                                onEditingComplete: () {
                                  print('OnEditingComplete');
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      widget.translate!('Enter your width'),
                                  labelText: widget.translate!('Width'),
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
                              controller: _heightController,
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              validator: (s) {
                                if (s!.isEmpty) {
                                  return widget
                                        .translate!('Height Must be Entered');
                                  }
                              },
                                textInputAction: TextInputAction.next,
                                enableSuggestions: true,
                                onFieldSubmitted: (String submittedText,
                                    [size]) {
                                  // widget.onSubmitted!.call(submittedText,data: [size]);
                                  // _textController.clear();
                                  // _fontSizeController.clear();
                                },
                                onEditingComplete: () {
                                  print('OnEditingComplete');
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      widget.translate!('Enter your height'),
                                  labelText: widget.translate!('Height'),
                                  border: OutlineInputBorder(),
                                ),
                              ),
                          ),
                        ]),
                        const SizedBox(
                          height: 10,
                        ),
                        ColorPicker(
                          hexInputController: _fontColorController,
                          onHsvColorChanged: (color) {
                            //   print('Color = ${color.toColor().value}');
                            // _fontColorController.text= color.toColor().value;
                            //       print(_fontColorController.text);
                            selectedColor = color.toColor().value;
                          },
                          pickerColor: pickerColor,
                          onColorChanged: changeColor,
                          displayThumbColor: true,
                          enableAlpha: false,
                          portraitOnly: true,
                          pickerAreaHeightPercent: 0.24,
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                setState(() {
                                  print("Font Color =  "
                                      "${_fontColorController.text}");
                                  widget.onSubmitted?.call(PdfElement(
                                      type: PdfElementType.text,
                                      text: _textController.text,
                                      fontSize: double.parse(
                                          _fontSizeController.text),
                                      color: selectedColor,
                                      width:
                                          double.parse(_widthController.text),
                                      height: double.parse(
                                          _heightController.text)));
                                  _fontSizeController.clear();
                                  _textController.clear();
                                  _fontColorController.clear();
                                  Navigator.pop(context);
                                  });
                                }
                                // widget.onSubmitted!.call(_textController.text,data:
                                // double.parse(_fontSizeController.text));
                                // setState(() {
                                //   widget.onSubmitted!.call(_textController.text,
                                //       data: double.parse(_fontSizeController.text));
                                //   _textController.clear();
                                //   _fontSizeController.clear();
                              },
                              child: Text(widget.translate!('Save'))),
                        ]),
                      ),
                    ),
                  ],
                );
              });
        },
      ),
    );
  }
}
