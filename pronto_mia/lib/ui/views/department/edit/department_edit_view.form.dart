import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String NameValueKey = 'name';

mixin $DepartmentEditView on StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final FocusNode nameFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values.
  void listenToFormUpdated(FormViewModel model) {
    nameController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  /// Updates the formData on the FormViewModel.
  void _updateFormData(FormViewModel model) => model.setData({
        NameValueKey: nameController.text,
      });

  /// Calls dispose on all the generated controllers and focus nodes.
  void disposeForm() {
    nameController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get nameValue => this.formValueMap[NameValueKey];
}
