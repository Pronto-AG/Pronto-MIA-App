import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/views/department/overview/department_overview_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the department overview.
class DepartmentOverviewView extends StatelessWidget {
  const DepartmentOverviewView({Key key}) : super(key: key);

  /// Binds [DepartmentOverviewViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<DepartmentOverviewViewModel>.reactive(
        viewModelBuilder: () => DepartmentOverviewViewModel(),
        onModelReady: (model) => model.fetchCurrentUser(),
        builder: (context, model, child) => NavigationLayout(
          title: 'Abteilungsverwaltung',
          body: _buildDataView(context, model),
          actions: [
            if (model.currentUser != null &&
                model.currentUser.profile.accessControlList.canEditDepartments)
              ActionSpecification(
                tooltip: 'Abteilung erstellen',
                icon: const Icon(Icons.post_add),
                onPressed: () => model.editDepartment(
                  asDialog: getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                ),
              ),
            /*
            ActionSpecification(
              tooltip: 'Suche öffnen',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
             */
          ],
        ),
      );

  Widget _buildDataView(
    BuildContext context,
    DepartmentOverviewViewModel model,
  ) =>
      DataViewLayout(
        isBusy: model.isBusy,
        errorMessage: model.errorMessage,
        noDataMessage: (model.data == null || model.data.isEmpty)
            ? 'Es sind keine Abteilungen verfügbar.'
            : null,
        childBuilder: () => _buildList(context, model),
      );

  Widget _buildList(BuildContext context, DepartmentOverviewViewModel model) =>
      RefreshIndicator(
        onRefresh: model.initialise,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: model.data.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, model, model.data[index]),
        ),
      );

  Widget _buildListItem(
    BuildContext context,
    DepartmentOverviewViewModel model,
    Department department,
  ) =>
      Card(
        child: ListTile(
          title: Text(department.name),
          onTap: () {
            if (model.currentUser != null &&
                (model.currentUser.profile.accessControlList
                        .canEditDepartments ||
                    model.currentUser.profile.accessControlList
                        .canEditOwnDepartment)) {
              model.editDepartment(
                department: department,
                asDialog: getValueForScreenType<bool>(
                  context: context,
                  mobile: false,
                  desktop: true,
                ),
              );
            }
          },
        ),
      );
}
