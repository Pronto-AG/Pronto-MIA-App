import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_viewmodel.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/file_upload.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';

@FormView(fields: [
  FormTextField(name: 'description'),
  FormTextField(name: 'availableFrom'),
  FormTextField(name: 'availableUntil'),
  FormTextField(name: 'pdfPath'),
])
class DeploymentPlanEditView extends StatelessWidget
    with $DeploymentPlanEditView {
  final DeploymentPlan deploymentPlan;
  final bool isDialog;

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

  Future<void> handlePdfUpload(DeploymentPlanEditViewModel model) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      pdfPathController.text = result.names.single;
      FileUpload fileUpload;

      if (kIsWeb) {
        fileUpload = FileUpload(result.names.single, result.files.single.bytes);
      } else {
        final file = File(result.files.single.path);
        fileUpload = FileUpload(result.names.single, file.readAsBytesSync());
      }
      model.setPdfUpload(fileUpload);
    }
  }

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<DeploymentPlanEditViewModel>.reactive(
        viewModelBuilder: () => DeploymentPlanEditViewModel(
          deploymentPlan: deploymentPlan,
          isDialog: isDialog,
        ),
        onModelReady: (model) => listenToFormUpdated(model),
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

  Widget _buildForm(DeploymentPlanEditViewModel model) => FormLayout(
        textFields: [
          TextField(
            controller: descriptionController,
            decoration: const InputDecoration(labelText: 'Bezeichnung'),
          ),
          DateTimePicker(
            type: DateTimePickerType.dateTime,
            controller: availableFromController,
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
            firstDate: deploymentPlan != null
                ? deploymentPlan.availableUntil
                : DateTime.now(),
            lastDate: DateTime.now().add(const Duration(days: 365)),
            dateMask: 'dd.MM.yyyy HH:mm',
            dateLabelText: 'Gültig bis*',
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.ideographic,
            children: [
              TextButton(
                onPressed: () => handlePdfUpload(model),
                child: const Text('Datei hochladen'),
              ),
              const SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  controller: pdfPathController,
                  readOnly: true,
                  onTap: pdfPathController.text == null ||
                          pdfPathController.text.isEmpty
                      ? () => handlePdfUpload(model)
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
          isBusy: model.busy(model.editBusyKey),
        ),
        secondaryButton: (() {
          if (deploymentPlan != null) {
            return ButtonSpecification(
              title: 'Löschen',
              onTap: model.removeDeploymentPlan,
              isBusy: model.busy(model.removeBusyKey),
              isDestructive: true,
            );
          }
        })(),
        validationMessage: model.validationMessage,
      );
}
