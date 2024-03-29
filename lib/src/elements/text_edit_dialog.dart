part of flutter_pdf_designer;

class TextEditDialog extends StatefulWidget {
  final PdfElement element;
  final void Function() onSubmitted;
  final void Function(PdfElement element) onDeleted;
  final String Function(String val)? translate;

  const TextEditDialog({
    Key? key,
    required this.element,
    required this.onSubmitted,
    required this.onDeleted,
    this.translate,
  }) : super(key: key);

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
  List<String> dropdownItems = [
    'Center',
    'Top Center',
    'Bottom Center',
    'Top Left',
    'Center Left',
    'Bottom Left',
    'Center Right',
    'Top Right',
    'Bottom Right',
  ];

  String? selectedItem;

  void changeAlignFromText(element) {
    switch (selectedItem) {
      case 'Bottom Right':
        element.alignment = PdfAlign.bottomRight;
        break;
      case 'Center':
        element.alignment = PdfAlign.center;
        break;
      case 'Bottom Center':
        element.alignment = PdfAlign.bottomCenter;
        break;
      case 'Top Center':
        element.alignment = PdfAlign.topCenter;
        break;
      case 'Top Right':
        element.alignment = PdfAlign.topRight;
        break;
      case 'Center Right':
        element.alignment = PdfAlign.centerRight;
        break;
      case 'Center Left':
        element.alignment = PdfAlign.centerLeft;
        break;
      case 'Bottom Left':
        element.alignment = PdfAlign.bottomLeft;
        break;
      case 'Top Left':
        element.alignment = PdfAlign.topLeft;
        break;
      // default:
      //   element.alignment = PdfAlign.topLeft;
    }
  }

  String getCurrentAlignment(PdfAlign align) {
    switch (align) {
      case PdfAlign.bottomRight:
        return 'Bottom Right';
      case PdfAlign.center:
        return 'Center';

      case PdfAlign.bottomCenter:
        return 'Bottom Center';

      case PdfAlign.topCenter:
        return 'Top Center';

      case PdfAlign.topRight:
        return 'Top Right';

      case PdfAlign.centerRight:
        return 'Center Right';

      case PdfAlign.centerLeft:
        return 'Center Left';

      case PdfAlign.bottomLeft:
        return 'Bottom Left';

      case PdfAlign.topLeft:
        return 'Top Left';

      default:
        return 'Top Left';
    }
  }

  void changeColor(Color color) {
    setState(() => pickerColor = color);

    debugPrint('Change Color to ${pickerColor.value}');
  }

  @override
  void initState() {
    if (widget.element.text != null) {
      _textController.text = widget.element.text!;
    }
    if (widget.element.fontSize != null) {
      _fontSizeController.text = widget.element.fontSize!.toString();
    }
    if (widget.element.width != null) {
      _widthController.text = widget.element.width!.toString();
    }
    if (widget.element.height != null) {
      _heightController.text = widget.element.height!.toString();
    }
    pickerColor = Color(widget.element.color ?? 0xff000000);
    super.initState();
  }

  @override
  void dispose() {
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
      title: Row(
        children: [
          Text(widget.translate!('Edit your text')),
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
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Form(
            key: formKey,
            child: Column(children: [
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      autofocus: true,
                      controller: _textController,
                      keyboardType: TextInputType.text,
                      enableSuggestions: true,
                      validator: (s) {
                        if (s!.isEmpty) {
                          return widget.translate!('Text must be entered');
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        hintText: widget.translate!('Enter your text'),
                        labelText: widget.translate!('Text'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 1,
                    child: DropdownButtonFormField<String>(
                        items: dropdownItems
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: Text(item),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedItem = value!;
                          });
                        },
                        value: getCurrentAlignment(
                            widget.element.alignment ?? PdfAlign.topLeft),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: widget.translate!('Alignment'),
                        ),
                        validator: (s) {
                          if (s!.isEmpty) {
                            return widget
                                .translate!('Alignment must be entered');
                          }
                          return null;
                        }),
                  )
                ],
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
                          return widget.translate!('Font Size must be entered');
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                      enableSuggestions: true,
                      decoration: InputDecoration(
                        hintText: widget.translate!('Enter your font size'),
                        labelText: widget.translate!('Font Size'),
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
                        return widget.translate!('Width must be entered');
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: widget.translate!('Enter your Width'),
                      labelText: widget.translate!('Width'),
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
                        return widget.translate!('Height Must be Entered');
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.next,
                    enableSuggestions: true,
                    decoration: InputDecoration(
                      hintText: widget.translate!('Enter your Height'),
                      labelText: widget.translate!('Height'),
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
                  color: Theme.of(context).primaryColor,
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        changeAlignFromText(widget.element);

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
                  child: Text(widget.translate!('Save'))),
            ]),
          ),
        ),
      ],
    );
  }
}
