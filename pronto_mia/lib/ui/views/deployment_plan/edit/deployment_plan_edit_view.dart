import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/file_upload.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'description'),
  FormTextField(name: 'availableFrom'),
  FormTextField(name: 'availableUntil'),
  FormTextField(name: 'pdfPath'),
])
class DeploymentPlanEditView extends StatelessWidget
    with $DeploymentPlanEditView {
  final DeploymentPlan deploymentPlan;

  DeploymentPlanEditView({Key key, this.deploymentPlan}) : super(key: key) {
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
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeploymentPlanEditViewModel>.reactive(
      viewModelBuilder: () => DeploymentPlanEditViewModel(
        deploymentPlan: deploymentPlan,
      ),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text(
          deploymentPlan == null
          ? 'Einsatzplan erstellen'
          : 'Einsatzplan bearbeiten'
        )),
        body: Container(
            padding: const EdgeInsets.all(16.0),
            child:
              Column(
                children: [
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Bezeichnung',
                    ),
                  ),
                  const SizedBox(height: 8.0),
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
                  const SizedBox(height: 8.0),
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
                          onTap: model.openPdf,
                          style: const TextStyle(
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  SizedBox(
                    width: double.infinity,
                    height: 40.0,
                    child: ElevatedButton(
                      onPressed: model.submitForm,
                      child: model.busy(model.editBusyKey)
                        ? const SizedBox(
                          width: 16.0,
                          height: 16.0,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            backgroundColor: Colors.blue,
                            strokeWidth: 3,
                          ),
                        )
                        : const Text('Speichern'),
                    ),
                  ),
                  if (deploymentPlan != null)  ...[
                    const SizedBox(height: 8.0),
                    SizedBox(
                      width: double.infinity,
                      height: 40.0,
                      child: OutlinedButton(
                        onPressed: model.removeDeploymentPlan,
                        child: model.busy(model.removeBusyKey)
                          ? const SizedBox(
                            width: 16.0,
                            height: 16.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          )
                          : const Text('Löschen'),
                      ),
                    ),
                  ],
                  if (model.validationMessage != null) ...[
                    const SizedBox(height: 8.0),
                    Text(
                      model.validationMessage,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ],
              ),
            ),
      ),
    );
  }
}
