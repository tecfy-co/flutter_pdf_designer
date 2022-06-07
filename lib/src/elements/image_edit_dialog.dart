part of flutter_pdf_designer;

class ImageEditDialog extends StatefulWidget {
  final PdfElement element;
  final void Function() onSubmitted;
  final void Function(PdfElement element) onDeleted;

  const ImageEditDialog(
      {Key? key,
      required this.element,
      required this.onSubmitted,
      required this.onDeleted})
      : super(key: key);

  @override
  State<ImageEditDialog> createState() => _ImageEditDialogState();
}

class _ImageEditDialogState extends State<ImageEditDialog> {
  final TextEditingController _widthController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    if (widget.element.width != null) {
      _widthController.text = widget.element.width!.toString();
    }
    if (widget.element.height != null) {
      _heightController.text = widget.element.height!.toString();
    }
    super.initState();
  }

  @override
  void dispose() {
    _heightController.dispose();
    _widthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Row(
        children: [
          const Text('Edit your image'),
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
                  hintText: 'Enter your Height',
                  labelText: 'Height',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await FileService.pickFile().then((value) {
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Image  has been selected')));
                          widget.element.image = FileService.bytes;
                        });
                      });
                    }
                  },
                  child: FileService.bytes != null
                      ? const Text('Change Image')
                      : const Text('Browse my '
                          'images ...')),
              const SizedBox(
                height: 20,
              ),
              MaterialButton(
                  color: Colors.blue,
                  onPressed: () {
                    if (formKey.currentState!.validate() &&
                        FileService.bytes != null) {
                      setState(() {
                        widget.element.image = FileService.bytes;
                        widget.element.width =
                            double.parse(_widthController.text);
                        widget.element.height =
                            double.parse(_heightController.text);
                      });
                      widget.onSubmitted.call();
                      Navigator.pop(context);
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
