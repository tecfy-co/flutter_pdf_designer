part of flutter_pdf_designer;

class PdfInsertWidgets extends StatefulWidget {
  final Map<String, dynamic> json;
  final List<PdfDynamicField> dynamicVariableList;
  final void Function(Map<String, dynamic>) onChange;
  final InputBorder? textFieldBorder;
  final String? heightLabel;
  final String? widthLabel;
  final String? textBtnTooltipMessage;
  final String? imageBtnTooltipMessage;
  final String? lineBtnTooltipMessage;
  final String? dropdownLabel;

  const PdfInsertWidgets({
    Key? key,
    required this.json,
    required this.dynamicVariableList,
    required this.onChange,
    this.textFieldBorder,
    this.heightLabel,
    this.widthLabel,
    this.textBtnTooltipMessage = 'Insert Text',
    this.imageBtnTooltipMessage = 'Insert Image',
    this.lineBtnTooltipMessage = 'Insert Line',
    this.dropdownLabel = 'Components',
  }) : super(key: key);

  @override
  _PdfInsertWidgetsState createState() => _PdfInsertWidgetsState();
}

class _PdfInsertWidgetsState extends State<PdfInsertWidgets> {
  late PdfModel dataModel;
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _widthController = TextEditingController();

  @override
  void initState() {
    dataModel = PdfModel.fromJson(widget.json);
    if (widget.json['elements'] == null || dataModel.elements == null) {
      print('elements = null');
      dataModel.elements = [];
    }
    _heightController.text = dataModel.height!.toStringAsFixed(1);
    _widthController.text = dataModel.width!.toStringAsFixed(1);

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
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 140,
              height: 50,
              child: TextFormField(
                controller: _heightController,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                onTap: () => _heightController.selection = TextSelection(
                    baseOffset: 0,
                    extentOffset: _heightController.value.text.length),
                onChanged: (v) {
                  setState(() {
                    dataModel.height = double.parse(v);
                    widget.onChange.call(dataModel.toJson());
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
                  controller: _widthController,
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+\.?\d{0,2}')),
                  ],
                  onTap: () => _widthController.selection = TextSelection(
                      baseOffset: 0,
                      extentOffset: _widthController.value.text.length),
                  onChanged: (v) {
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
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 10, top: 15),
                  child: TextElement(
                      tooltipMessage: widget.textBtnTooltipMessage!,
                      onSubmitted: (elm) {
                        setState(() {
                          dataModel.elements?.add(elm);
                          widget.onChange(dataModel.toJson());
                        });
                      })),
              Padding(
                  padding: const EdgeInsets.only(right: 10, top: 15),
                  child: ImageElements(
                      tooltipMessage: widget.imageBtnTooltipMessage!,
                      onSubmitted: (elm) {
                        setState(() {
                          dataModel.elements?.add(elm);
                          widget.onChange(dataModel.toJson());
                        });
                      })),
              Padding(
                  padding: const EdgeInsets.only(right: 10, top: 15),
                  child: LineElement(
                    tooltipMessage: widget.lineBtnTooltipMessage!,
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
                      items: widget.dynamicVariableList
                          .map((e) => e.name)
                          .toList(),
                      dropdownSearchDecoration: InputDecoration(
                        border: widget.textFieldBorder,
                        isDense: true,
                        contentPadding: EdgeInsets.all(15),
                        labelText: widget.dropdownLabel,
                        labelStyle: TextStyle(fontSize: 12),
                      ),
                      onChanged: (s) {
                        for (var element in widget.dynamicVariableList) {
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
                                      : 6,
                                  width: element.key == 'date' ||
                                      element.key == 'price'
                                      ? 20
                                      : 40,
                                  height: element.key == 'date' ||
                                      element.key == 'price'
                                      ? 10
                                      : 15,
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
                                  height: 20,
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
