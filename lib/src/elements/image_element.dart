part of flutter_pdf_designer;

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
//
// import '../../controller/main_controller.dart';
// import '../../models/data_model.dart';

class ImageElements extends StatefulWidget {
  final String titleDialog;
  final String outlineBtnName;
  void Function(PdfElement elements)? onSubmitted;
  ImageElements(
      {Key? key,
      required this.titleDialog,
      required this.outlineBtnName,
      this.onSubmitted})
      : super(key: key);

  @override
  State<ImageElements> createState() => _ImageElementsState();
}

class _ImageElementsState extends State<ImageElements> {
  final TextEditingController _widthController =
      TextEditingController(text: 50.toString());
  final TextEditingController _heightController =
      TextEditingController(text: 50.toString());
  var formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _widthController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all(Theme.of(context).primaryColor),
      ),
      onPressed: () {
        showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                title: Text(widget.titleDialog),
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
                            hintText: 'Enter your Height',
                            labelText: 'Height',
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
                                    widget.onSubmitted!.call(
                                      PdfElement(
                                          type: PdfElementType.image,
                                          image: FileService.bytes,
                                          width: double.parse(
                                              _widthController.text),
                                          height: double.parse(
                                              _heightController.text)),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Image has been selected')));
                                    _widthController.clear();
                                    _heightController.clear();
                                    Navigator.pop(context);
                                  });
                                });
                              }
                            },
                            child: const Text('Browse my images ...')),
                      ]),
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
