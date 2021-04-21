import 'dart:io';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_view.form.dart';
import 'package:pronto_mia/ui/views/deployment_plan/edit/deployment_plan_edit_viewmodel.dart';

@FormView(fields: [
  FormTextField(name: 'pdfPath'),
  FormTextField(name: 'availableFrom'),
  FormTextField(name: 'availableUntil'),
])
class DeploymentPlanEditView extends StatelessWidget with $DeploymentPlanEditView {
  DeploymentPlanEditView({Key key}) : super(key: key);

  Future<void> handlePdfUpload(DeploymentPlanEditViewModel model) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      pdfPathController.text = result.names.single;
    }

    model.pdfFile = File(result.files.single.path);
  }

  // TODO: Implement update and delete

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeploymentPlanEditViewModel>.reactive(
      viewModelBuilder: () => DeploymentPlanEditViewModel(),
      onModelReady: (model) => listenToFormUpdated(model),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Einsatzplan erstellen')
        ),
        body: Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                controller: availableFromController,
                firstDate: DateTime.now(),
                lastDate: DateTime(9999),
                dateMask: 'dd.MM.yyyy HH:mm',
                dateLabelText: 'Gültig ab',
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: DateTimePicker(
                  type: DateTimePickerType.dateTime,
                  controller: availableUntilController,
                  firstDate: DateTime.now(),
                  lastDate: DateTime(9999),
                  dateMask: 'dd.MM.yyyy HH:mm',
                  dateLabelText: 'Gültig bis',
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.ideographic,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: TextButton(
                        onPressed: () => handlePdfUpload(model),
                        child: const Text('Datei hochladen'),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: pdfPathController,
                        readOnly: true,
                      ),
                    ),
                  ],
                )
              ),

              Padding(
                padding:
                const EdgeInsets.only(top: 32.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: model.submitDeploymentPlan,
                    child: const Text('Erstellen'),
                  ),
                ),
              ),
            ]
          )
        ),
      ),
    );
  }
}