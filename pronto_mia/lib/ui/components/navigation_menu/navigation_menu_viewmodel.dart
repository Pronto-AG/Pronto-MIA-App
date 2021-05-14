import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/core/services/user_service.dart';

class NavigationMenuViewModel extends FutureViewModel<User> {
  static String contextIdentifier = "NavigationMenuViewModel";

  NavigationService get _navigationService => locator.get<NavigationService>();
  ErrorService get _errorService => locator.get<ErrorService>();
  UserService get _userService => locator.get<UserService>();

  String get errorMessage => _errorMessage;
  String _errorMessage;

  @override
  Future<User> futureToRun() => _getUser();

  @override
  Future<void> onError(dynamic error) async {
    await _errorService.handleError(
        NavigationMenuViewModel.contextIdentifier, error);
    _errorMessage = _errorService.getErrorMessage(error);
  }

  void navigateTo(Widget page) {
    _navigationService.replaceWithTransition(
      page,
      transition: NavigationTransition.Fade,
    );
  }

  Future<User> _getUser() => _userService.getCurrentUser();
}
