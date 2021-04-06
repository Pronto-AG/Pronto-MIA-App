import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';
import 'package:pronto_mia/core/services/token_service.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/ui/views/home/home_view.dart';
import 'package:pronto_mia/ui/views/download_file/download_file_view.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:pronto_mia/ui/views/upload_file/upload_file_view.dart';

@StackedApp(routes: [
  MaterialRoute(path: '/login', page: LoginView, initial: true),
  MaterialRoute(path: '/home', page: HomeView, children: [
    MaterialRoute(path: '/upload', page: UploadFileView, initial: true),
    MaterialRoute(path: '/download', page: DownloadFileView),
  ]),
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: TokenService),
  LazySingleton(classType: GraphQLService),
  LazySingleton(classType: AuthenticationService),
  LazySingleton(classType: PdfService),
  LazySingleton(classType: PushNotificationService),
])
class AppSetup {}
