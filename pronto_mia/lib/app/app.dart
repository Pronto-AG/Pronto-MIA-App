import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/ui/views/upload_file/upload_file_view.dart';
import 'package:pronto_mia/core/services/auth_service.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';
import 'package:pronto_mia/core/services/token_service.dart';
import 'package:pronto_mia/core/services/file_service.dart';
import 'package:pronto_mia/ui/views/download_file/download_file_view.dart';

@StackedApp(routes: [
  MaterialRoute(page: LoginView, initial: true),
  MaterialRoute(page: UploadFileView),
  MaterialRoute(page: DownloadFileView),
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: TokenService),
  LazySingleton(classType: AuthService),
  LazySingleton(classType: FileService)
])
class AppSetup {}
