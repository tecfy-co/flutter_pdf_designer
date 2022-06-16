part of flutter_pdf_designer;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../controller/main_controller.dart';
// import '../../models/data_model.dart';

class ImageElements extends StatefulWidget {
  void Function(PdfElement elements)? onSubmitted;
  final String Function(String val)? translate;

  ImageElements({Key? key, this.onSubmitted, this.translate}) : super(key: key);

  @override
  State<ImageElements> createState() => _ImageElementsState();
}

class _ImageElementsState extends State<ImageElements> {
  final TextEditingController _widthController =
      TextEditingController(text: 25.toString());
  final TextEditingController _heightController =
      TextEditingController(text: 25.toString());
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.translate!('Insert Image'),
      child: IconButton(
        icon: Icon(Icons.image, color: Theme.of(context).primaryColor),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return SimpleDialog(
                  title: Text(widget.translate!('Insert Image')),
                  children: [
                    Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
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
                                return widget.translate!('Width Must be '
                                    'Entered');
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            onFieldSubmitted: (String submittedText) {
                              // widget.onSubmitted!.call(submittedText);
                              // _textController.clear();
                            },
                            decoration: InputDecoration(
                              hintText: widget.translate!('Enter your width'),
                              labelText: widget.translate!('Width'),
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
                                return widget
                                    .translate!('Height Must be Entered');
                              }
                              return null;
                            },
                            textInputAction: TextInputAction.next,
                            enableSuggestions: true,
                            decoration: InputDecoration(
                              hintText: widget.translate!('Enter your Height'),
                              labelText: widget.translate!('Height'),
                              border: OutlineInputBorder(),
                            ),
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        MaterialButton(
                            color: Theme.of(context).primaryColor,
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                await FileService.pickFile().then((value) {
                                  setState(() {
                                    widget.onSubmitted?.call(
                                      PdfElement(
                                            type: PdfElementType.image,
                                            image: FileService.bytes,
                                            width: double.parse(
                                                _widthController.text),
                                            height: double.parse(
                                                _heightController.text)),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(widget.translate!(
                                                  'Image has been selected'))));
                                      _widthController.clear();
                                      _heightController.clear();
                                      Navigator.pop(context);
                                    });
                                  });
                                }
                              },
                              child: const Text('Browse Images ...')),
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
