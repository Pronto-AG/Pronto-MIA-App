import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/views/user/edit/user_edit_view.form.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_viewmodel.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';

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
}
