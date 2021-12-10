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

/// A widget, representing the form to create and update users.
// ignore: must_be_immutable
class UserEditView extends StatefulWidget with $UserEditView {
  final _formKey = GlobalKey<FormState>();
  final User user;
  final bool isDialog;
  List<Department> selectedDepartments;

  /// Initializes a new instance of [UserEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [User] to edit and a [bool] wether to open it as a dialog or
  /// standalone as an input.
  UserEditView({
    Key key,
    this.user,
    this.isDialog = false,
    this.selectedDepartments = const <Department>[],
  }) : super(key: key) {
    if (user != null) {
      userNameController.text = user.userName;
      passwordController.text = 'XXXXXX';
      passwordConfirmController.text = 'XXXXXX';
    }
  }

  @override
  State<StatefulWidget> createState() {
    return UserEditState();
  }
}

class UserEditState extends State<UserEditView> {
  /// Binds [UserEditViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<UserEditViewModel>.reactive(
        viewModelBuilder: () => UserEditViewModel(
          user: widget.user,
          isDialog: widget.isDialog,
        ),
        onModelReady: (model) {
          widget.listenToFormUpdated(model);
          model.fetchDepartments();

          if (widget.user != null) {
            model.setDepartments(widget.user.departments);
          }
        },
        builder: (context, model, child) {
          if (widget.isDialog) {
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
    final title =
        widget.user == null ? 'Benutzer erstellen' : 'Benutzer bearbeiten';

    if (widget.isDialog) {
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
        key: widget._formKey,
        child: FormLayout(
          textFields: [
            _buildFormSectionHeader('Benutzerinformationen'),
            TextFormField(
              controller: widget.userNameController,
              onEditingComplete: () =>
                  model.submitForm(widget.selectedDepartments),
              decoration: const InputDecoration(labelText: 'Benutzername'),
            ),
            TextFormField(
              controller: widget.passwordController,
              onEditingComplete: () =>
                  model.submitForm(widget.selectedDepartments),
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Passwort'),
            ),
            TextFormField(
              controller: widget.passwordConfirmController,
              onEditingComplete: () =>
                  model.submitForm(widget.selectedDepartments),
              obscureText: true,
              decoration:
                  const InputDecoration(labelText: 'Passwort bestätigen'),
            ),
            _buildFormSectionHeader('Abteilung'),
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
                    title: const Text("Abteilungen"),
                    initialValue: widget.selectedDepartments,
                    listType: MultiSelectListType.LIST,
                    onConfirm: (values) {
                      widget.selectedDepartments = values as List<Department>;
                    },
                    buttonText: const Text("Abteilung auswählen"),
                    searchable: true,
                    buttonIcon: const Icon(Icons.add_box_outlined),
                    height: 300.0,
                    chipDisplay: MultiSelectChipDisplay(
                      chipColor: Colors.grey.withOpacity(0.2),
                      textStyle: const TextStyle(color: Colors.black),
                      onTap: (Department item) {
                        widget.selectedDepartments.remove(item);
                        return widget.selectedDepartments;
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
              value: widget.user != null
                  ? profiles.entries
                      .firstWhere(
                        (profile) => profile.value.accessControlList
                            .isEqual(widget.user.profile.accessControlList),
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
            onTap: () => model.submitForm(widget.selectedDepartments),
            isBusy: model.busy(UserEditViewModel.editActionKey),
          ),
          secondaryButton: widget.user != null
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
