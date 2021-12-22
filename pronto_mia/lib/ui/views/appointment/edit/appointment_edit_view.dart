import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/appointment.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/views/appointment/edit/appointment_edit_view.form.dart';
import 'package:pronto_mia/ui/views/appointment/edit/appointment_edit_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the form to create and update appointments.
class AppointmentEditView extends StatelessWidget with $AppointmentEditView {
  final _formKey = GlobalKey<FormState>();
  final Appointment appointment;
  final bool isDialog;
  final DateTime selectedDate;

  /// Initializes a new instance of [AppointmentEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [Appointment] to edit and a [bool] wether to open it as a dialog or
  /// standalone as an input.
  AppointmentEditView({
    Key key,
    this.appointment,
    this.isDialog = false,
    this.selectedDate,
  }) : super(key: key) {
    if (appointment != null) {
      titleController.text = appointment.title;
      locationController.text = appointment.location;
      fromController.text = appointment.from.toString();
      toController.text = appointment.to.toString();
      isAllDayController.text = appointment.isAllDay.toString();
      isYearlyController.text = appointment.isYearly.toString();
    } else if (selectedDate != null) {
      fromController.text = selectedDate
          .subtract(Duration(minutes: selectedDate.minute))
          .toString();
      toController.text = selectedDate
          .subtract(Duration(minutes: selectedDate.minute))
          .add(const Duration(hours: 1))
          .toString();
    }
  }

  /// Binds [AppointmentEditViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<AppointmentEditViewModel>.reactive(
        viewModelBuilder: () => AppointmentEditViewModel(
          appointment: appointment,
          isDialog: isDialog,
        ),
        onModelReady: (model) {
          listenToFormUpdated(model);
        },
        builder: (context, model, child) {
          if (isDialog) {
            return _buildDialogLayout(model);
          } else {
            return _buildStandaloneLayout(model);
          }
        },
      );

  Widget _buildStandaloneLayout(AppointmentEditViewModel model) => Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  // ignore: sized_box_for_whitespace
  Widget _buildDialogLayout(AppointmentEditViewModel model) => Container(
        width: 500.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitle(),
            _buildForm(model),
          ],
        ),
      );

  Widget _buildTitle() {
    final title = appointment == null
        ? 'Kalendereintrag erstellen'
        : 'Kalendereintrag bearbeiten';

    if (isDialog) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          title,
          style: const TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return Text(title);
    }
  }

  Widget _buildForm(AppointmentEditViewModel model) => Form(
        key: _formKey,
        child: FormLayout(
          textFields: [
            TextFormField(
              controller: titleController,
              onEditingComplete: model.submitForm,
              decoration: const InputDecoration(labelText: 'Bezeichnung*'),
            ),
            TextFormField(
              controller: locationController,
              onEditingComplete: model.submitForm,
              decoration: const InputDecoration(labelText: 'Ort'),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              controller: fromController,
              onEditingComplete: model.submitForm,
              firstDate: appointment != null
                  ? appointment.from
                  : selectedDate
                      .subtract(Duration(minutes: DateTime.now().minute)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              dateMask: 'dd.MM.yyyy HH:mm',
              dateLabelText: 'Startzeit*',
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              controller: toController,
              onEditingComplete: model.submitForm,
              firstDate: appointment != null
                  ? appointment.to
                  : selectedDate
                      .subtract(Duration(minutes: DateTime.now().minute))
                      .add(const Duration(hours: 1)),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              dateMask: 'dd.MM.yyyy HH:mm',
              dateLabelText: 'Endzeit*',
            ),
            SwitchListTile(
              value: isAllDayController.text.toLowerCase() == 'true',
              onChanged: (value) {
                isAllDayController.text = value.toString();
              },
              title: const Text('Ganzer Tag'),
            ),
            SwitchListTile(
              value: isYearlyController.text.toLowerCase() == 'true',
              onChanged: (value) {
                isYearlyController.text = value.toString();
              },
              title: const Text('Jährlich'),
            ),
          ],
          primaryButton: ButtonSpecification(
            title: 'Speichern',
            onTap: model.submitForm,
            isBusy: model.busy(AppointmentEditViewModel.editActionKey),
          ),
          secondaryButton: (() {
            if (appointment != null) {
              return ButtonSpecification(
                title: 'Löschen',
                onTap: model.removeAppointment,
                isBusy: model.busy(AppointmentEditViewModel.removeActionKey),
                isDestructive: true,
              );
            }
          })(),
          validationMessage: model.validationMessage,
        ),
      );
}
