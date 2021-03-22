import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:informbob_app/ui/views/login/login_view.dart';
import 'package:informbob_app/ui/views/home/home_view.dart';
import 'package:informbob_app/core/services/storage_service.dart';
import 'package:informbob_app/core/services/storage_service_fake.dart';

@StackedApp(routes: [
  MaterialRoute(page: LoginView, initial: true),
  MaterialRoute(page: HomeView),
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: StorageServiceFake, asType: StorageService),
])
class AppSetup {}
