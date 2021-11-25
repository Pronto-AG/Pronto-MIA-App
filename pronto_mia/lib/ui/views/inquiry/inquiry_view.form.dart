import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String TitleValueKey = 'title';
const String CompanyValueKey = 'description';
const String FirstnameValueKey = 'availableFrom';
const String LastnameValueKey = 'upload.png';

mixin $InquiryView on StatefulWidget {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController firstnameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController faxController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final FocusNode titleFocusNode = FocusNode();
  final FocusNode companyFocusNode = FocusNode();
  final FocusNode firstnameFocusNode = FocusNode();
  final FocusNode lastnameFocusNode = FocusNode();
  final FocusNode streetFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode faxFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode mailFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    titleController.addListener(() => _updateFormData(model));
    companyController.addListener(() => _updateFormData(model));
    firstnameController.addListener(() => _updateFormData(model));
    lastnameController.addListener(() => _updateFormData(model));
    _updateFormData(model);
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        {
          TitleValueKey: titleController.text,
          CompanyValueKey: companyController.text,
          FirstnameValueKey: firstnameController.text,
          LastnameValueKey: lastnameController.text,
        },
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    titleController.dispose();
    companyController.dispose();
    firstnameController.dispose();
    lastnameController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get titleValue => this.formValueMap[TitleValueKey];
  String get companyValue => this.formValueMap[CompanyValueKey];
  String get firstnamneValue => this.formValueMap[FirstnameValueKey];
  String get lastnameValue => this.formValueMap[LastnameValueKey];
}
