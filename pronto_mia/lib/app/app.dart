import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/deployment_plan_service.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/jwt_token_service.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/core/services/push_notification_service.dart';
import 'package:pronto_mia/ui/views/pdf/pdf_view.dart';
import 'package:pronto_mia/ui/views/home/home_view.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';
import 'package:pronto_mia/ui/views/deployment_plan/deployment_plan_view.dart';
import 'package:pronto_mia/ui/views/upload_file/upload_file_view.dart';

@StackedApp(routes: [
  MaterialRoute(path: '/login', page: LoginView),
  MaterialRoute(path: '/home', page: HomeView, children: [
    MaterialRoute(path: '/', page: DeploymentPlanView, initial: true),
    MaterialRoute(path: '/upload', page: UploadFileView),
    MaterialRoute(path: '/download', page: PdfView),
  ]),
], dependencies: [
  LazySingleton(classType: NavigationService, asType: NavigationService),
  LazySingleton(classType: JwtTokenService, asType: JwtTokenService),
  LazySingleton(classType: GraphQLService, asType: GraphQLService),
  LazySingleton(
    classType: AuthenticationService, asType: AuthenticationService),
  LazySingleton(classType: PdfService, asType: PdfService),
  LazySingleton(
      classType: PushNotificationService, asType: PushNotificationService),
  LazySingleton(
      classType: DeploymentPlanService, asType: DeploymentPlanService),
  LazySingleton(classType: ErrorMessageFactory, asType: ErrorMessageFactory),
])
class AppSetup {}
