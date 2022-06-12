library flutter_pdf_designer;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:barcode_widget/barcode_widget.dart';

part './src/pdf_design.dart';

part 'src/file.service.dart';

part './src/elements/text_element.dart';

part './src/elements/image_element.dart';

part './src/elements/line_element.dart';

part './src/elements/text_edit_dialog.dart';

part './src/elements/image_edit_dialog.dart';

part './src/elements/line_edit_dialog.dart';

part './src/elements/barcode_edit_dialog.dart';

part './src/pdf_widget.dart';

part './src/elements/barcode_conf.dart';

part './src/elements/barcode_dropdown.dart';
part 'src/models/data.model.dart';
part './src/models/element.model.dart';
part './src/models/element_types.dart';

part './src/models/dynamic_field.model.dart';

part './src/pdf_insert_widgets.dart';
