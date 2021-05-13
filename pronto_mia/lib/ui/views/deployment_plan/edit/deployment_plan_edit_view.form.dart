import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String DescriptionValueKey = 'description';
const String AvailableFromValueKey = 'availableFrom';
const String AvailableUntilValueKey = 'availableUntil';
const String PdfPathValueKey = 'pdfPath';

mixin $DeploymentPlanEditView on StatelessWidget {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController availableFromController = TextEditingController();
  final TextEditingController availableUntilController =
      TextEditingController();
  final TextEditingController pdfPathController = TextEditingController();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode availableFromFocusNode = FocusNode();
  final FocusNode availableUntilFocusNode = FocusNode();
  final FocusNode pdfPathFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    descriptionController.addListener(() => _updateFormData(model));
    availableFromController.addListener(() => _updateFormData(model));
    availableUntilController.addListener(() => _updateFormData(model));
    pdfPathController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        {
          DescriptionValueKey: descriptionController.text,
          AvailableFromValueKey: availableFromController.text,
          AvailableUntilValueKey: availableUntilController.text,
          PdfPathValueKey: pdfPathController.text,
        },
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    descriptionController.dispose();
    availableFromController.dispose();
    availableUntilController.dispose();
    pdfPathController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get descriptionValue => this.formValueMap[DescriptionValueKey];
  String get availableFromValue => this.formValueMap[AvailableFromValueKey];
  String get availableUntilValue => this.formValueMap[AvailableUntilValueKey];
  String get pdfPathValue => this.formValueMap[PdfPathValueKey];
}
