import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:stacked/stacked.dart';
import 'package:http_parser/http_parser.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/services/file_service.dart';
import 'package:pronto_mia/app/app.router.dart';

class UploadFileViewModel extends BaseViewModel {
  final FileService _fileService = locator<FileService>();
  final NavigationService _navigationService = locator<NavigationService>();

  Future<void> uploadFile() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();

    final multiPartFile = MultipartFile.fromBytes(
      'upload',
      result.files.single.bytes,
      filename: result.names.single,
      contentType: MediaType("application", "pdf"),
    );

    await _fileService.uploadFile(multiPartFile);
    _navigationService.navigateTo(Routes.downloadFileView);
  }
}