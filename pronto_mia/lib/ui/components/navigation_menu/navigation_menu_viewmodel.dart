import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';
import 'package:pronto_mia/ui/views/settings/settings_view.dart';

class NavigationMenuViewModel extends FutureViewModel<User> {
  static String contextIdentifier = "NavigationMenuViewModel";

  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  UserService get _userService => locator.get<UserService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<User> futureToRun() => _getUser();

  @override
  Future<void> onError(dynamic error) async {
    super.onError(error);
    await _errorService.handleError(
        NavigationMenuViewModel.contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
    notifyListeners();
  }

  void navigateTo(Widget page) {
    _navigationService.replaceWithTransition(
      page,
      transition: NavigationTransition.Fade,
    );
  }

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
