part of flutter_pdf_designer;

class FileService {
  static Uint8List? bytes;

  static Future pickFile() async {
    final result = await FilePicker.platform
        .pickFiles(withData: true, type: FileType.image);

    if (result != null && result.files.isNotEmpty) {
      bytes = result.files.single.bytes;
    }
  }
}
