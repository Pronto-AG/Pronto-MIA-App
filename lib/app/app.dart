import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:informbob_app/core/services/auth_service.dart';
import 'package:informbob_app/core/services/gql_service.dart';
import 'package:informbob_app/ui/views/launches/launches_view.dart';
import 'package:informbob_app/ui/views/login/login_view.dart';
import 'package:informbob_app/ui/views/home/home_view.dart';
import 'package:informbob_app/core/services/storage_service.dart';
import 'package:informbob_app/core/services/storage_service_fake.dart';
import 'package:informbob_app/core/services/token_service.dart';

@StackedApp(routes: [
  MaterialRoute(page: LoginView, initial: true),
  MaterialRoute(page: HomeView),
  MaterialRoute(page: LaunchesView),
], dependencies: [
  LazySingleton(classType: NavigationService),
  LazySingleton(classType: StorageServiceFake, asType: StorageService),
  LazySingleton(classType: GqlService),
  LazySingleton(classType: TokenService),
  LazySingleton(classType: AuthService),
])
class AppSetup {}
