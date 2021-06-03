import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/views/department/edit/department_edit_viewmodel.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/views/department/edit/department_edit_view.form.dart';

class DepartmentEditView extends StatelessWidget with $DepartmentEditView {
  final _formKey = GlobalKey<FormState>();
  final Department department;
  final bool isDialog;

  DepartmentEditView({
    Key key,
    this.department,
    this.isDialog = false,
  }) : super(key: key) {
    if (department != null) {
      nameController.text = department.name;
    }
  }

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<DepartmentEditViewModel>.reactive(
        viewModelBuilder: () => DepartmentEditViewModel(
          department: department,
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

  Widget _buildStandaloneLayout(DepartmentEditViewModel model) => Scaffold(
    appBar: AppBar(title: _buildTitle()),
    body: _buildForm(model),
  );

  Widget _buildDialogLayout(DepartmentEditViewModel model) => Container(
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
    final title = department == null ? 'Abteilung erstellen' : 'Abteilung bearbeiten';

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

  Widget _buildForm(DepartmentEditViewModel model) => Form(
    key: _formKey,
    child: FormLayout(
      textFields: [
        TextFormField(
          controller: nameController,
          onEditingComplete: model.submitForm,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
      ],
      primaryButton: ButtonSpecification(
        title: 'Speichern',
        onTap: model.submitForm,
        isBusy: model.busy(DepartmentEditViewModel.editBusyKey),
      ),
      secondaryButton: department != null
        ? ButtonSpecification(
          title: 'Löschen',
          onTap: model.removeDepartment,
          isBusy: model.busy(DepartmentEditViewModel.removeBusyKey),
          isDestructive: true,
        )
        : null,
      validationMessage: model.validationMessage,
    ),
  );


}