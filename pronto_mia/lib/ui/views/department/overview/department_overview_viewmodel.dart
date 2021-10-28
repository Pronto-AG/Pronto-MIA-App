import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/department_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/department/edit/department_edit_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [DepartmentOverviewView].
class DepartmentOverviewViewModel extends FutureViewModel<List<Department>> {
  static const String contextIdentifier = "DepartmentOverviewViewModel";

  UserService get _userService => locator.get<UserService>();
  DepartmentService get _departmentService => locator.get<DepartmentService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  DialogService get _dialogService => locator.get<DialogService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;
  User get currentUser => _currentUser;
  User _currentUser;

  /// Gets all departments and stores them into [data].
  ///
  /// Returns the fetched [List] of departments.
  @override
  Future<List<Department>> futureToRun() async => _getDepartments();

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

  /// Opens the form to create or update departments.
  ///
  /// Takes the [Department] to edit and a [bool] as an input wether the
  /// view should open as a dialog or standalone as an input.
  /// If the navigation or dialog resolve to data being changed, refetches
  /// the [List] of departments.
  Future<void> editDepartment(
      {Department department, bool asDialog = false}) async {
    bool dataHasChanged;
    if (asDialog) {
      final dialogResponse = await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        data: DepartmentEditView(department: department, isDialog: true),
      );
      dataHasChanged = dialogResponse?.confirmed ?? false;
    } else {
      final navigationResponse =
          await _navigationService.navigateWithTransition(
        DepartmentEditView(department: department),
        transition: NavigationTransition.LeftToRight,
      );
      dataHasChanged = navigationResponse is bool && navigationResponse == true;
    }

    if (dataHasChanged) {
      await initialise();
    }
  }

  Future<List<Department>> _getDepartments() async {
    return _departmentService.getDepartments();
  }
}
