import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [UserOverviewView].
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

  /// Gets all users and stores them into [data].
  ///
  /// Returns the fetched [List] of users.
  @override
  Future<List<User>> futureToRun() async => _getUsers();

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  /// Fetches the current user and assigns it to [_currentUser].
  Future<void> fetchCurrentUser() async {
    _currentUser = await _userService.getCurrentUser();
    notifyListeners();
  }

  /// Gets all departments and stores them into [data].
  Future<List<User>> filterUsers(String filter) async =>
      _getFilteredUsers(filter);

  /// Opens the form to create or update users.
  ///
  /// Takes the [User] to edit and a [bool] as an input wether the
  /// view should open as a dialog or standalone as an input.
  /// If the navigation or dialog resolve to data being changed, refetches
  /// the [List] of users.
  Future<void> editUser({
    User user,
    bool asDialog = false,
    List<Department> selectedDepartments,
  }) async {
    bool dataHasChanged;

    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        // ignore: deprecated_member_use
        customData: UserEditView(
          user: user,
          isDialog: true,
          selectedDepartments: selectedDepartments,
        ),
      );
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse =
          await _navigationService.navigateWithTransition(
        UserEditView(user: user, selectedDepartments: selectedDepartments),
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

  Future<List<User>> _getFilteredUsers(String filter) async {
    return _userService.filterUser(filter);
  }

  /// Removes the [User] contained in the form.
  ///
  /// After the [User] has been removed successfully, closes dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeUser(User user) async {
    if (user != null) {
      await runBusyFuture(
        _userService.removeUser(user.id),
      );
    }
  }

  Future<void> removeItems(List<User> selectedToDelete) async {
    for (var i = 0; i < selectedToDelete.length; i++) {
      removeUser(selectedToDelete[i]);
      data.remove(selectedToDelete[i]);
    }
  }
}
