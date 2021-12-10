import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:html_editor_enhanced/html_editor.dart';

const String TitleValueKey = 'title';
const String DescriptionValueKey = 'description';
const String AvailableFromValueKey = 'availableFrom';
const String ImagePathValueKey = 'upload.png';

mixin $ExternalNewsEditView on StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  // final TextEditingController descriptionController = TextEditingController();
  final TextEditingController availableFromController =
      TextEditingController(text: DateTime.now().toString());
  final HtmlEditorController htmlEditorController = HtmlEditorController();
  final TextEditingController imagePathController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode availableFromFocusNode = FocusNode();
  final FocusNode imagePathFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    titleController.addListener(() => _updateFormData(model));
    // descriptionController.addListener(() => _updateFormData(model));
    availableFromController.addListener(() => _updateFormData(model));
    imagePathController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) async => model.setData(
        {
          TitleValueKey: titleController.text,
          // DescriptionValueKey: descriptionController.text,
          DescriptionValueKey: await htmlEditorController.getText(),
          AvailableFromValueKey: availableFromController.text,
          ImagePathValueKey: imagePathController.text,
        },
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    titleController.dispose();
    // descriptionController.dispose();
    availableFromController.dispose();
    imagePathController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get titleValue => this.formValueMap[TitleValueKey];
  String get descriptionValue => this.formValueMap[DescriptionValueKey];
  String get availableFromValue => this.formValueMap[AvailableFromValueKey];
  String get imagePathValue => this.formValueMap[ImagePathValueKey];
}
