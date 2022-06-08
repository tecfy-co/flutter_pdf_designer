part of flutter_pdf_designer;

class BarcodeEditDialog extends StatefulWidget {
  final PdfElement element;
  final void Function() onSubmitted;
  final void Function(PdfElement element) onDeleted;

  const BarcodeEditDialog(
      {Key? key,
      required this.element,
      required this.onSubmitted,
      required this.onDeleted})
      : super(key: key);

  @override
  State<BarcodeEditDialog> createState() => _BarcodeEditDialogState();
}

class _BarcodeEditDialogState extends State<BarcodeEditDialog> {
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _lineColorController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController();

  var formKey = GlobalKey<FormState>();
  late Barcode barcode;
  BarcodeConf conf = BarcodeConf();

  Color pickerColor = const Color(0xff000000);
  dynamic selectedColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  @override
  void initState() {
    // _textController.text = widget.element.text!;
    if (widget.element.text != null) {
      conf.data = widget.element.text!;
    }
    if (widget.element.width != null) {
      _widthController.text = widget.element.width!.toString();
    }
    if (widget.element.height != null) {
      _heightController.text = widget.element.height!.toString();
    }
    if (widget.element.fontSize != null) {
      _fontSizeController.text = widget.element.fontSize!.toString();
    }
    if (widget.element.color != null) {
      pickerColor = Color(widget.element.color);
    }
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    _lineColorController.dispose();
    _heightController.dispose();
    _widthController.dispose();
    _fontSizeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final types = <BarcodeType, String>{};
    for (var item in BarcodeType.values) {
      types[item] = Barcode.fromType(item).name;
    }
    return SimpleDialog(
      title: Row(
        children: [
          const Text('Edit your barcode'),
          const Spacer(),
          IconButton(
            onPressed: () {
              widget.onDeleted.call(widget.element);
            },
            icon: const Icon(Icons.delete_forever),
          ),
        ],
      ),
      children: [
        Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(children: [
              TextFormField(
                autofocus: true,
                controller: _widthController,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                enableSuggestions: true,
                validator: (s) {
                  if (s!.isEmpty) {
                    return 'Width must be entered';
                  }
                  return null;
                },
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (String submittedText) {
                  // widget.onSubmitted!.call(submittedText);
                  // _textController.clear();
                },
                decoration: const InputDecoration(
                  hintText: 'Enter your Width',
                  labelText: 'Width',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
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
                  hintText: 'Enter your height',
                  labelText: 'Height',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              DropdownPreference<BarcodeType>(
                title: 'Barcode Type',
                onRead: (context) => conf.type,
                onWrite: (context, dynamic value) => setState(() {
                  conf.type = value;
                }),
                values: types,
              ),
              TextPreference(
                conf: conf,
                title: 'Data',
                onRead: (context) => conf.data,
                onWrite: (context, value) => conf.data = value,
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
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
              const SizedBox(
                height: 20,
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
                enableAlpha: false,
                portraitOnly: true,
                pickerAreaHeightPercent: 0.24,
                displayThumbColor: true,
              ),
              MaterialButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        // widget.element.text = _textController.text;
                        widget.element.text = conf.data;
                        widget.element.barcode = conf.type;
                        widget.element.width =
                            double.parse(_widthController.text);
                        widget.element.height =
                            double.parse(_heightController.text);
                        widget.element.fontSize =
                            double.parse(_fontSizeController.text);
                        if (selectedColor != null) {
                          widget.element.color = selectedColor;
                        }

                        widget.onSubmitted.call();
                      });
                    }
                    Navigator.pop(context);
                  },
                  child: const Text('Save')),
            ]),
          ),
        ),
      ],
    );
  }
}
