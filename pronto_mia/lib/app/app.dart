import 'package:stacked/stacked_annotations.dart';

import 'package:pronto_mia/ui/views/pdf/pdf_view.dart';
import 'package:pronto_mia/ui/views/home/home_view.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';
import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_view.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.dart';

@StackedApp(routes: [
  MaterialRoute(path: '/login', page: LoginView),
  MaterialRoute(path: '/home', page: HomeView, children: [
    MaterialRoute(path: '/', page: DeploymentPlanOverviewView, initial: true),
    MaterialRoute(path: '/deployment-plan-edit', page: DeploymentPlanEditView),
    MaterialRoute(path: '/pdf', page: PdfView),
  ]),
])
class AppSetup {}
