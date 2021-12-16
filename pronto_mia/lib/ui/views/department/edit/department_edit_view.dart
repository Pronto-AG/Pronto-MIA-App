import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/components/form_layout.dart';
import 'package:pronto_mia/ui/views/department/edit/department_edit_view.form.dart';
import 'package:pronto_mia/ui/views/department/edit/department_edit_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the form to create and update departments.
class DepartmentEditView extends StatelessWidget with $DepartmentEditView {
  final _formKey = GlobalKey<FormState>();
  final Department department;
  final bool isDialog;

  /// Initializes a new instance of [DepartmentEditView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree, a
  /// [Department] to edit and a [bool] wether to open it as a dialog or
  /// standalone as an input.
  DepartmentEditView({
    Key key,
    this.department,
    this.isDialog = false,
  }) : super(key: key) {
    if (department != null) {
      nameController.text = department.name;
    }
  }

  /// Binds [DepartmentEditViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
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

  // ignore: sized_box_for_whitespace
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
    final title =
        department == null ? 'Abteilung erstellen' : 'Abteilung bearbeiten';

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
            isBusy: model.busy(DepartmentEditViewModel.removeActionKey),
          ),
          secondaryButton: department != null
              ? ButtonSpecification(
                  title: 'Löschen',
                  onTap: model.removeDepartment,
                  isBusy: model.busy(DepartmentEditViewModel.removeActionKey),
                  isDestructive: true,
                )
              : null,
          cancelButton: (() {
            if (department == null) {
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
