import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String TitleValueKey = 'title';
const String LocationValueKey = 'location';
const String FromValueKey = 'from';
const String ToValueKey = 'to';
const String IsAllDayValueKey = 'isAllDay';
const String IsYearlyValueKey = 'isYearly';

mixin $AppointmentEditView on StatelessWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController fromController = TextEditingController(
      text: DateTime.now()
          .subtract(Duration(minutes: DateTime.now().minute))
          .toString());
  final TextEditingController toController = TextEditingController(
      text: DateTime.now()
          .add(const Duration(hours: 1))
          .subtract(Duration(minutes: DateTime.now().minute))
          .toString());
  final TextEditingController isAllDayController = TextEditingController();
  final TextEditingController isYearlyController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode fromFocusNode = FocusNode();
  final FocusNode toFocusNode = FocusNode();
  final FocusNode isAllDayFocusNode = FocusNode();
  final FocusNode isYearlyFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    titleController.addListener(() => _updateFormData(model));
    locationController.addListener(() => _updateFormData(model));
    fromController.addListener(() => _updateFormData(model));
    toController.addListener(() => _updateFormData(model));
    isAllDayController.addListener(() => _updateFormData(model));
    isYearlyController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        {
          TitleValueKey: titleController.text,
          LocationValueKey: locationController.text,
          FromValueKey: fromController.text,
          ToValueKey: toController.text,
          IsAllDayValueKey: isAllDayController.text,
          IsYearlyValueKey: isYearlyController.text,
        },
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    titleController.dispose();
    locationController.dispose();
    fromController.dispose();
    toController.dispose();
    isAllDayController.dispose();
    isYearlyController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get titleValue => this.formValueMap[TitleValueKey];
  String get locationValue => this.formValueMap[LocationValueKey];
  String get fromValue => this.formValueMap[FromValueKey];
  String get toValue => this.formValueMap[ToValueKey];
  String get isAllDayValue => this.formValueMap[IsAllDayValueKey];
  String get isYearlyValue => this.formValueMap[IsYearlyValueKey];
}
