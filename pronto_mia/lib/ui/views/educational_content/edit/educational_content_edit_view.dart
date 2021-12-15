import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/shared/html_toolbar.dart';
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
          return _buildStandaloneLayout(model);
        },
      );

  Widget _buildStandaloneLayout(EducationalContentEditViewModel model) =>
      Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
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

  HtmlEditorOptions _withcontent() {
    return HtmlEditorOptions(
      initialText: educationalContent.description,
      autoAdjustHeight: false,
    );
  }

  HtmlEditorOptions _withoutcontent() {
    return const HtmlEditorOptions(
      hint: "Text eingeben",
      autoAdjustHeight: false,
    );
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
            Container(
              alignment: Alignment.centerLeft,
              child: HtmlEditor(
                controller: htmlEditorController,
                callbacks: Callbacks(
                  onChangeContent: (String value) => {
                    listenToFormUpdated(model),
                  },
                ),
                otherOptions: const OtherOptions(
                  height: 300,
                ),
                htmlEditorOptions: educationalContent != null
                    ? _withcontent()
                    : _withoutcontent(),
                htmlToolbarOptions: htmlToolbarSettings(),
              ),
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
                    onTap: videoPathController.text == null ||
                            videoPathController.text.isEmpty
                        ? () => _handleVideoUpload(model)
                        : model.openVideo,
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
          cancelButton: (() {
            if (educationalContent == null) {
              return ButtonSpecification(
                title: 'Abbrechen',
                onTap: model.cancelForm,
                isBusy: model.isBusy,
              );
            }
          })(),
          validationMessage: model.validationMessage,
        ),
      );
}
