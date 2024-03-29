part of flutter_pdf_designer;


class LineElement extends StatefulWidget {
  final double lineWidth;
  void Function(PdfElement elements)? onSubmitted;
  final String Function(String val)? translate;

  LineElement(
      {Key? key, this.translate, this.onSubmitted, required this.lineWidth})
      : super(key: key);

  @override
  State<LineElement> createState() => _LineElementState();
}

class _LineElementState extends State<LineElement> {
  final TextEditingController _lineWidthController =
      TextEditingController(text: 70.toString());
  final TextEditingController _lineColorController = TextEditingController();
  final TextEditingController _lineThicknessController =
      TextEditingController(text: 1.toString());

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
    return Tooltip(
      message: widget.translate!('Insert Line'),
      child: IconButton(
        icon: Icon(
          Icons.remove,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(widget.translate!('Insert Line')),
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
                                    return widget.translate!(
                                        'Thickness must be entered');
                                  }
                                  if (int.parse(s) >= 11) {
                                    return widget
                                            .translate!('Line Thickness must'
                                        ' be lower than 11');
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: widget.translate!('Enter Line '
                                        'Thickness'),
                                    labelText: widget.translate!('Thickness')),
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
                                    hintText: widget.translate!('Enter your '
                                        'width'),
                                    labelText: widget.translate!('Width')),
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
                                  child: Text(widget.translate!('Save'))),
                            ],
                          ),
                        ),
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
