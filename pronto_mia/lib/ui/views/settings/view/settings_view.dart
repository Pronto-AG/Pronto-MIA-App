import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/shared/password_field.dart';
import 'package:pronto_mia/ui/views/settings/view/settings_view.form.dart';
import 'package:pronto_mia/ui/views/settings/view/settings_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the settings view with options change
/// the users password.
class SettingsView extends StatelessWidget with $SettingsView {
  final _formKey = GlobalKey<FormState>();
  final bool isDialog;

  /// Initializes a new instance of [DeploymentPlanEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to open it as a dialog or standalone as an input.
  SettingsView({Key key, this.isDialog = false}) : super(key: key);

  /// Binds [SettingsViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
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
        },
      );

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
    const title = 'Passwort ändern';

    if (isDialog) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        child: const Text(
          title,
          style: TextStyle(fontSize: 20.0),
        ),
      );
    } else {
      return const Text(title);
    }
  }

  Widget _buildForm(SettingsViewModel model) => Form(
        key: _formKey,
        child: FormLayout(
          textFields: [
            PasswordField(
              controller: oldPasswordController,
              submitForm: model.submitForm,
              labelText: 'Aktuelles Passwort',
            ),
            PasswordField(
              controller: newPasswordController,
              submitForm: model.submitForm,
              labelText: 'Neues Passwort',
            ),
            PasswordField(
              controller: passwordConfirmController,
              submitForm: model.submitForm,
              labelText: 'Passwort bestätigen',
            ),
          ],
          primaryButton: ButtonSpecification(
            title: 'Passwort ändern',
            onTap: model.submitForm,
            isBusy: model.busy(SettingsViewModel.changePasswordActionKey),
          ),
          validationMessage: model.validationMessage,
        ),
      );
}
