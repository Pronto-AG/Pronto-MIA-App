import 'package:flutter/material.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/core/models/profiles.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_view.form.dart';
import 'package:pronto_mia/ui/views/user/edit/user_edit_viewmodel.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// A widget, representing the form to create and update users.
class UserEditView extends StatelessWidget with $UserEditView {
  final _formKey = GlobalKey<FormState>();
  final User user;
  final bool isDialog;
  List<Department> _selectedDepartments;

  /// Initializes a new instance of [UserEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [User] to edit and a [bool] wether to open it as a dialog or
  /// standalone as an input.
  UserEditView({
    Key key,
    this.user,
    this.isDialog = false,
  }) : super(key: key) {
    if (user != null) {
      userNameController.text = user.userName;
      passwordController.text = 'XXXXXX';
      passwordConfirmController.text = 'XXXXXX';
      _selectedDepartments = user.departments;
    }
  }

  /// Binds [UserEditViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<UserEditViewModel>.reactive(
        viewModelBuilder: () => UserEditViewModel(
          user: user,
          isDialog: isDialog,
        ),
        onModelReady: (model) {
          listenToFormUpdated(model);
          model.fetchDepartments();

          if (user != null) {
            model.setDepartments(user.departments);
          }
        },
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
              onEditingComplete: () => model.submitForm(_selectedDepartments),
              decoration: const InputDecoration(labelText: 'Benutzername'),
            ),
            TextFormField(
              controller: passwordController,
              onEditingComplete: () => model.submitForm(_selectedDepartments),
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Passwort'),
            ),
            TextFormField(
              controller: passwordConfirmController,
              onEditingComplete: () => model.submitForm(_selectedDepartments),
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Passwort bestätigen'),
            ),
            FutureBuilder(
              future: model.getAllDepartments(),
              builder: (
                BuildContext context,
                AsyncSnapshot<List<Department>> departments,
              ) {
                if (departments.hasData) {
                  return MultiSelectDialogField(
                    items: departments.data
                        .map((d) => MultiSelectItem(d, d.name))
                        .toList(),
                    initialValue: _selectedDepartments,
                    listType: MultiSelectListType.LIST,
                    onConfirm: (values) {
                      _selectedDepartments = values as List<Department>;
                    },
                    chipDisplay: MultiSelectChipDisplay(
                      onTap: (Department item) {
                        _selectedDepartments.remove(item);
                        return _selectedDepartments;
                      },
                    ),
                  );
                } else {
                  return MultiSelectDialogField(
                    items: const [],
                    onConfirm: null,
                  );
                }
              },
            ),
            _buildFormSectionHeader('Berechtigungen'),
            DropdownButtonFormField<Profile>(
              value: user != null
                  ? profiles.entries
                      .firstWhere(
                        (profile) => profile.value.accessControlList
                            .isEqual(user.profile.accessControlList),
                        orElse: () => null,
                      )
                      ?.value
                  : null,
              onChanged: (profile) =>
                  model.setAccessControlList(profile.accessControlList),
              decoration: const InputDecoration(labelText: 'Profil'),
              items: profiles.entries
                  .map<DropdownMenuItem<Profile>>(
                    (profile) => DropdownMenuItem<Profile>(
                      value: profile.value,
                      child: Text(profile.value.description),
                    ),
                  )
                  .toList(),
            ),
            _buildSwitchGroupLayout(model),
          ],
          primaryButton: ButtonSpecification(
            title: 'Speichern',
            onTap: () => model.submitForm(_selectedDepartments),
            isBusy: model.busy(UserEditViewModel.editActionKey),
          ),
          secondaryButton: user != null
              ? ButtonSpecification(
                  title: 'Löschen',
                  onTap: model.removeUser,
                  isBusy: model.busy(UserEditViewModel.removeActionKey),
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

  Widget _buildSwitchGroupLayout(UserEditViewModel model) => ExpansionTile(
        title: const Text('Berechtigungen bearbeiten'),
        children: [
          _buildLabeledSwitch(
            model,
            'Einsatzpläne ansehen',
            'canViewDeploymentPlans',
            model.accessControlList.canViewDeploymentPlans,
          ),
          _buildLabeledSwitch(
            model,
            'Einsatzpläne ansehen (Abteilung)',
            'canViewDepartmentDeploymentPlans',
            model.accessControlList.canViewDepartmentDeploymentPlans,
          ),
          _buildLabeledSwitch(
            model,
            'Einsatzpläne verwalten',
            'canEditDeploymentPlans',
            model.accessControlList.canEditDeploymentPlans,
          ),
          _buildLabeledSwitch(
            model,
            'Einsatzpläne verwalten (Abteilung)',
            'canEditDepartmentDeploymentPlans',
            model.accessControlList.canEditDepartmentDeploymentPlans,
          ),
          _buildLabeledSwitch(
            model,
            'Benutzer ansehen',
            'canViewUsers',
            model.accessControlList.canViewUsers,
          ),
          _buildLabeledSwitch(
            model,
            'Benutzer ansehen (Abteilung)',
            'canViewDepartmentUsers',
            model.accessControlList.canViewDepartmentUsers,
          ),
          _buildLabeledSwitch(
            model,
            'Benutzer verwalten',
            'canEditUsers',
            model.accessControlList.canEditUsers,
          ),
          _buildLabeledSwitch(
            model,
            'Benutzer verwalten (Abteilung)',
            'canEditDepartmentUsers',
            model.accessControlList.canEditDepartmentUsers,
          ),
          _buildLabeledSwitch(
            model,
            'Abteilungen ansehen',
            'canViewDepartments',
            model.accessControlList.canViewDepartments,
          ),
          _buildLabeledSwitch(
            model,
            'Abteilungen verwalten',
            'canEditDepartments',
            model.accessControlList.canEditDepartments,
          ),
          _buildLabeledSwitch(
            model,
            'Eigene Abteilung verwalten',
            'canEditOwnDepartment',
            model.accessControlList.canEditOwnDepartment,
          ),
          _buildLabeledSwitch(
            model,
            'Neuigkeiten verwalten',
            'canEditExternalNews',
            model.accessControlList.canEditExternalNews,
          ),
        ],
      );

  Widget _buildLabeledSwitch(
    UserEditViewModel model,
    String label,
    String key,
    bool value,
  ) =>
      Row(
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
