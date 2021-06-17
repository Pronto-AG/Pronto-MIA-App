import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_viewmodel.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/core/models/department.dart';

/// A widget, representing the form to create and update deployment plans.
class DeploymentPlanEditView extends StatelessWidget
    with $DeploymentPlanEditView {
  final _formKey = GlobalKey<FormState>();
  final DeploymentPlan deploymentPlan;
  final bool isDialog;

  /// Initializes a new instance of [DeploymentPlanEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [DeploymentPlan] to edit and a [bool] wether to open it as a dialog or
  /// standalone as an input.
  DeploymentPlanEditView({
    Key key,
    this.deploymentPlan,
    this.isDialog = false,
  }) : super(key: key) {
    if (deploymentPlan != null) {
      descriptionController.text = deploymentPlan.description;
      availableFromController.text = deploymentPlan.availableFrom.toString();
      availableUntilController.text = deploymentPlan.availableUntil.toString();
      pdfPathController.text = 'upload.pdf';
    }
  }

  Future<void> _handlePdfUpload(DeploymentPlanEditViewModel model) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      pdfPathController.text = result.names.single;
      SimpleFile fileUpload;

      if (kIsWeb) {
        fileUpload = SimpleFile(
            name: result.names.single, bytes: result.files.single.bytes);
      } else {
        final file = File(result.files.single.path);
        fileUpload = SimpleFile(
            name: result.names.single, bytes: file.readAsBytesSync());
      }
      model.setPdfUpload(fileUpload);
    }
  }

  /// Binds [DeploymentPLanEditViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<DeploymentPlanEditViewModel>.reactive(
        viewModelBuilder: () => DeploymentPlanEditViewModel(
          deploymentPlan: deploymentPlan,
          isDialog: isDialog,
        ),
        onModelReady: (model) {
          listenToFormUpdated(model);
          model.fetchDepartments();

          if (deploymentPlan != null) {
            model.setDepartment(deploymentPlan.department);
          }
        },
        builder: (context, model, child) {
          if (isDialog) {
            return _buildDialogLayout(model);
          } else {
            return _buildStandaloneLayout(model);
          }
        },
      );

  Widget _buildStandaloneLayout(DeploymentPlanEditViewModel model) => Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  // ignore: sized_box_for_whitespace
  Widget _buildDialogLayout(DeploymentPlanEditViewModel model) => Container(
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
    final title = deploymentPlan == null
        ? 'Einsatzplan erstellen'
        : 'Einsatzplan bearbeiten';

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

  Widget _buildForm(DeploymentPlanEditViewModel model) => Form(
        key: _formKey,
        child: FormLayout(
          textFields: [
            TextFormField(
              controller: descriptionController,
              onEditingComplete: model.submitForm,
              decoration: const InputDecoration(labelText: 'Bezeichnung'),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              controller: availableFromController,
              onEditingComplete: model.submitForm,
              firstDate: deploymentPlan != null
                  ? deploymentPlan.availableFrom
                  : DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              dateMask: 'dd.MM.yyyy HH:mm',
              dateLabelText: 'Gültig ab*',
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              controller: availableUntilController,
              onEditingComplete: model.submitForm,
              firstDate: deploymentPlan != null
                  ? deploymentPlan.availableUntil
                  : DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              dateMask: 'dd.MM.yyyy HH:mm',
              dateLabelText: 'Gültig bis*',
            ),
            DropdownButtonFormField<Department>(
                value:
                    deploymentPlan != null && model.availableDepartments != null
                        ? model.availableDepartments.firstWhere(
                            (department) =>
                                department.id == deploymentPlan.department.id,
                            orElse: () => null)
                        : null,
                onChanged: model.setDepartment,
                decoration: const InputDecoration(labelText: 'Abteilung'),
                items: model.availableDepartments
                    ?.map<DropdownMenuItem<Department>>(
                      (department) => DropdownMenuItem<Department>(
                        value: department,
                        child: Text(department.name),
                      ),
                    )
                    ?.toList()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                TextButton(
                  onPressed: () => _handlePdfUpload(model),
                  child: const Text('Datei hochladen'),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextFormField(
                    controller: pdfPathController,
                    readOnly: true,
                    onTap: pdfPathController.text == null ||
                            pdfPathController.text.isEmpty
                        ? () => _handlePdfUpload(model)
                        : model.openPdf,
                    decoration: const InputDecoration(labelText: 'Dateiname *'),
                    style: const TextStyle(color: CustomColors.link),
                  ),
                ),
              ],
            ),
          ],
          primaryButton: ButtonSpecification(
            title: 'Speichern',
            onTap: model.submitForm,
            isBusy: model.busy(DeploymentPlanEditViewModel.editActionKey),
          ),
          secondaryButton: (() {
            if (deploymentPlan != null) {
              return ButtonSpecification(
                title: 'Löschen',
                onTap: model.removeDeploymentPlan,
                isBusy: model.busy(DeploymentPlanEditViewModel.removeActionKey),
                isDestructive: true,
              );
            }
          })(),
          validationMessage: model.validationMessage,
        ),
      );
}
