import 'package:flutter/material.dart';
import 'package:generate_receipt/models/data_model.dart';
import 'package:generate_receipt/view/elements/image_edit_dialog.dart';
import 'package:generate_receipt/view/elements/image_element.dart';
import 'package:generate_receipt/view/elements/line_edit_dialog.dart';
import 'package:generate_receipt/view/elements/line_element.dart';
import 'package:generate_receipt/view/elements/text_edit_dialog.dart';
import 'package:generate_receipt/view/elements/text_element.dart';

class PdfDesign extends StatefulWidget {
  final double width;
  final double height;
  final Map<String, dynamic>? json;
  final void Function(Map<String, dynamic>) onChange;
  const PdfDesign(
      {Key? key,
      required this.onChange,
      this.json,
      this.width = 300,
      this.height = 300})
      : super(key: key);

  @override
  State<PdfDesign> createState() => _PdfDesignState();
}

class _PdfDesignState extends State<PdfDesign> {
  late DataModel dataModel;
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

  @override
  void initState() {
    dataModel = DataModel.fromJson(widget.json!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextElement(
                  titleDialog: 'Enter your Text',
                  outlineBtnName: 'Text'
                      '',
                  onSubmitted: (elm) {
                    setState(() {
                      dataModel.elements!.add(elm);
                      widget.onChange(dataModel.toJson());
                    });
                  }),
              ImageElements(
                  titleDialog: 'Add your Images',
                  outlineBtnName: 'Im'
                      'age',
                  onSubmitted: (elm) {
                    setState(() {
                      dataModel.elements!.add(elm);
                      widget.onChange(dataModel.toJson());
                    });
                  }),
              LineElement(
                  titleDialog: 'Add your Lines',
                  outlineBtnName: 'Line',
                  onSubmitted: (elm) {
                    setState(() {
                      dataModel.elements!.add(elm);
                      widget.onChange(dataModel.toJson());
                    });
                  }),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          Container(
            key: containerKey,
            decoration: BoxDecoration(color: Colors.blue, border: Border.all()),
            height: dataModel.height,
            width: dataModel.width,
            child: Stack(
              children: dataModel.elements!.map<Widget>((e) {
                switch (e.type) {
                  case WidgetType.text:
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
                              child: Text(
                            e.text ?? '-',
                            key: e.key,
                            style: TextStyle(
                                fontSize: e.fontSize,
                                color: Color(e.color ?? 0xffFF000000)),
                            // key: GlobalObjectKey(e.text ?? ''),
                          )),
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
                                            widget.onChange(dataModel.toJson());
                                          });
                                        },
                                      );
                                    });

                                debugPrint('Long Press = $isLongPressed');
                              });
                            },
                            child: Text(
                              e.text ?? '-',
                              key: e.key,
                              style: TextStyle(
                                  fontSize: e.fontSize,
                                  color: Color(e.color ?? 0xffFF000000)),
                            ),
                          ),
                        ),
                      );
                    }
                  case WidgetType.image:
                    {
                      return Positioned(
                        left: e.xPosition,
                        top: e.yPosition,
                        child: Draggable(
                          feedback: Image.memory(
                            e.image,
                            width: e.width,
                            height: e.height,
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
                            child: Image.memory(
                              e.image,
                              key: e.key,
                              fit: BoxFit.contain,
                              width: e.width,
                              height: e.height,
                            ),
                          ),
                        ),
                      );
                    }
                  case WidgetType.line:
                    {
                      return Positioned(
                        left: e.xPosition,
                        top: e.yPosition,
                        child: Draggable(
                          feedback: Container(
                            color: Color(e.color),
                            height: e.thickness,
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
                              height: e.thickness,
                              width: e.width,
                            ),
                          ),
                        ),
                      );
                    }
                }
              }).toList(),
            ),
          ),
          const SizedBox(height: 40),
          MaterialButton(
              onPressed: () {
                setState(() {});
              },
              color: Colors.blue,
              child: const Text('Save')),
        ],
      ),
    );
  }
}
