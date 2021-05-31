import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/views/user/edit/user_edit_view.form.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_viewmodel.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/core/models/profiles.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';

class UserEditView extends StatelessWidget with $UserEditView {
  final _formKey = GlobalKey<FormState>();
  final User user;
  final bool isDialog;

  UserEditView({
    Key key,
    this.user,
    this.isDialog = false,
  }) : super(key: key) {
    if (user != null) {
      userNameController.text = user.userName;
      passwordController.text = 'XXXXXX';
      passwordConfirmController.text = 'XXXXXX';
    }
  }

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<UserEditViewModel>.reactive(
        viewModelBuilder: () => UserEditViewModel(
          user: user,
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

  Widget _buildStandaloneLayout(UserEditViewModel model) => Scaffold(
        appBar: AppBar(title: _buildTitle()),
        body: _buildForm(model),
      );

  // ignore: sized_box_for_whitespace
  Widget _buildDialogLayout(UserEditViewModel model) => Container(
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
    final title = user == null ? 'Benutzer erstellen' : 'Benutzer bearbeiten';

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

  Widget _buildForm(UserEditViewModel model) => Form(
        key: _formKey,
        child: FormLayout(
          textFields: [
            _buildFormSectionHeader('Benutzerinformationen'),
            TextFormField(
              controller: userNameController,
              onEditingComplete: model.submitForm,
              decoration: const InputDecoration(labelText: 'Benutzername'),
            ),
            TextFormField(
              controller: passwordController,
              onEditingComplete: model.submitForm,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Passwort'),
            ),
            TextFormField(
              controller: passwordConfirmController,
              onEditingComplete: model.submitForm,
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Passwort bestätigen'),
            ),
            _buildFormSectionHeader('Berechtigungen'),
            DropdownButtonFormField<Profile>(
              // value: Profiles.administrator,
              onChanged: model.setProfile,
              decoration: const InputDecoration(labelText: 'Profil'),
              items: [
                DropdownMenuItem(
                  value: Profiles.empty,
                  child: Text(Profiles.empty.description),
                ),
                DropdownMenuItem(
                  value: Profiles.cleaner,
                  child: Text(Profiles.cleaner.description),
                ),
                DropdownMenuItem(
                  value: Profiles.administrator,
                  child: Text(Profiles.administrator.description),
                ),
              ],
            ),
            _buildSwitchGroupLayout(model),
          ],
          primaryButton: ButtonSpecification(
            title: 'Speichern',
            onTap: model.submitForm,
            isBusy: model.busy(UserEditViewModel.editBusyKey),
          ),
          secondaryButton: user != null
              ? ButtonSpecification(
                  title: 'Löschen',
                  onTap: model.removeUser,
                  isBusy: model.busy(UserEditViewModel.removeBusyKey),
                  isDestructive: true,
                )
              : null,
          validationMessage: model.validationMessage,
        ),
      );

  Widget _buildFormSectionHeader(String title) => Row(
    children: [
      Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      const Expanded(
        child: Padding(
          padding: EdgeInsets.only(left: 8.0),
          child: Divider(),
        ),
      ),
    ],
  );

  Widget _buildSwitchGroupLayout(UserEditViewModel model) => Column(
    children: [
      _buildLabeledSwitch(model, 'Einsatzpläne ansehen', 'canViewDeploymentPlans', model.accessControlList.canViewDeploymentPlans),
      _buildLabeledSwitch(model, 'Einsatzpläne verwalten', 'canEditDeploymentPlans', model.accessControlList.canEditDeploymentPlans),
      _buildLabeledSwitch(model, 'Abteilungen ansehen', 'canViewDepartments', model.accessControlList.canViewDepartments),
      _buildLabeledSwitch(model, 'Abteilungen verwalten', 'canEditDepartments', model.accessControlList.canEditDepartments),
      _buildLabeledSwitch(model, 'Benutzer ansehen', 'canViewUsers', model.accessControlList.canViewUsers),
      _buildLabeledSwitch(model, 'Benutzer verwalten', 'canEditUsers', model.accessControlList.canEditUsers),
    ]
  );

  Widget _buildLabeledSwitch(UserEditViewModel model, String label, String key, bool value,) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(label),
      Switch(
        value: value,
        onChanged: (value) => model.modifyAccessControlList(key, value),
        activeColor: CustomColors.secondary,
      ),
    ],
  );
}
