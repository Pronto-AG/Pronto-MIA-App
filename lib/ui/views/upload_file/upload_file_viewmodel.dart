import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import 'package:http_parser/http_parser.dart';

import 'package:informbob_app/app/app.locator.dart';
import 'package:informbob_app/core/services/file_service.dart';

class UploadFileViewModel extends BaseViewModel {
  final FileService _fileService = locator<FileService>();

  Future uploadFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    final multiPartFile = MultipartFile.fromBytes(
      'test',
      result.files.single.bytes,
      filename: result.names.single,
      contentType: MediaType("application", "pdf"),
    );

    await _fileService.uploadFile(multiPartFile);
  }
}