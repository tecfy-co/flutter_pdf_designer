part of flutter_pdf_designer;

class PdfInsertWidgets extends StatefulWidget {
  final Map<String, dynamic> json;
  final List<PdfDynamicField> variableList;
  final void Function(Map<String, dynamic>) onChange;
  final InputBorder? textFieldBorder;
  final String? heightLabel;
  final String? widthLabel;

  const PdfInsertWidgets({
    Key? key,
    required this.json,
    required this.variableList,
    required this.onChange,
    this.textFieldBorder,
    this.heightLabel,
    this.widthLabel,
  }) : super(key: key);

  @override
  _PdfInsertWidgetsState createState() => _PdfInsertWidgetsState();
}

class _PdfInsertWidgetsState extends State<PdfInsertWidgets> {
  late PdfModel dataModel;

  @override
  void initState() {
    dataModel = PdfModel.fromJson(widget.json);
    if (widget.json['elements'] == null || dataModel.elements == null) {
      print('elements = null');
      dataModel.elements = [];
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(children: [
            SizedBox(
              width: 140,
              height: 50,
              child: TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                initialValue: dataModel.height!.toStringAsFixed(1),
                onFieldSubmitted: (v) {
                  setState(() {
                    if (v.isNotEmpty) {
                      dataModel.height = double.parse(v);
                      widget.onChange.call(dataModel.toJson());
                    }
                  });
                },
                decoration: InputDecoration(
                    // isDense: true,                      // Added this
                    // contentPadding: EdgeInsets.all(14),
                    border: widget.textFieldBorder,
                    labelText: widget.heightLabel),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              width: 170,
              height: 50,
              child: TextFormField(
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  initialValue: dataModel.width?.toStringAsFixed(1),
                  onFieldSubmitted: (v) {
                    setState(() {
                      if (v.isNotEmpty) {
                        dataModel.width = double.parse(v);
                        widget.onChange.call(dataModel.toJson());
                      }
                    });
                  },
                  decoration: InputDecoration(
                      border: widget.textFieldBorder,
                      labelText: widget.widthLabel)),
            ),
            const SizedBox(width: 10),
          ]),
          Wrap(
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 10, top: 15),
                  child: TextElement(
                      titleDialog: 'Enter your Text',
                      outlineBtnName: 'Text'
                          '',
                      onSubmitted: (elm) {
                        setState(() {
                          dataModel.elements?.add(elm);
                          widget.onChange(dataModel.toJson());
                        });
                      })),
              Padding(
                  padding: const EdgeInsets.only(right: 10, top: 15),
                  child: ImageElements(
                      titleDialog: 'Add your Images',
                      outlineBtnName: 'Im'
                          'age',
                      onSubmitted: (elm) {
                        setState(() {
                          dataModel.elements?.add(elm);
                          widget.onChange(dataModel.toJson());
                        });
                      })),
              Padding(
                  padding: const EdgeInsets.only(right: 10, top: 15),
                  child: LineElement(
                    titleDialog: 'Add your Lines',
                    outlineBtnName: 'Line',
                    onSubmitted: (elm) {
                      setState(() {
                        dataModel.elements?.add(elm);
                        widget.onChange(dataModel.toJson());
                      });
                    },

                    ///
                    lineWidth: dataModel.width!,
                  )),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                    width: 170,
                    child: DropdownSearch<String>(
                      popupProps: const PopupProps.menu(
                        showSelectedItems: true,
                        showSearchBox: false,
                      ),
                      items: widget.variableList.map((e) => e.name).toList(),
                      dropdownSearchDecoration: InputDecoration(
                        border: widget.textFieldBorder,
                        isDense: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: "Components",
                        hintText: "Components",
                        labelStyle: TextStyle(fontSize: 12),
                        hintStyle: TextStyle(fontSize: 12),
                      ),
                      onChanged: (s) {
                        for (var element in widget.variableList) {
                          if (element.name == s &&
                              element.type == PdfElementType.text) {
                            debugPrint('-------Adding[ Text ]to your '
                                'Model--------');
                            setState(() {
                              dataModel.elements?.add(PdfElement.text(
                                  type: PdfElementType.text,
                                  text: element.designValue,
                                  dynamicFieldKey: element.key,
                                  fontSize: element.key == 'date' ||
                                          element.key == 'price'
                                      ? 4
                                      : 8,
                                  width: element.key == 'date' ||
                                          element.key == 'price'
                                      ? 20
                                      : 50,
                                  height: element.key == 'date' ||
                                          element.key == 'price'
                                      ? 10
                                      : 50,
                                  color: 1099494850560,
                                  alignment: PdfAlign.topLeft));
                              widget.onChange(dataModel.toJson());
                            });
                          }
                          if (element.name == s &&
                              element.type == PdfElementType.image) {
                            debugPrint('-------Adding[ Image ]to your '
                                'Model--------');
                            setState(() {
                              dataModel.elements?.add(PdfElement.image(
                                type: PdfElementType.image,
                                image: null,
                                dynamicFieldKey: element.key,
                              ));
                              widget.onChange(dataModel.toJson());
                            });
                          }
                          if (element.name == s &&
                              element.type == PdfElementType.barcode) {
                            debugPrint('-------Adding[ Barcode ]to your '
                                'Model--------');
                            setState(() {
                              dataModel.elements?.add(PdfElement(
                                  type: PdfElementType.barcode,
                                  text: 'your barcode',
                                  dynamicFieldKey: element.key,
                                  width: 50,
                                  height: 50,
                                  color: 1099494850560,
                                  fontSize: 4,
                                  barcode: BarcodeType.Code128));
                              widget.onChange(dataModel.toJson());
                            });
                          }
                        }
                      },
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}