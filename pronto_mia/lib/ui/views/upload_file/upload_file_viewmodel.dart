import 'package:file_picker/file_picker.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';

class UploadFileViewModel extends BaseViewModel {
  Future<PdfService> get _pdfService async {
    await locator.isReady<PdfService>();
    return locator<PdfService>();
  }

  Future<void> uploadFile() async {
    final result = await FilePicker.platform.pickFiles();
    await (await _pdfService).uploadPdf(
      result.names.single,
      result.files.single.bytes,
    );
  }
}
