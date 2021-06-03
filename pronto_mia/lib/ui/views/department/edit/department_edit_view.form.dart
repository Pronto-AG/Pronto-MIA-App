import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';

mixin $DepartmentEditView on StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  void _updateFormData(FormViewModel model) => model.setData({
    NameValueKey: nameController.text,
  });

  void disposeForm() {
    nameController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get nameValue => this.formValueMap[NameValueKey];
}