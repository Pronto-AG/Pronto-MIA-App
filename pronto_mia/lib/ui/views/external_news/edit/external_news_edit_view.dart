import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/shared/html_toolbar.dart';
import 'package:pronto_mia/ui/views/external_news/edit/external_news_edit_view.form.dart';
import 'package:pronto_mia/ui/views/external_news/edit/external_news_edit_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the form to create and update external news.
class ExternalNewsEditView extends StatelessWidget with $ExternalNewsEditView {
  final _formKey = GlobalKey<FormState>();
  final ExternalNews externalNews;

  /// Initializes a new instance of [ExternalNewsEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [ExternalNews] to edit and a [bool] wether to open it as a dialog or
  /// standalone as an input.
  ExternalNewsEditView({
    Key key,
    this.externalNews,
  }) : super(key: key) {
    if (externalNews != null) {
      titleController.text = externalNews.title;
      availableFromController.text = externalNews.availableFrom.toString();
      imagePathController.text = "upload.png";
    }
  }

  Future<void> _handleImageUpload(ExternalNewsEditViewModel model) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png'],
    );
    if (result != null) {
      imagePathController.text = result.names.single;
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
      model.setImageUpload(fileUpload);
    }
  }

  /// Binds [ExternalNewsEditViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<ExternalNewsEditViewModel>.reactive(
        viewModelBuilder: () => ExternalNewsEditViewModel(
          externalNews: externalNews,
        ),
        onModelReady: (model) {
          listenToFormUpdated(model);
        },
        builder: (context, model, child) {
          return _buildStandaloneLayout(model);
        },
      );

  Widget _buildStandaloneLayout(ExternalNewsEditViewModel model) {
    return Scaffold(
      appBar: AppBar(title: _buildTitle()),
      body: _buildForm(model),
    );
  }

  Widget _buildTitle() => Text(
        externalNews == null ? 'Neuigkeit erstellen' : 'Neuigkeit bearbeiten',
      );

  HtmlEditorOptions _withcontent() {
    return HtmlEditorOptions(
      initialText: externalNews.description,
      autoAdjustHeight: false,
    );
  }

  HtmlEditorOptions _withoutcontent() {
    return const HtmlEditorOptions(
      hint: "Text eingeben",
      autoAdjustHeight: false,
    );
  }

  Widget _buildForm(ExternalNewsEditViewModel model) => Form(
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
                htmlEditorOptions:
                    externalNews != null ? _withcontent() : _withoutcontent(),
                htmlToolbarOptions: htmlToolbarSettings(),
              ),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              controller: availableFromController,
              onEditingComplete: model.submitForm,
              firstDate: externalNews != null
                  ? externalNews.availableFrom
                  : DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              dateMask: 'dd.MM.yyyy HH:mm',
              dateLabelText: 'Gültig ab*',
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.ideographic,
              children: [
                TextButton(
                  onPressed: () => _handleImageUpload(model),
                  child: const Text('Datei hochladen'),
                ),
                const SizedBox(width: 8.0),
                Expanded(
                  child: TextFormField(
                    controller: imagePathController,
                    readOnly: true,
                    onTap: imagePathController.text == null ||
                            imagePathController.text.isEmpty
                        ? () => _handleImageUpload(model)
                        : model.openImage,
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
            isBusy: model.busy(ExternalNewsEditViewModel.editActionKey),
          ),
          secondaryButton: (() {
            if (externalNews != null) {
              return ButtonSpecification(
                title: 'Löschen',
                onTap: model.removeExternalNews,
                isBusy: model.busy(ExternalNewsEditViewModel.removeActionKey),
                isDestructive: true,
              );
            }
          })(),
          cancelButton: (() {
            if (externalNews == null) {
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
