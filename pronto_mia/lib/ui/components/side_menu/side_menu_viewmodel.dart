import 'package:logging/logging.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/factories/error_message_factory.dart';
import 'package:pronto_mia/core/services/logging_service.dart';

class SideMenuViewModel extends FutureViewModel<User> {
  NavigationService get _navigationService => locator.get<NavigationService>();
  UserService get _userService => locator.get<UserService>();
  Future<LoggingService> get _loggingService =>
      locator.getAsync<LoggingService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<User> futureToRun() => _getUser();

  @override
  Future<void> onError(dynamic error) async {
    _errorMessage = ErrorMessageFactory.getErrorMessage(error);
    (await _loggingService).log('SideMenuViewModel', Level.WARNING, error);
  }

  void navigateTo(String route, {dynamic arguments}) {
    _navigationService.replaceWith(route, arguments: arguments);
  }

  Future<User> _getUser() => _userService.getCurrentUser();
}
