import 'dart:io';

import 'package:date_time_picker/date_time_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/shared/html_toolbar.dart';
import 'package:pronto_mia/ui/views/internal_news/edit/internal_news_edit_view.form.dart';
import 'package:pronto_mia/ui/views/internal_news/edit/internal_news_edit_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the form to create and update internal news.
class InternalNewsEditView extends StatelessWidget with $InternalNewsEditView {
  final _formKey = GlobalKey<FormState>();
  final InternalNews internalNews;
  final bool isDialog;

  /// Initializes a new instance of [InternalNewsEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [InternalNews] to edit and a [bool] wether to open it as a dialog or
  /// standalone as an input.
  InternalNewsEditView({
    Key key,
    this.internalNews,
    this.isDialog = false,
  }) : super(key: key) {
    if (internalNews != null) {
      titleController.text = internalNews.title;
      availableFromController.text = internalNews.availableFrom.toString();
      imagePathController.text = "upload.png";
    }
  }

  Future<void> _handleImageUpload(InternalNewsEditViewModel model) async {
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

  /// Binds [InternalNewsEditViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<InternalNewsEditViewModel>.reactive(
        viewModelBuilder: () => InternalNewsEditViewModel(
          internalNews: internalNews,
          isDialog: isDialog,
        ),
        onModelReady: (model) {
          listenToFormUpdated(model);
        },
        builder: (context, model, child) {
          return _buildStandaloneLayout(model);
        },
      );

  Widget _buildStandaloneLayout(InternalNewsEditViewModel model) => Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  Widget _buildTitle() {
    final title =
        internalNews == null ? 'Neuigkeit erstellen' : 'Neuigkeit bearbeiten';

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
      initialText: internalNews.description,
      autoAdjustHeight: false,
    );
  }

  HtmlEditorOptions _withoutcontent() {
    return const HtmlEditorOptions(
      hint: "Text eingeben",
      autoAdjustHeight: false,
    );
  }

  Widget _buildForm(InternalNewsEditViewModel model) => Form(
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
                    internalNews != null ? _withcontent() : _withoutcontent(),
                htmlToolbarOptions: htmlToolbarSettings(),
              ),
            ),
            DateTimePicker(
              type: DateTimePickerType.dateTime,
              controller: availableFromController,
              onEditingComplete: model.submitForm,
              firstDate: internalNews != null
                  ? internalNews.availableFrom
                  : DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
              dateMask: 'dd.MM.yyyy HH:mm',
              dateLabelText: 'G??ltig ab*',
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
            isBusy: model.busy(InternalNewsEditViewModel.editActionKey),
          ),
          secondaryButton: (() {
            if (internalNews != null) {
              return ButtonSpecification(
                title: 'L??schen',
                onTap: model.removeInternalNews,
                isBusy: model.busy(InternalNewsEditViewModel.removeActionKey),
                isDestructive: true,
              );
            }
          })(),
          cancelButton: (() {
            if (internalNews == null) {
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
