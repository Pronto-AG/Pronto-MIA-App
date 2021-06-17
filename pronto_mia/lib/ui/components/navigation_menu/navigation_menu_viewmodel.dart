import 'package:flutter/material.dart';
import 'package:pronto_mia/ui/components/navigation_menu/navigation_menu.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/settings/settings_view.dart';

/// a view model, providing functionality for [NavigationMenu].
class NavigationMenuViewModel extends FutureViewModel<User> {
  static String contextIdentifier = "NavigationMenuViewModel";

  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  UserService get _userService => locator.get<UserService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  /// Gets the current user and stores it into [data].
  ///
  /// Returns the current [User].
  @override
  Future<User> futureToRun() => _getUser();

  /// Handles incoming error and sets [errorMessage] accordingly.
  ///
  /// Takes the thrown dynamic error object as an input.
  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
        NavigationMenuViewModel.contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  /// Navigates to a widget.
  ///
  /// Takes the [Widget] to navigate to as an input.
  void navigateTo(Widget page) {
    _navigationService.replaceWithTransition(
      page,
      transition: NavigationTransition.Fade,
    );
  }

  /// Opens the settings view.
  ///
  /// Takes a [boolean] as an input wether the view should open as a dialog
  /// or standalone.
  Future<void> openSettings({bool asDialog = false}) async {
    if (asDialog) {
      await _dialogService.showCustomDialog(
        variant: DialogType.custom,
        customData: SettingsView(isDialog: true),
      );
    } else {
      await _navigationService.navigateWithTransition(SettingsView());
    }
  }

  Future<User> _getUser() => _userService.getCurrentUser();
}
