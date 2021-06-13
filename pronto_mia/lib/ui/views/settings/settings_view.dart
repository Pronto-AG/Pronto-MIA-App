import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/views/settings/settings_view.form.dart';
import 'package:pronto_mia/ui/views/settings/settings_viewmodel.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';

class SettingsView extends StatelessWidget with $SettingsView {
  final _formKey = GlobalKey<FormState>();
  final bool isDialog;

  SettingsView({Key key, this.isDialog = false}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<SettingsViewModel>.reactive(
          viewModelBuilder: () => SettingsViewModel(
                isDialog: isDialog,
              ),
          onModelReady: (model) => listenToFormUpdated(model),
          builder: (context, model, child) {
            if (isDialog) {
              return _buildDialogLayout(model);
            } else {
              return _buildStandaloneLayout(model);
            }
          });

  Widget _buildStandaloneLayout(SettingsViewModel model) => Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  // ignore: sized_box_for_whitespace
  Widget _buildDialogLayout(SettingsViewModel model) => Container(
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
    const title = 'Benutzereinstellungen';

    if (isDialog) {
      return Container(
          padding: const EdgeInsets.all(16.0),
          child: const Text(
            title,
            style: TextStyle(fontSize: 20.0),
          ));
    } else {
      return const Text(title);
    }
  }

  Widget _buildForm(SettingsViewModel model) => Form(
        key: _formKey,
        child: FormLayout(
          textFields: [
            TextFormField(
              controller: oldPasswordController,
              onEditingComplete: model.submitForm,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Aktuelles Passwort'),
            ),
            TextFormField(
              controller: newPasswordController,
              onEditingComplete: model.submitForm,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Neues Passwort'),
            ),
          ],
          primaryButton: ButtonSpecification(
            title: 'Passwort ändern',
            onTap: model.submitForm,
            isBusy: model.busy(SettingsViewModel.changePasswordActionKey),
          ),
          secondaryButton: ButtonSpecification(
            title: 'Abmelden',
            onTap: model.logout,
            isBusy: model.busy(SettingsViewModel.logoutActionKey),
          ),
          validationMessage: model.validationMessage,
        ),
      );
}
