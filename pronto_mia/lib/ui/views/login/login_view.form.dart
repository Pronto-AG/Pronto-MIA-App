import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';

const String UserNameValueKey = 'userName';
const String PasswordValueKey = 'password';

mixin $LoginView on State<LoginView> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    userNameController.addListener(() => _updateFormData(model));
    passwordController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        {
          UserNameValueKey: userNameController.text,
          PasswordValueKey: passwordController.text,
        },
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    userNameController.dispose();
    passwordController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get userNameValue => this.formValueMap[UserNameValueKey];
  String get passwordValue => this.formValueMap[PasswordValueKey];
}
