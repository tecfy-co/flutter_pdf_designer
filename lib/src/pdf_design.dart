part of flutter_pdf_designer;

class PdfDesign extends StatefulWidget {
  final Map<String, PdfElementType>? variableList;
  final double width;
  final double height;
  final Map<String, dynamic>? json;
  final void Function(Map<String, dynamic>) onChange;

  const PdfDesign(
      {Key? key,
      required this.onChange,
      this.json,
      this.width = 300,
      this.height = 300,
      this.variableList})
      : super(key: key);

  @override
  State<PdfDesign> createState() => _PdfDesignState();
}

class _PdfDesignState extends State<PdfDesign> {
  late PdfModel dataModel;
  bool isLongPressed = false;

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
      debugPrint('imageKeyContext = $widgetKeyContext');
      if (widgetKeyContext != null) {
        final imageBox = widgetKeyContext.findRenderObject() as RenderBox;

        final imagePos = imageBox.localToGlobal(Offset.zero);
        if (e.xPosition + imageBox.size.width > box.size.width) {
          debugPrint('Widget width ${imageBox.size.width}');
          debugPrint('+++++ Widget ${e.xPosition} -> change '
              'to ${box.size.width - imageBox.size.width} ');
          e.xPosition = box.size.width - imageBox.size.width;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Out of the box')));
        }
        if (e.yPosition + imageBox.size.height > box.size.height) {
          e.yPosition = box.size.height - imageBox.size.height;
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Out of the box')));
        }
        debugPrint('---Widget Position  ='
            ' $imagePos');
        // debugPrint('Stack Position = $pos ');
      }
    }
  }

  void onChange() {
    widget.onChange({});
  }

  GlobalKey containerKey = GlobalKey();
  List<String> list = [];

  @override
  void initState() {
    dataModel = PdfModel.fromJson(widget.json!);
    widget.variableList!.forEach((key, value) {
      list.add(key);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: TextElement(
                      titleDialog: 'Enter your Text',
                      outlineBtnName: 'Text'
                          '',
                      onSubmitted: (elm) {
                        setState(() {
                          dataModel.elements!.add(elm);
                          widget.onChange(dataModel.toJson());
                        });
                      })),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: ImageElements(
                      titleDialog: 'Add your Images',
                      outlineBtnName: 'Im'
                          'age',
                      onSubmitted: (elm) {
                        setState(() {
                          dataModel.elements!.add(elm);
                          widget.onChange(dataModel.toJson());
                        });
                      })),
              Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: LineElement(
                    titleDialog: 'Add your Lines',
                    outlineBtnName: 'Line',
                    onSubmitted: (elm) {
                      setState(() {
                        dataModel.elements!.add(elm);
                        widget.onChange(dataModel.toJson());
                      });
                    },
                    lineWidth: widget.width,
                  )),
              SizedBox(
                  width: 150,
                  child: DropdownSearch<String>(
                    popupProps: const PopupProps.menu(
                      showSelectedItems: true,
                      showSearchBox: false,
                    ),
                    items: list,
                    dropdownSearchDecoration: const InputDecoration(
                      labelText: "Your Components",
                      hintText: "Components",
                      labelStyle: TextStyle(fontSize: 12),
                    ),
                    onChanged: (s) {
                      widget.variableList!.forEach((key, value) {
                        print('S = $s,key = $key');
                        if (s == key && value == PdfElementType.text) {
                          print('-------Adding[ Text ]to your Model--------');
                          setState(() {
                            dataModel.elements!.add(PdfElement.text(
                                type: PdfElementType.text,
                                text: s,
                                fontSize: 20.0,
                                color: 1099494850560));
                            widget.onChange(dataModel.toJson());
                          });
                        }
                        if (s == key && value == PdfElementType.image) {
                          print('-------Adding[ Image ]to your Model--------');
                          setState(() {
                            dataModel.elements!.add(PdfElement.image(
                              type: PdfElementType.image,
                              image: null,
                            ));
                            widget.onChange(dataModel.toJson());
                          });
                        }
                        if (s == key && value == PdfElementType.barcode) {
                          print('-------Adding[ Barcode ]to your '
                              'Model--------');
                          setState(() {
                            dataModel.elements!.add(PdfElement(
                                type: PdfElementType.barcode,
                                text: 'your barcode',
                                width: 100,
                                height: 100,
                                color: 1099494850560,
                                barcode: Barcode.code128()));
                            widget.onChange(dataModel.toJson());
                          });
                        }
                      });
                    },
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            key: containerKey,
            decoration: BoxDecoration(border: Border.all()),
            height: widget.height,
            width: widget.width,
            child: Stack(
              children: dataModel.elements!.map<Widget>((e) {
                switch (e.type) {
                  case PdfElementType.text:
                    {
                      return Positioned(
                        left: e.xPosition,
                        top: e.yPosition,
                        child: Draggable(
                          onDragEnd: (dragDetails) {
                            setState(() {
                              setWidgetOverStack(dragDetails, e);
                              widget.onChange(dataModel.toJson());
                            });
                          },
                          feedback: Material(
                              child: Container(
                                  width: e.width,
                                  height: e.height,
                                  color: Color(e.color ?? 0xffFF000000)
                                      .withOpacity(0.3),
                                  child: Text(
                                    e.text ?? '-',
                                    key: e.key,
                                    style: TextStyle(
                                        fontSize: e.fontSize,
                                        color: Color(e.color ?? 0xffFF000000)),
                                    // key: GlobalObjectKey(e.text ?? ''),
                                  ))),
                          childWhenDragging: const SizedBox(),
                          child: InkWell(
                              onDoubleTap: () {
                                setState(() {
                                  isLongPressed = !isLongPressed;
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return TextEditDialog(
                                          element: e,
                                          onSubmitted: () {
                                            setState(() {
                                              widget
                                                  .onChange(dataModel.toJson());
                                            });
                                          },
                                        );
                                      });

                                  debugPrint('Long Press = $isLongPressed');
                                });
                              },
                              child: Container(
                                color: Color(e.color ?? 0xffFF000000)
                                    .withOpacity(0.2),
                                width: e.width,
                                height: e.height,
                                child: Text(
                                  e.text ?? '-',
                                  key: e.key,
                                  style: TextStyle(
                                      fontSize: e.fontSize,
                                      color: Color(e.color ?? 0xffFF000000)),
                                ),
                              )),
                        ),
                      );
                    }
                  case PdfElementType.image:
                    {
                      return Positioned(
                        left: e.xPosition,
                        top: e.yPosition,
                        child: Draggable(
                          feedback: e.image != null
                              ? Image.memory(
                                  e.image!,
                                  width: e.width,
                                  height: e.height,
                                )
                              : Material(
                                  child: Container(
                                    color: Colors.red,
                                    width: 100,
                                    height: 100,
                                    child: Center(
                                      child: Text('YourLogoHere!'),
                                    ),
                                  ),
                                ),
                          onDragEnd: (dragDetails) {
                            setState(() {
                              setWidgetOverStack(dragDetails, e);
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
                                        onSubmitted: () {
                                          setState(() {
                                            widget.onChange(dataModel.toJson());
                                          });
                                        });
                                  });
                            },
                            child: e.image != null
                                ? Image.memory(
                                    e.image!,
                                    key: e.key,
                                    fit: BoxFit.contain,
                                    width: e.width,
                                    height: e.height,
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
                          ),
                        ),
                      );
                    }
                  case PdfElementType.line:
                    {
                      return Positioned(
                        left: e.xPosition,
                        top: e.yPosition,
                        child: Draggable(
                          feedback: Container(
                            color: Color(e.color ?? 0),
                            height: e.height,
                            width: e.width,
                          ),
                          onDragEnd: (dragDetails) {
                            setState(
                              () {
                                setWidgetOverStack(dragDetails, e);
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
                                        onSubmitted: () {
                                          setState(() {
                                            widget.onChange(dataModel.toJson());
                                          });
                                        });
                                  });
                            },
                            child: Container(
                              key: e.key,
                              color: Color(e.color),
                              height: e.height,
                              width: e.width,
                            ),
                          ),
                        ),
                      );
                    }
                  case PdfElementType.barcode:
                    {
                      return Positioned(
                        left: e.xPosition,
                        top: e.yPosition,
                        key: e.key,
                        child: Draggable(
                          feedback: Material(
                            child: BarcodeWidget(
                              data: e.text!,
                              barcode: e.barcode!,
                              color: Color(e.color),
                              width: e.width,
                              height: e.height,
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
                                        onSubmitted: () {
                                          setState(() {
                                            widget.onChange(dataModel.toJson());
                                          });
                                        });
                                  });
                            },
                            child: BarcodeWidget(
                              data: e.text!,
                              barcode: e.barcode!,
                              width: e.width,
                              height: e.height,
                              color: Color(e.color),
                              errorBuilder: (context, string) {
                                return Container(
                                  child: Text(string),
                                );
                              },
                            ),
                          ),
                        ),
                      );
                    }
                }
                return const SizedBox();
              }).toList(),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
