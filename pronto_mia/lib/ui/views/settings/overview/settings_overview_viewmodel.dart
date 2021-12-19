import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/authentication_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/settings/view/settings_view.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [SettingsView].
class SettingsOverviewViewModel extends FutureViewModel<User> {
  static const contextIdentifier = 'ProfileViewModel';
  static const logoutActionKey = 'LogoutActionKey';

  AuthenticationService get _authenticationService =>
      locator.get<AuthenticationService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  UserService get _userService => locator.get<UserService>();
  DialogService get _dialogService => locator.get<DialogService>();

  final bool isDialog;

  /// Gets the current user and stores it into [data].
  ///
  /// Returns the current [User].
  @override
  Future<User> futureToRun() => _getUser();

  /// Initializes a new instance of [SettingsViewModel]
  ///
  /// Takes a[bool] wether the form should be displayed as a dialog or
  /// standalone as an input.
  SettingsOverviewViewModel({this.isDialog = false});

  Future<void> logout() async {
    await runBusyFuture(
      _authenticationService.logout(),
      busyObject: logoutActionKey,
    );
    _navigationService.clearStackAndShow('/');
  }

  /// Opens the settings view.
  ///
  /// Takes a [bool] wether the view should open as a dialog
  /// or standalone as an input.
  Future<void> openSettings({bool asDialog = false}) async {
    if (asDialog) {
      await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        // ignore: deprecated_member_use
        customData: SettingsView(isDialog: true),
      );
    } else {
      await _navigationService.navigateWithTransition(SettingsView());
    }
  }

  Future<User> _getUser() => _userService.getCurrentUser();
}
