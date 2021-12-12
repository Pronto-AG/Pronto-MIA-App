import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/department/overview/department_overview_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

class DepartmentOverviewView extends StatefulWidget {
  /// Initializes a new instance of [DepartmentOverviewView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree as an
  /// input.
  const DepartmentOverviewView({Key key}) : super(key: key);

  @override
  DepartmentOverviewViewState createState() => DepartmentOverviewViewState();
}

class DepartmentOverviewViewState extends State<DepartmentOverviewView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<Department> selectedToDelete = [];
  List<Department> filteredDepartments = [];
  bool filtered = false;
  bool selectMultiple = false;
  bool selectAll = false;

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
            if (selectMultiple &&
                model.currentUser != null &&
                model.currentUser.profile.accessControlList.canEditDepartments)
              ActionSpecification(
                tooltip: 'Abbrechen',
                icon: const Icon(Icons.cancel),
                onPressed: () => {
                  setState(() {
                    selectMultiple = false;
                    selectedToDelete = [];
                  })
                },
              ),
            if (!selectMultiple &&
                model.currentUser != null &&
                model.currentUser.profile.accessControlList.canEditDepartments)
              ActionSpecification(
                tooltip: 'Neuigkeit erstellen',
                icon: const Icon(Icons.add),
                onPressed: () => model.editDepartment(
                  asDialog: getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                ),
              ),
          ],
          actionsAppBar: [
            if (selectMultiple &&
                model.currentUser != null &&
                model.currentUser.profile.accessControlList.canEditDepartments)
              ActionSpecification(
                tooltip: 'Alle auswählen',
                icon: const Icon(Icons.crop_square),
                onPressed: () => {
                  setState(() {
                    selectedToDelete = [];
                    filtered
                        ? selectedToDelete.addAll(filteredDepartments)
                        : selectedToDelete.addAll(model.data);
                    selectAll = true;
                  })
                },
              ),
            if (!selectMultiple &&
                model.currentUser != null &&
                model.currentUser.profile.accessControlList.canEditDepartments)
              ActionSpecification(
                tooltip: 'Auswählen',
                icon: const Icon(Icons.select_all),
                onPressed: () => {
                  setState(() {
                    selectMultiple = !selectMultiple;
                  })
                },
              ),
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
        childBuilder: () => _buildFilter(context, model),
      );

  Widget _buildFilter(BuildContext context, DepartmentOverviewViewModel model) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (filter) => _applyFilter(model, filter),
          decoration: InputDecoration(
            labelText: 'Abteilung suchen',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => {
                _searchController.clear(),
                _applyFilter(model, ''),
                filtered = false,
              },
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: filtered
                ? _buildList(context, model, filteredDepartments)
                : _buildList(context, model, model.data),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: _buildDeleteFab(model),
          ),
        ),
      ],
    );
  }

  Widget _buildList(
    BuildContext context,
    DepartmentOverviewViewModel model,
    List<Department> departments,
  ) =>
      RefreshIndicator(
        onRefresh: model.initialise,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: departments.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, model, departments[index]),
        ),
      );

  Widget _buildListItem(
    BuildContext context,
    DepartmentOverviewViewModel model,
    Department department,
  ) =>
      Dismissible(
        key: Key(department.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          setState(() {
            model.data.remove(department);
          });
          model.removeDepartment(department);
        },
        confirmDismiss: (DismissDirection direction) async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Löschen bestätigen"),
                content: Text(
                  "Soll '${department.name}' wirklich gelöscht werden?",
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text(
                      "Löschen",
                      style: TextStyle(color: CustomColors.secondary),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("Abbrechen"),
                  ),
                ],
              );
            },
          );
        },
        background: Container(
          color: Colors.red,
          margin: const EdgeInsets.symmetric(horizontal: 15),
          alignment: Alignment.centerRight,
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        child: _buildCardListItem(context, model, department),
      );

  Widget _buildCardListItem(
    BuildContext context,
    DepartmentOverviewViewModel model,
    Department department,
  ) =>
      Card(
        color: selectedToDelete.map((e) => e.id).contains(department.id)
            ? Colors.grey[200]
            : null,
        child: Row(
          children: [
            if (selectMultiple)
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Checkbox(
                      activeColor: Colors.blue,
                      value: selectedToDelete
                          .map((e) => e.id)
                          .contains(department.id),
                      onChanged: (value) {
                        _selectToDelete(department);
                        _buildDeleteFab(model);
                      },
                    ),
                  ),
                ],
              ),
            Expanded(
              child: ListTile(
                title: Text(department.name),
                onTap: () {
                  if (model.currentUser != null &&
                      (model.currentUser.profile.accessControlList
                              .canEditDepartments ||
                          model.currentUser.profile.accessControlList
                              .canEditOwnDepartment) &&
                      selectMultiple) {
                    _selectToDelete(department);
                  } else if (model.currentUser != null &&
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
                onLongPress: () {
                  if (!selectMultiple) {
                    selectMultiple = true;
                  }
                  _selectToDelete(department);
                  _buildDeleteFab(model);
                },
              ),
            ),
          ],
        ),
      );

  Widget _buildDeleteFab(DepartmentOverviewViewModel model) {
    return Visibility(
      visible: selectedToDelete.isNotEmpty,
      child: FloatingActionButton.extended(
        heroTag: "removeFab",
        elevation: 4.0,
        onPressed: () => showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Löschen bestätigen"),
              content: Text(
                "Soll(en) ${selectedToDelete.length} " +
                    "Abteilungen wirklich gelöscht werden?",
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop(true);
                    await model.removeItems(selectedToDelete);
                    selectedToDelete = [];
                  },
                  child: const Text(
                    "Löschen",
                    style: TextStyle(color: CustomColors.secondary),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("Abbrechen"),
                ),
              ],
            );
          },
        ),
        icon: const Icon(Icons.delete),
        label: selectedToDelete.isNotEmpty
            ? Text('${selectedToDelete.length} Abteilungen löschen')
            : const Text('Löschen'),
      ),
    );
  }

  void _selectToDelete(Department department) {
    setState(() {
      if (!selectedToDelete
          .map((department) => department.id)
          .contains(department.id)) {
        selectedToDelete.add(department);
      } else if (selectedToDelete
          .map((department) => department.id)
          .contains(department.id)) {
        selectedToDelete.removeWhere(
          (dep) => dep.id == department.id,
        );
      }
    });
  }

  void _applyFilter(DepartmentOverviewViewModel model, String filter) {
    filtered = true;
    model.filterDepartments(filter).then(
      (value) {
        setState(() {
          filteredDepartments = [];
          filteredDepartments.addAll(value);
        });
      },
    );
  }
}
