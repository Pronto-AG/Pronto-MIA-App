// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedFormGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String PdfPathValueKey = 'pdfPath';
const String AvailableFromValueKey = 'availableFrom';
const String AvailableUntilValueKey = 'availableUntil';

mixin $DeploymentPlanEditView on StatelessWidget {
  final TextEditingController pdfPathController = TextEditingController();
  final TextEditingController availableFromController = TextEditingController();
  final TextEditingController availableUntilController =
      TextEditingController();
  final FocusNode pdfPathFocusNode = FocusNode();
  final FocusNode availableFromFocusNode = FocusNode();
  final FocusNode availableUntilFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    pdfPathController.addListener(() => _updateFormData(model));
    availableFromController.addListener(() => _updateFormData(model));
    availableUntilController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        {
          PdfPathValueKey: pdfPathController.text,
          AvailableFromValueKey: availableFromController.text,
          AvailableUntilValueKey: availableUntilController.text,
        },
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    // The dispose function for a TextEditingController sets all listeners to null

    pdfPathController.dispose();
    availableFromController.dispose();
    availableUntilController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get pdfPathValue => this.formValueMap[PdfPathValueKey];
  String get availableFromValue => this.formValueMap[AvailableFromValueKey];
  String get availableUntilValue => this.formValueMap[AvailableUntilValueKey];
}
