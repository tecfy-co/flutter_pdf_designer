import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
class MainController{

  static Uint8List? bytes;
  static File? file;

  static Future pickFile()async{
    FilePickerResult? result = await FilePicker.platform.pickFiles
      (type:FileType.image,withData: true );

    if (result != null) {
       file = File(result.files.single.path!);
      bytes = result.files.single.bytes;
      // print(bytes);
      print(result.files.single);
      print(file);
    } else {
      // User canceled the picker
      print('user Cancelled');
    }
  }
  // GlobalKey containerKey = GlobalKey();
  //
  //  void setWidgetOverStack(dragDetails, e,context) {
  //   //To know current position for containerKey
  //
  //   final keyContext = containerKey.currentContext;
  //   print(e.key);
  //   if (keyContext != null) {
  //     // widget is visible
  //     final box = keyContext.findRenderObject() as RenderBox;
  //     final pos = box.localToGlobal(Offset.zero);
  //     print(pos);
  //
  //     e.xPosition = dragDetails.offset.dx - pos.dx;
  //     // We need to remove offsets like app/status bar from Y
  //     e.yPosition = dragDetails.offset.dy - pos.dy;
  //     if (e.xPosition < 0) {
  //       e.xPosition = 0.0;
  //     }
  //     if (e.yPosition < 0) {
  //       e.yPosition = 0.0;
  //     }
  //
  //     final widgetKeyContext = e.key.currentContext;
  //     print('imageKeyContext = $widgetKeyContext');
  //     if (widgetKeyContext != null) {
  //       final imageBox = widgetKeyContext.findRenderObject() as RenderBox;
  //       // print(textBox.size);
  //       // print(box.size);
  //       final imagePos = imageBox.localToGlobal(Offset.zero);
  //       if (e.xPosition + imageBox.size.width > box.size.width) {
  //         print('Widget width ${imageBox.size.width}');
  //         print('+++++ Widget ${e.xPosition} -> change '
  //             'to ${box.size.width - imageBox.size.width} ');
  //         e.xPosition = box.size.width - imageBox.size.width;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: const Text('Out of the box')));
  //       }
  //       if (e.yPosition + imageBox.size.height > box.size.height) {
  //         e.yPosition = box.size.height - imageBox.size.height;
  //         ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: const Text('Out of the box')));
  //       }
  //       print('---Widget Position  ='
  //           ' $imagePos');
  //       // print('Stack Position = $pos ');
  //     }
  //   }
  //   // print(dragDetails.offset);
  //   // e.xImage = dragDetails.offset.dx-214;
  //   // We need to remove offsets like app/status bar from Y
  //   // e.yImage = dragDetails.offset.dy-99;
  //   // print(e.xPosition);
  //   // print(e.yPosition);
  // }
}