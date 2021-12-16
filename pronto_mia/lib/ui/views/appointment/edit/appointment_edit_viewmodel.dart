import 'package:flutter/foundation.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/appointment.dart';
import 'package:pronto_mia/core/services/appointment_service.dart';
import 'package:pronto_mia/core/services/error_service.dart';
import 'package:pronto_mia/ui/views/appointment/edit/appointment_edit_view.form.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A view model, providing functionality for [AppointmentEditView].
class AppointmentEditViewModel extends FormViewModel {
  static const contextIdentifier = "AppointmentEditViewModel";
  static const editActionKey = 'EditActionKey';
  static const removeActionKey = 'RemoveActionKey';

  AppointmentService get _appointmentService =>
      locator.get<AppointmentService>();
  NavigationService get _navigationService => locator.get<NavigationService>();
  DialogService get _dialogService => locator.get<DialogService>();
  ErrorService get _errorService => locator.get<ErrorService>();

  final bool isDialog;
  final Appointment appointment;

  /// Initializes a new instance of [AppointmentEditViewModel]
  ///
  /// Takes the [Appointment] to edit and a [bool] wether the form should be
  /// displayed as a dialog or standalone as an input.
  AppointmentEditViewModel({
    @required this.appointment,
    this.isDialog = false,
  });

  /// Resets errors and messages, as soon as form fields update.
  @override
  void setFormStatus() {
    clearErrors();
  }

  /// Validates the form and either creates or updates a [Appointment].
  ///
  /// After the form has been submitted successfully, it closes the dialog in
  /// case it was opened as a dialog or navigates to the previous view if
  /// opened as standalone.
  Future<void> submitForm() async {
    final validationMessage = _validateForm();
    if (validationMessage != null) {
      setValidationMessage(validationMessage);
      notifyListeners();
      return;
    }

    final from = DateTime.parse(fromValue);
    final to = DateTime.parse(toValue);
    final isAllDay = isAllDayValue.toLowerCase() == 'true';
    final isYearly = isYearlyValue.toLowerCase() == 'true';

    if (appointment == null) {
      await runBusyFuture(
        _appointmentService.createAppointment(
          title: titleValue,
          location: locationValue,
          from: from,
          to: to,
          isAllDay: isAllDay,
          isYearly: isYearly,
        ),
        busyObject: editActionKey,
      );
    } else {
      await runBusyFuture(
        _appointmentService.updateAppointment(
          appointment.id,
          title: appointment.title != titleValue ? titleValue : null,
          location:
              appointment.location != locationValue ? locationValue : null,
          from: !appointment.from.isAtSameMomentAs(from) ? from : null,
          to: !appointment.to.isAtSameMomentAs(to) ? to : null,
          isAllDay: isAllDay,
          isYearly: isYearly,
        ),
        busyObject: editActionKey,
      );
    }

    _completeFormAction(editActionKey);
  }

  /// Removes the [Appointment] contained in the form.
  ///
  /// After the [Appointment] has been removed successfully, closes dialog
  /// when opened as a dialog or navigates to the previous view, when opened as
  /// standalone.
  Future<void> removeAppointment() async {
    if (appointment != null) {
      await runBusyFuture(
        _appointmentService.removeAppointment(appointment.id),
        busyObject: removeActionKey,
      );
    }

    _completeFormAction(removeActionKey);
  }

  String _validateForm() {
    if (titleValue == null || titleValue.isEmpty) {
      return 'Bitte Titel eingeben.';
    }

    if (fromValue == null || fromValue.isEmpty) {
      return 'Bitte Startzeit eingeben.';
    }

    if (toValue == null || toValue.isEmpty) {
      return 'Bitte Endzeit eingeben.';
    }

    final from = DateTime.parse(fromValue);
    final to = DateTime.parse(toValue);
    if (!from.isBefore(to)) {
      return 'Die Startzeit muss vor der Endzeit liegen.';
    }

    return null;
  }

  Future<void> _completeFormAction(String actionKey) async {
    if (hasErrorForKey(actionKey)) {
      await _errorService.handleError(
        AppointmentEditViewModel.contextIdentifier,
        error(actionKey),
      );
      final errorMessage = _errorService.getErrorMessage(error(actionKey));
      setValidationMessage(errorMessage);
      notifyListeners();
    } else if (isDialog) {
      _dialogService.completeDialog(DialogResponse(confirmed: true));
    } else {
      _navigationService.back(result: true);
    }
  }
}
