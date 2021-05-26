import 'package:stacked/stacked.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/error_service.dart';

class UserOverviewViewModel extends FutureViewModel<List<User>> {
  static const String contextIdentifier = "UserOverviewViewModel";

  UserService get _userService => locator.get<UserService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<List<User>> futureToRun() async => _getUsers();

  @override
  Future<void> onError(dynamic error) async {
    await _errorService.handleError(contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  Future<void> editUser({User user, bool asDialog = false}) async {

  }

  Future<List<User>> _getUsers() async {
    return _userService.getUsers();
  }
}