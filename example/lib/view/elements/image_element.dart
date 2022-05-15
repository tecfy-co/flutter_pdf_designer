import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../controller/main_controller.dart';
import '../../models/data_model.dart';

class ImageElements extends StatefulWidget {
  final String titleDialog;
  final String outlineBtnName;
  void Function(Elements elements)? onSubmitted;
   ImageElements({Key? key, required this.titleDialog, required this
      .outlineBtnName,this.onSubmitted}) : super(key: key);

  @override
  State<ImageElements> createState() => _ImageElementsState();
}

class _ImageElementsState extends State<ImageElements> {

  TextEditingController _widthController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  var formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: () {
      showDialog(
          context: context,
          builder: (context) {
            return SimpleDialog(
              title: Text(widget.titleDialog),
              children: [
                Form(
                  key: formKey ,
                  child: Column(children: [
                    TextFormField(
                      autofocus: true,
                      controller: _widthController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      enableSuggestions: true,
                      validator: (s){
                        if(s!.isEmpty){
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
                      validator: (s){
                        if(s!.isEmpty){
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
                          if(formKey.currentState!.validate()) {
                            await MainController.pickFile().then((value) {
                              setState(() {

                                widget.onSubmitted!.call(Elements(type:
                                WidgetType.image, image: MainController.bytes,
                                    width: double.parse(_widthController
                                        .text),height: double.parse
                                      (_heightController.text)),);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar
                                  (content: Text('Image ${MainController.file
                                !.path} has been selected')));
                               _widthController.clear();
                               _heightController.clear();
                                Navigator.pop(context);
                              });

                            });
                          }

                    },
                    child: const Text('Browse my images ...')),
                    // MaterialButton(
                    //     color: Colors.blue,
                    //     onPressed: () {
                    //       if(formKey.currentState!.validate()){
                    //         setState(() {
                    //           print("Font Color =  "
                    //               "${_fontColorController
                    //               .text}");
                    //           widget.onSubmitted!.call(Elements(type:
                    //           WidgetType.text,
                    //               text: _textController.text,
                    //               fontSize: double.parse(_fontSizeController
                    //                   .text),
                    //               color: selectedColor));
                    //         });
                    //       }
                    //       // widget.onSubmitted!.call(_textController.text,data:
                    //       // double.parse(_fontSizeController.text));
                    //       // setState(() {
                    //       //   widget.onSubmitted!.call(_textController.text,
                    //       //       data: double.parse(_fontSizeController.text));
                    //       //   _textController.clear();
                    //       //   _fontSizeController.clear();
                    //       Navigator.pop(context);
                    //     },
                    //     child: Text('Save')),
                  ]),
                ),

            //     OutlinedButton(
            //     onPressed: () async {
            //   await MainController.pickFile().then((value) {
            //     setState(() {
            //       widget.onSubmitted.call(Elements.image(type: WidgetType.image,image:MainController.bytes, ));
            //       // widget.onSubmitted!
            //       //     .call(MainController.bytes);
            //       Navigator.pop(context);
            //     });
            //   });
            // },
            // child: const Text('Browse my images ...')),
              ],
            );

          });
        },
      child: Text(widget.outlineBtnName),
    );
      }
  }

