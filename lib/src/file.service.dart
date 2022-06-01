part of flutter_pdf_designer;

class FileService {
  static Uint8List? bytes;
  static File? file;

  static Future pickFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);

    if (result != null) {
      file = File(result.files.single.path!);
      bytes = result.files.single.bytes;
    }
  }
}
