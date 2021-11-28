import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

const String CompanyValueKey = 'company';
const String FirstNameValueKey = 'firstname';
const String LastnameValueKey = 'lastname';
const String StreetValueKey = 'street';
const String PlzValueKey = 'plz';
const String LocationValueKey = 'location';
const String PhoneValueKey = 'phone';
const String MobileValueKey = 'mobile';
const String MailValueKey = 'mail';
const String AdditionalInterestsValueKey = 'additionalInterests';
const String RemarksValueKey = 'remarks';

mixin $InquiryView on StatefulWidget {
  final TextEditingController companyController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastnameController = TextEditingController();
  final TextEditingController streetController = TextEditingController();
  final TextEditingController plzController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController additionalInterestsController =
      TextEditingController();
  final TextEditingController remarksController = TextEditingController();
  final FocusNode companyFocusNode = FocusNode();
  final FocusNode firstNameFocusNode = FocusNode();
  final FocusNode lastnameFocusNode = FocusNode();
  final FocusNode streetFocusNode = FocusNode();
  final FocusNode plzFocusNode = FocusNode();
  final FocusNode locationFocusNode = FocusNode();
  final FocusNode phoneFocusNode = FocusNode();
  final FocusNode mobileFocusNode = FocusNode();
  final FocusNode mailFocusNode = FocusNode();
  final FocusNode additionalInterestsFocusNode = FocusNode();
  final FocusNode remarksFocusNode = FocusNode();

  /// Registers a listener on every generated controller that calls [model.setData()]
  /// with the latest textController values
  void listenToFormUpdated(FormViewModel model) {
    companyController.addListener(() => _updateFormData(model));
    firstNameController.addListener(() => _updateFormData(model));
    lastnameController.addListener(() => _updateFormData(model));
    streetController.addListener(() => _updateFormData(model));
    plzController.addListener(() => _updateFormData(model));
    locationController.addListener(() => _updateFormData(model));
    phoneController.addListener(() => _updateFormData(model));
    mobileController.addListener(() => _updateFormData(model));
    mailController.addListener(() => _updateFormData(model));
    additionalInterestsController.addListener(() => _updateFormData(model));
    remarksController.addListener(() => _updateFormData(model));
  }

  /// Updates the formData on the FormViewModel
  void _updateFormData(FormViewModel model) => model.setData(
        {
          CompanyValueKey: companyController.text,
          FirstNameValueKey: firstNameController.text,
          LastnameValueKey: lastnameController.text,
          StreetValueKey: streetController.text,
          PlzValueKey: plzController.text,
          LocationValueKey: locationController.text,
          PhoneValueKey: phoneController.text,
          MobileValueKey: mobileController.text,
          MailValueKey: mailController.text,
          AdditionalInterestsValueKey: additionalInterestsController.text,
          RemarksValueKey: remarksController.text,
        },
      );

  /// Calls dispose on all the generated controllers and focus nodes
  void disposeForm() {
    companyController.dispose();
    firstNameController.dispose();
    lastnameController.dispose();
    streetController.dispose();
    plzController.dispose();
    locationController.dispose();
    phoneController.dispose();
    mobileController.dispose();
    mailController.dispose();
    additionalInterestsController.dispose();
    remarksController.dispose();
  }
}

extension ValueProperties on FormViewModel {
  String get companyValue => this.formValueMap[CompanyValueKey];
  String get firstNamneValue => this.formValueMap[FirstNameValueKey];
  String get lastnameValue => this.formValueMap[LastnameValueKey];
  String get streetValue => this.formValueMap[StreetValueKey];
  String get plzValue => this.formValueMap[PlzValueKey];
  String get locationValue => this.formValueMap[LocationValueKey];
  String get phoneValue => this.formValueMap[PhoneValueKey];
  String get mobileValue => this.formValueMap[MobileValueKey];
  String get mailValue => this.formValueMap[MailValueKey];
  String get additionalInterestsValue =>
      this.formValueMap[AdditionalInterestsValueKey];
  String get remarksValue => this.formValueMap[RemarksValueKey];
}
