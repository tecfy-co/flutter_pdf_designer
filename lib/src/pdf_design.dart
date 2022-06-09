part of flutter_pdf_designer;

class PdfDesign extends StatefulWidget {
  final List<PdfDynamicField>? variableList;

  /// Printing Width in inches
  final double? width;

  /// Printing Height in inches
  final double? height;

  final double? heightScale;

  final Alignment? alignment;

  final Map<String, dynamic>? json;

  final void Function(Map<String, dynamic>) onChange;

  final bool showTextFields;

  final bool showDropDownMenu;

  final bool showInsertBtns;

  final bool disableDrag;

  const PdfDesign({
    Key? key,
    required this.onChange,
    required this.json,
    this.width,
    this.height,
    this.alignment = Alignment.topLeft,
    this.heightScale = 1.0,
    this.variableList,
    this.showTextFields = true,
    this.showDropDownMenu = true,
    this.showInsertBtns = true,
    this.disableDrag = false,
  }) : super(key: key);

  @override
  State<PdfDesign> createState() => _PdfDesignState();
}

class _PdfDesignState extends State<PdfDesign> {
  late PdfModel dataModel;
  bool isDoubleTap = false;
  GlobalKey containerKey = GlobalKey();

  Alignment getAlignment(PdfAlign align) {
    switch (align) {
      case PdfAlign.bottomRight:
        return Alignment.bottomRight;
      case PdfAlign.center:
        return Alignment.center;

      case PdfAlign.bottomCenter:
        return Alignment.bottomCenter;

      case PdfAlign.topCenter:
        return Alignment.topCenter;

      case PdfAlign.topRight:
        return Alignment.topRight;

      case PdfAlign.centerRight:
        return Alignment.centerRight;

      case PdfAlign.centerLeft:
        return Alignment.centerLeft;

      case PdfAlign.bottomLeft:
        return Alignment.bottomLeft;

      case PdfAlign.topLeft:
        return Alignment.topLeft;

      default:
        return Alignment.topLeft;
    }
  }

  void setWidgetOverStack(dragDetails, e) {
    //To know current position for containerKey

    final keyContext = containerKey.currentContext;
    debugPrint(e.key.toString());
    if (keyContext != null) {
      // widget is visible
      final box = keyContext.findRenderObject() as RenderBox;
      final pos = box.localToGlobal(Offset.zero);
      e.xPosition = dragDetails.offset.dx - pos.dx;
      // We need to remove offsets like app/status bar from Y
      e.yPosition = dragDetails.offset.dy - pos.dy;

      if (e.xPosition < 0) {
        e.xPosition = 0.0;
      }
      if (e.yPosition < 0) {
        e.yPosition = 0.0;
      }

      final widgetKeyContext = e.key.currentContext;
      //  debugPrint('KeyContext = $widgetKeyContext');
      if (widgetKeyContext != null) {
        final imageBox = widgetKeyContext.findRenderObject() as RenderBox;

        final imagePos = imageBox.localToGlobal(Offset.zero);
        if (e.xPosition + imageBox.size.width > box.size.width) {
          debugPrint('Widget width ${imageBox.size.width}');
          debugPrint('+++++ Widget ${e.xPosition} -> change '
              'to ${box.size.width - imageBox.size.width} ');
          e.xPosition = (box.size.width - imageBox.size.width);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Out of the box')));
        }
        if (e.yPosition + imageBox.size.height > box.size.height) {
          e.yPosition = (box.size.height - imageBox.size.height);
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Out of the box')));
        }
        debugPrint('---Widget Position  ='
            ' $imagePos');
        // debugPrint('Stack Position = $pos ');
      }
    }
  }

  double? flexWidth;
  double? flexHeight;
  double? scale;

  void initializeScale(BoxConstraints constraints, PdfModel dataModel) {
    if ((constraints.maxWidth / constraints.maxHeight) >
        (dataModel.width! / (dataModel.height! * widget.heightScale!))) {
      flexHeight = constraints.maxHeight;
      flexWidth = (dataModel.width! * constraints.maxHeight) /
          (dataModel.height! * widget.heightScale!);
      scale = (dataModel.width! * PdfPageFormat.inch) / (flexWidth!);
    } else {
      flexWidth = constraints.maxWidth;
      flexHeight =
          ((dataModel.height! * widget.heightScale!) * constraints.maxWidth) /
              dataModel.width!;
    }
    scale = flexWidth! / (dataModel.width! * PdfPageFormat.inch);
  }

  void onChange() {
    widget.onChange({});
  }

  @override
  void initState() {
    dataModel = PdfModel.fromJson(widget.json!);
    if (widget.json?['elements'] == null || dataModel.elements == null) {
      dataModel.elements = [];
    }
    if (widget.width != null) {
      dataModel.width = widget.width;
    }
    if (widget.height != null) {
      dataModel.height = widget.height;
    }
    print(widget.variableList == null);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.showTextFields)
          Row(children: [
            Expanded(
                child: TextFormField(
                    inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                    initialValue: dataModel.height!.toStringAsFixed(1),
                    onChanged: (v) {
                      setState(() {
                        if (v.isEmpty) {
                          dataModel.height = 1.0;
                        }
                        if (v.isNotEmpty) {
                          var number = double.parse(v);
                          dataModel.height = number;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                        label: Text('Label Height (inch)')))),
            const SizedBox(width: 10),
            Expanded(
                child: TextFormField(
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}')),
                    ],
                    initialValue: dataModel.width?.toStringAsFixed(1),
                    onChanged: (v) {
                      setState(() {
                        if (v.isEmpty) {
                          dataModel.width = 1.0;
                        }
                        if (v.isNotEmpty) {
                          var number = double.parse(v);
                          dataModel.width = number;
                        }
                      });
                    },
                    decoration: const InputDecoration(
                        label: Text('Label Width (inch)')))),
            const SizedBox(width: 10),
          ]),
        Wrap(
          children: [
            if (widget.showInsertBtns)
              Row(
                children: <Widget>[
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
                ],
              ),
            if (widget.showDropDownMenu && widget.variableList != null)
              SizedBox(
                  width: 150,
                  child: DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      showSelectedItems: true,
                      showSearchBox: false,
                    ),
                    items: widget.variableList!.map((e) => e.name).toList(),
                    dropdownSearchDecoration: const InputDecoration(
                      labelText: "Your Components",
                      hintText: "Components",
                      labelStyle: TextStyle(fontSize: 12),
                    ),
                    onChanged: (s) {
                      for (var element in widget.variableList!) {
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
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxHeight == double.infinity) {
                return const Text('Height is not constrained');
              }
              initializeScale(constraints, dataModel);
              print(constraints);
              return Align(
                  alignment: widget.alignment!,
                  child: Container(
                    key: containerKey,
                    decoration: BoxDecoration(border: Border.all()),
                    height: flexHeight,
                    width: flexWidth,
                    child: Stack(
                      children: dataModel.elements != null
                          ? dataModel.elements!.map<Widget>((e) {
                              switch (e.type) {
                                case PdfElementType.text:
                                  {
                                    return Positioned(
                                      left: e.xPosition > 0
                                          ? e.xPosition * scale!
                                          : e.xPosition,
                                      top: e.yPosition > 0
                                          ? e.yPosition * scale!
                                          : e.yPosition,
                                      child: widget.disableDrag == false
                                    ? Draggable(
                                        onDragEnd: (dragDetails) {
                                          setState(() {
                                            setWidgetOverStack(dragDetails, e);
                                            e.xPosition /= scale!;
                                            e.yPosition /= scale!;
                                            widget.onChange(dataModel.toJson());
                                          });
                                        },
                                        feedback: Material(
                                            child: Container(
                                                width: (e.width ?? 25) * scale!,
                                          height: (e.height ?? 25) * scale!,
                                          alignment: getAlignment(
                                              e.alignment ?? PdfAlign.center),
                                          color: Color(e.color ?? 0xffFF000000)
                                              .withOpacity(0.3),
                                          child: Text(
                                            e.text ?? '-',
                                            key: e.key,
                                            style: TextStyle(
                                                fontSize: ((e.fontSize ?? 8) *
                                                    scale!),
                                                color: Color(
                                                    e.color ?? 0xffFF000000)),
                                            // key: GlobalObjectKey(e.text ?? ''),
                                          ))),
                                  childWhenDragging: const SizedBox(),
                                  child: InkWell(
                                    onDoubleTap: () {
                                      setState(() {
                                        isDoubleTap = !isDoubleTap;
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return TextEditDialog(
                                                element: e,
                                                onDeleted: (e) {
                                                  dataModel.elements!.remove(e);
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    widget.onChange(
                                                        dataModel.toJson());
                                                  });
                                                },
                                                onSubmitted: () {
                                                  setState(() {
                                                    widget.onChange(
                                                        dataModel.toJson());
                                                  });
                                                },
                                              );
                                            });

                                        debugPrint(
                                            ' Double Tap = $isDoubleTap');
                                      });
                                    },
                                    child: Container(
                                      color: Color(e.color ?? 0xffFF000000)
                                          .withOpacity(0.2),
                                      width: (e.width ?? 25) * scale!,
                                      height: (e.height ?? 25) * scale!,
                                      alignment: getAlignment(
                                          e.alignment ?? PdfAlign.center),
                                      child: Text(
                                              e.text ?? '-',
                                              key: e.key,
                                              style: TextStyle(
                                                  fontSize: (e.fontSize ?? 8) *
                                                      scale!,
                                                  color: Color(
                                                      e.color ?? 0xffFF000000)),
                                            ),
                                          ),
                                        ),
                                      )
                                    : Container(
                                        width: (e.width ?? 25) * scale!,
                                        height: (e.height ?? 25) * scale!,
                                        alignment: getAlignment(
                                            e.alignment ?? PdfAlign.center),
                                        child: Text(
                                          e.text ?? '-',
                                          key: e.key,
                                          style: TextStyle(
                                              fontSize:
                                                  (e.fontSize ?? 8) * scale!,
                                              color: Color(
                                                  e.color ?? 0xffFF000000)),
                                        ),
                                      ),
                              );
                            }
                          case PdfElementType.image:
                            {
                              return Positioned(
                                left: e.xPosition > 0
                                    ? e.xPosition * scale!
                                    : e.xPosition,
                                top: e.yPosition > 0
                                    ? e.yPosition * scale!
                                    : e.yPosition,
                                child: widget.disableDrag == false
                                    ? Draggable(
                                        feedback: e.image != null
                                            ? Image.memory(
                                                Uint8List.fromList(e.image!),
                                                width: (e.width ?? 25) * scale!,
                                                height:
                                                    (e.height ?? 25) * scale!,
                                              )
                                            : Material(
                                                child: Container(
                                                  color: Colors.red,
                                                  width: 100,
                                                  height: 100,
                                            child: const Center(
                                              child: Text('YourLogoHere!'),
                                            ),
                                          ),
                                        ),
                                  onDragEnd: (dragDetails) {
                                    setState(() {
                                      setWidgetOverStack(dragDetails, e);
                                      e.xPosition /= scale!;
                                      e.yPosition /= scale!;
                                      widget.onChange(dataModel.toJson());
                                    });
                                  },
                                  child: InkWell(
                                    onDoubleTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return ImageEditDialog(
                                                element: e,
                                                onDeleted: (e) {
                                                  dataModel.elements!.remove(e);
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    widget.onChange(
                                                        dataModel.toJson());
                                                  });
                                                },
                                                onSubmitted: () {
                                                  setState(() {
                                                    widget.onChange(
                                                        dataModel.toJson());
                                                  });
                                                });
                                          });
                                    },
                                    child: e.image != null
                                        ? Image.memory(
                                      Uint8List.fromList(e.image!),
                                                  key: e.key,
                                                  // fit: BoxFit.contain,
                                                  width:
                                                      (e.width ?? 25) * scale!,
                                                  height:
                                                      (e.height ?? 25) * scale!,
                                                )
                                        : Material(
                                            child: Container(
                                                    key: e.key,
                                                    color: Colors.red,
                                                    width: 100,
                                                    height: 100,
                                                    child: const Center(
                                                      child:
                                                          Text('YourLogoHere!'),
                                                    ),
                                                  ),
                                                ),
                                        ),
                                      )
                                    : e.image != null
                                        ? Image.memory(
                                            Uint8List.fromList(e.image!),
                                            key: e.key,
                                            // fit: BoxFit.contain,
                                            width: (e.width ?? 25) * scale!,
                                            height: (e.height ?? 25) * scale!,
                                          )
                                        : Material(
                                            child: Container(
                                              key: e.key,
                                              color: Colors.red,
                                              width: 100,
                                              height: 100,
                                              child: const Center(
                                                child: Text('YourLogoHere!'),
                                              ),
                                            ),
                                          ),
                              );
                            }
                          case PdfElementType.line:
                            {
                              return Positioned(
                                left: e.xPosition > 0
                                    ? e.xPosition * scale!
                                    : e.xPosition,
                                top: e.yPosition > 0
                                    ? e.yPosition * scale!
                                    : e.yPosition,
                                child: widget.disableDrag == false
                                    ? Draggable(
                                        feedback: Container(
                                          color: Color(e.color ?? 0xffFF000000),
                                          width: (e.width ?? 25) * scale!,
                                          height: (e.height ?? 25) * scale!,
                                        ),
                                        onDragEnd: (dragDetails) {
                                          setState(
                                            () {
                                              setWidgetOverStack(
                                                  dragDetails, e);
                                              e.xPosition /= scale!;
                                              e.yPosition /= scale!;
                                        widget.onChange(dataModel.toJson());
                                      },
                                    );
                                  },
                                  child: InkWell(
                                    onDoubleTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return LineEditDialog(
                                                element: e,
                                                onDeleted: (e) {
                                                  dataModel.elements!.remove(e);
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    widget.onChange(
                                                        dataModel.toJson());
                                                  });
                                                },
                                                onSubmitted: () {
                                                  setState(() {
                                                    widget.onChange(
                                                        dataModel.toJson());
                                                  });
                                                });
                                          });
                                          },
                                          child: Container(
                                            key: e.key,
                                            color:
                                                Color(e.color ?? 0xffFF000000),
                                            height: (e.width! /
                                                    PdfPageFormat.inch) *
                                                scale!,
                                            width: (e.width! /
                                                    PdfPageFormat.inch) *
                                                scale!,
                                          ),
                                        ),
                                      )
                                    : Container(
                                        key: e.key,
                                        color: Color(e.color ?? 0xffFF000000),
                                        height:
                                            (e.width! / PdfPageFormat.inch) *
                                                scale!,
                                        width: (e.width! / PdfPageFormat.inch) *
                                            scale!,
                                      ),
                              );
                            }
                          case PdfElementType.barcode:
                            {
                              return Positioned(
                                left: e.xPosition > 0
                                    ? e.xPosition * scale!
                                    : e.xPosition,
                                top: e.yPosition > 0
                                    ? e.yPosition * scale!
                                    : e.yPosition,
                                key: e.key,
                                child: widget.disableDrag == false
                                    ? Draggable(
                                        feedback: Material(
                                          child: BarcodeWidget(
                                            data: e.text ?? "Barcode Data",
                                            barcode:
                                                Barcode.fromType(e.barcode!),
                                            color:
                                                Color(e.color ?? 0xffFF000000),
                                            width: (e.width ?? 25) * scale!,
                                            height: (e.height ?? 25) * scale!,
                                            style: TextStyle(
                                              fontSize:
                                                  (e.fontSize ?? 10) * scale!,
                                            ),
                                            errorBuilder: (context, string) {
                                        return Container(
                                          child: Text(string),
                                        );
                                      },
                                    ),
                                  ),
                                  onDragEnd: (dragDetails) {
                                    setState(() {
                                      setWidgetOverStack(dragDetails, e);
                                      e.xPosition /= scale!;
                                      e.yPosition /= scale!;
                                      widget.onChange(dataModel.toJson());
                                    });
                                  },
                                  child: InkWell(
                                    onDoubleTap: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return BarcodeEditDialog(
                                                element: e,
                                                onDeleted: (e) {
                                                  dataModel.elements!.remove(e);
                                                  setState(() {
                                                    Navigator.pop(context);
                                                    widget.onChange(
                                                        dataModel.toJson());
                                                  });
                                                },
                                                onSubmitted: () {
                                                  setState(() {
                                                    widget.onChange(
                                                        dataModel.toJson());
                                                  });
                                                });
                                          });
                                    },
                                    child: BarcodeWidget(
                                      data: e.text ?? 'Barcode Data',
                                      barcode: Barcode.fromType(e.barcode!),
                                      width: (e.width ?? 25) * scale!,
                                      height: (e.height ?? 25) * scale!,
                                      color: Color(e.color),
                                            style: TextStyle(
                                              fontSize:
                                                  (e.fontSize ?? 8) * scale!,
                                            ),
                                            errorBuilder: (context, string) {
                                              return Container(
                                                child: Text(string),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    : BarcodeWidget(
                                        data: e.text ?? 'Barcode Data',
                                        barcode: Barcode.fromType(e.barcode!),
                                        width: (e.width ?? 25) * scale!,
                                        height: (e.height ?? 25) * scale!,
                                        color: Color(e.color),
                                        style: TextStyle(
                                          fontSize: (e.fontSize ?? 8) * scale!,
                                        ),
                                              errorBuilder: (context, string) {
                                                return Container(
                                                  child: Text(string),
                                                );
                                              },
                                            ),
                                    );
                                  }
                              }
                              return const SizedBox();
                            }).toList()
                          : [],
                    ),
                  ));
            },
          ),
        ),
      ],
    );
  }
}
