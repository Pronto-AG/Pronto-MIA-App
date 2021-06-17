import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String UserNameValueKey = 'userName';
const String PasswordValueKey = 'password';
const String PasswordConfirmValueKey = 'passwordConfirm';

mixin $UserEditView on StatelessWidget {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final FocusNode userNameFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode passwordConfirmFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    userNameController.addListener(() => _updateFormData(model));
    passwordController.addListener(() => _updateFormData(model));
    passwordConfirmController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData({
        UserNameValueKey: userNameController.text,
        PasswordValueKey: passwordController.text,
        PasswordConfirmValueKey: passwordConfirmController.text,
      });

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    userNameController.dispose();
    passwordController.dispose();
    passwordConfirmController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get userNameValue => this.formValueMap[UserNameValueKey];
  String get passwordValue => this.formValueMap[PasswordValueKey];
  String get passwordConfirmValue => this.formValueMap[PasswordConfirmValueKey];
}
