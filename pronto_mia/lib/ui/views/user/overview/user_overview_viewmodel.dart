import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_view.dart';

class UserOverviewViewModel extends FutureViewModel<List<User>> {
  static const String contextIdentifier = "UserOverviewViewModel";

  UserService get _userService => locator.get<UserService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  DialogService get _dialogService => locator.get<DialogService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;
  User get currentUser => _currentUser;
  User _currentUser;

  @override
  Future<List<User>> futureToRun() async => _getUsers();

  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  Future<void> fetchCurrentUser() async {
    _currentUser = await _userService.getCurrentUser();
    notifyListeners();
  }

  Future<void> editUser({User user, bool asDialog = false}) async {
    bool dataHasChanged;

    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        customData: UserEditView(user: user, isDialog: true),
      );
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse =
          await _navigationService.navigateWithTransition(
            UserEditView(user: user),
            transition: NavigationTransition.LeftToRight,
          );
      dataHasChanged = navigationResponse is bool && navigationResponse == true;
    }

    if (dataHasChanged) {
      await initialise();
    }
  }

  Future<List<User>> _getUsers() async {
    return _userService.getUsers();
  }
}
