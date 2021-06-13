import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String OldPasswordValueKey = 'oldPassword';
const String NewPasswordValueKey = 'newPassword';

mixin $SettingsView on StatelessWidget {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final FocusNode oldPasswordFocusNode = FocusNode();
  final FocusNode newPasswordFocusNode = FocusNode();

  void listenToFormUpdated(FormViewModel model) {
    oldPasswordController.addListener(() => _updateFormData(model));
    newPasswordController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  void _updateFormData(FormViewModel model) => model.setData({
        OldPasswordValueKey: oldPasswordController.text,
        NewPasswordValueKey: newPasswordController.text,
      });

  void disposeForm() {
    oldPasswordController.dispose();
    newPasswordController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get oldPasswordValue => this.formValueMap[OldPasswordValueKey];
  String get newPasswordValue => this.formValueMap[NewPasswordValueKey];
}
