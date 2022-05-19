part of flutter_pdf_designer;

class TextElement extends StatefulWidget {
  final String titleDialog;
  final String outlineBtnName;
  void Function(Elements elements)? onSubmitted;
   TextElement(
      {Key? key, required this.titleDialog, required this.outlineBtnName,
  this.onSubmitted})
      : super(key: key);

  @override
  State<TextElement> createState() => _TextElementState();
}

class _TextElementState extends State<TextElement> {
  var formKey= GlobalKey<FormState>();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _fontSizeController = TextEditingController
    (text: 25.toString());
  final TextEditingController _fontColorController = TextEditingController();

  Color pickerColor = const Color(0xff000000);
  Color currentColor = const Color(0xff000000);
  dynamic selectedColor;

  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }
  @override
  void dispose(){
    _textController.dispose();
    _fontSizeController.dispose();
    _fontColorController.dispose();
    super.dispose();

  }

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
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Form(
                      key: formKey ,
                      child: Column(children: [
                        TextFormField(
                          autofocus: true,
                          controller: _textController,
                          keyboardType: TextInputType.text,
                          enableSuggestions: true,
                          validator: (s){
                            if(s!.isEmpty){
                              return 'Text must be entered';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          onFieldSubmitted: (String submittedText) {
                            // widget.onSubmitted!.call(submittedText);
                            // _textController.clear();
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your text here',
                            labelText: 'Text',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextFormField(
                          autofocus: true,
                          controller: _fontSizeController,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: (s){
                            if(s!.isEmpty){
                              return 'Font Size Must be Entered';
                            }
                          },
                          textInputAction: TextInputAction.next,
                          enableSuggestions: true,
                          onFieldSubmitted: (String submittedText, [size]) {
                            // widget.onSubmitted!.call(submittedText,data: [size]);
                            // _textController.clear();
                            // _fontSizeController.clear();
                          },
                          onEditingComplete: () {
                            print('OnEditingComplete');
                          },
                          decoration: const InputDecoration(
                            hintText: 'Enter your font size',
                            labelText: 'Font Size',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ColorPicker(
                          hexInputController: _fontColorController,
                          onHsvColorChanged: (color){
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
                            color: Colors.blue,
                            onPressed: () {
                              if(formKey.currentState!.validate()){
                                setState(() {
                                  print("Font Color =  "
                                      "${_fontColorController
                                      .text}");
                                  widget.onSubmitted!.call(Elements(type:
                                  WidgetType.text,
                                      text: _textController.text,
                                      fontSize: double.parse(_fontSizeController
                                          .text),
                                      color: selectedColor));
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
                            child: Text('Save')),
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
