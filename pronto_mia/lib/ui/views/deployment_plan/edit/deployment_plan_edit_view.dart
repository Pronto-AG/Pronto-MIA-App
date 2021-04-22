import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'description'),
  FormTextField(name: 'pdfPath'),
  FormTextField(name: 'availableFrom'),
  FormTextField(name: 'availableUntil'),
])
class DeploymentPlanEditView extends StatelessWidget
    with $DeploymentPlanEditView {
  final DeploymentPlan deploymentPlan;

  DeploymentPlanEditView({Key key, this.deploymentPlan}) : super(key: key);

  Future<void> handlePdfUpload(DeploymentPlanEditViewModel model) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null) {
      pdfPathController.text = result.names.single;
    }

    model.setPdfUpload(result.files.single);
  }

  // TODO: Implement update and delete

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeploymentPlanEditViewModel>.reactive(
      viewModelBuilder: () => DeploymentPlanEditViewModel(),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: const Text('Einsatzplan erstellen')),
        body: Container(
            padding: const EdgeInsets.all(16.0),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Bezeichnung',
                  hintText: 'Geben Sie hier eine optionale Bezeichnung ein.',
                ),
              ),
              const SizedBox(height: 8.0),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                controller: availableFromController,
                firstDate: DateTime.now(),
                lastDate: DateTime(9999),
                dateMask: 'dd.MM.yyyy HH:mm',
                dateLabelText: 'Gültig ab',
                dateHintText: 'Geben Sie hier das Startdatum ein.',
              ),
              const SizedBox(height: 8.0),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                controller: availableUntilController,
                firstDate: DateTime.now(),
                lastDate: DateTime(9999),
                dateMask: 'dd.MM.yyyy HH:mm',
                dateLabelText: 'Gültig bis',
                dateHintText: ' Geben Sie hier das Enddatum ein.',
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
                    ),
                  ),
                  if (model.pdfUpload != null)
                    TextButton(
                      onPressed: model.openPdf,
                      child: const Text('Anzeigen'),
                    )
                ],
              ),
              const SizedBox(height: 16.0),
              SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: model.submitForm,
                    child: const Text('Erstellen'),
                  )),
              if (model.validationMessage != null) ...[
                const SizedBox(height: 8.0),
                Text(
                  model.validationMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ])),
      ),
    );
  }
}
