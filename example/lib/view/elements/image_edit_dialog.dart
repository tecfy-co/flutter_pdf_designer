import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:generate_receipt/controller/main_controller.dart';

import '../../models/data_model.dart';

class ImageEditDialog extends StatefulWidget {
  final Elements element;
  final void Function() onSubmitted;
  const ImageEditDialog(
      {Key? key, required this.element, required this.onSubmitted})
      : super(key: key);

  @override
  State<ImageEditDialog> createState() => _ImageEditDialogState();
}

class _ImageEditDialogState extends State<ImageEditDialog> {
  TextEditingController _widthController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _widthController.text = widget.element.width!.toString();
    _heightController.text = widget.element.height!.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Edit your Image'),
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
                  hintText: 'Enter your font size',
                  labelText: 'Font Size',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              OutlinedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      await MainController.pickFile().then((value) {
                        setState(() {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  'Image ${MainController.file!.path} has been selected')));
                          widget.element.image = MainController.bytes;
                        });
                      });
                    }
                  },
                  child: MainController.bytes != null
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
                        MainController.bytes != null) {
                      setState(() {
                        widget.element.image = MainController.bytes;
                        widget.element.width =
                            double.parse(_widthController.text);
                        widget.element.height =
                            double.parse(_heightController.text);
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
