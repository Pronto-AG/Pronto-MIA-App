import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String OldPasswordValueKey = 'oldPassword';
const String NewPasswordValueKey = 'newPassword';
const String PasswordConfirmValueKey = 'newPasswordConfirm';

mixin $SettingsView on StatelessWidget {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController passwordConfirmController =
      TextEditingController();
  final FocusNode oldPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();
  final FocusNode passwordConfirmFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    oldPasswordController.addListener(() => _updateFormData(model));
    newPasswordController.addListener(() => _updateFormData(model));
    passwordConfirmController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData({
        OldPasswordValueKey: oldPasswordController.text,
        NewPasswordValueKey: newPasswordController.text,
        PasswordConfirmValueKey: passwordConfirmController.text,
      });

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
    passwordConfirmController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get oldPasswordValue => this.formValueMap[OldPasswordValueKey];
  String get newPasswordValue => this.formValueMap[NewPasswordValueKey];
  String get passwordConfirmValue => this.formValueMap[PasswordConfirmValueKey];
}
