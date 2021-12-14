import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String TitleValueKey = 'title';
const String DescriptionValueKey = 'description';
const String VideoPathValueKey = 'upload.mp4';

mixin $EducationalContentEditView on StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController videoPathController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode videoPathFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    titleController.addListener(() => _updateFormData(model));
    descriptionController.addListener(() => _updateFormData(model));
    videoPathController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        {
          TitleValueKey: titleController.text,
          DescriptionValueKey: descriptionController.text,
          VideoPathValueKey: videoPathController.text,
        },
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    titleController.dispose();
    descriptionController.dispose();
    videoPathController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get titleValue => this.formValueMap[TitleValueKey];
  String get descriptionValue => this.formValueMap[DescriptionValueKey];
  String get videoPathValue => this.formValueMap[VideoPathValueKey];
}
