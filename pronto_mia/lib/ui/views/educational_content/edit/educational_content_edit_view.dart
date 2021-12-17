import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/educational_content/edit/educational_content_edit_view.form.dart';
import 'package:pronto_mia/ui/views/educational_content/edit/educational_content_edit_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the form to create and update educational content.
class EducationalContentEditView extends StatelessWidget
    with $EducationalContentEditView {
  final _formKey = GlobalKey<FormState>();
  final EducationalContent educationalContent;
  final bool isDialog;

  /// Initializes a new instance of [EducationalContentEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [EducationalContent] to edit and a [bool] wether to open it as a dialog or
  /// standalone as an input.
  EducationalContentEditView({
    Key key,
    this.educationalContent,
    this.isDialog = false,
  }) : super(key: key) {
    if (educationalContent != null) {
      titleController.text = educationalContent.title;
      descriptionController.text = educationalContent.description;
      videoPathController.text = "upload.mp4";
    }
  }

  Future<void> _handleVideoUpload(EducationalContentEditViewModel model) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mp4'],
    );
    if (result != null) {
      videoPathController.text = result.names.single;
      SimpleFile fileUpload;

      if (kIsWeb) {
        fileUpload = SimpleFile(
          name: result.names.single,
          bytes: result.files.single.bytes,
        );
      } else {
        final file = File(result.files.single.path);
        fileUpload = SimpleFile(
          name: result.names.single,
          bytes: file.readAsBytesSync(),
        );
      }
      model.setVideoUpload(fileUpload);
    }
  }

  /// Binds [EducationalContentEditViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<EducationalContentEditViewModel>.reactive(
        viewModelBuilder: () => EducationalContentEditViewModel(
          educationalContent: educationalContent,
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

  Widget _buildStandaloneLayout(EducationalContentEditViewModel model) =>
      Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  // ignore: sized_box_for_whitespace
  Widget _buildDialogLayout(EducationalContentEditViewModel model) => Container(
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
    final title = educationalContent == null
        ? 'Schulungsvideo erstellen'
        : 'Schulungsvideo bearbeiten';

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

  Widget _buildForm(EducationalContentEditViewModel model) => Form(
        key: _formKey,
        child: FormLayout(
          textFields: [
            TextFormField(
              controller: titleController,
              onEditingComplete: model.submitForm,
              decoration: const InputDecoration(labelText: 'Titel*'),
            ),
            TextFormField(
              controller: descriptionController,
              onEditingComplete: model.submitForm,
              decoration: const InputDecoration(labelText: 'Inhalt*'),
              keyboardType: TextInputType.multiline,
              maxLines: 15,
              minLines: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                TextButton(
                  onPressed: () => _handleVideoUpload(model),
                  child: const Text('Datei hochladen'),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextFormField(
                    controller: videoPathController,
                    readOnly: true,
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
            isBusy: model.busy(EducationalContentEditViewModel.editActionKey),
          ),
          secondaryButton: (() {
            if (educationalContent != null) {
              return ButtonSpecification(
                title: 'Löschen',
                onTap: model.removeEducationalContent,
                isBusy:
                    model.busy(EducationalContentEditViewModel.removeActionKey),
                isDestructive: true,
              );
            }
          })(),
          validationMessage: model.validationMessage,
        ),
      );
}
