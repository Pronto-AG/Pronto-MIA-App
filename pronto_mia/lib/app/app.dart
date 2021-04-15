import 'package:stacked/stacked_annotations.dart';

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
    MaterialRoute(path: '/pdf', page: PdfView),
  ]),
])
class AppSetup {}
