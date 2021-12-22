import 'package:flutter/material.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the deployment plan overview.
class DeploymentPlanOverviewView extends StatefulWidget {
  final bool adminModeEnabled;

  /// Initializes a new instance of [DeploymentPlanOverviewView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree and a
  /// [bool] wether to show admin level functionality as an input.
  const DeploymentPlanOverviewView({
    Key key,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  DeploymentPlanOverviewViewState createState() =>
      DeploymentPlanOverviewViewState();
}

class DeploymentPlanOverviewViewState
    extends State<DeploymentPlanOverviewView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<DeploymentPlan> selectedToDelete = [];
  List<DeploymentPlan> filteredDeploymentPlans = [];
  bool filtered = false;
  bool selectMultiple = false;
  bool selectAll = false;

  /// Binds [DeploymentPlanOverviewViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<DeploymentPlanOverviewViewModel>.reactive(
        viewModelBuilder: () => DeploymentPlanOverviewViewModel(
          adminModeEnabled: widget.adminModeEnabled,
        ),
        builder: (context, model, child) => NavigationLayout(
          title: widget.adminModeEnabled
              ? 'Einsatzplanverwaltung'
              : 'Einsatzpläne',
          body: _buildDataView(context, model),
          actions: [
            if (selectMultiple && widget.adminModeEnabled)
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
            if (!selectMultiple && widget.adminModeEnabled)
              ActionSpecification(
                tooltip: 'Einsatzplan erstellen',
                icon: const Icon(Icons.add),
                onPressed: () => model.editDeploymentPlan(
                  asDialog: getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                ),
              ),
          ],
          actionsAppBar: [
            if (selectMultiple && widget.adminModeEnabled)
              ActionSpecification(
                tooltip: 'Alle auswählen',
                icon: const Icon(Icons.crop_square),
                onPressed: () => {
                  setState(() {
                    selectedToDelete = [];
                    filtered
                        ? selectedToDelete.addAll(filteredDeploymentPlans)
                        : selectedToDelete.addAll(model.data);
                    selectAll = true;
                  })
                },
              ),
            if (!selectMultiple && widget.adminModeEnabled)
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
    DeploymentPlanOverviewViewModel model,
  ) =>
      DataViewLayout(
        isBusy: model.isBusy,
        errorMessage: model.errorMessage,
        noDataMessage: (model.data == null || model.data.isEmpty)
            ? 'Es sind keine Einsatzpläne verfügbar.'
            : null,
        childBuilder: () => _buildFilter(context, model),
      );

  Widget _buildFilter(
    BuildContext context,
    DeploymentPlanOverviewViewModel model,
  ) {
    if (widget.adminModeEnabled) {
      return Column(
        children: [
          TextField(
            controller: _searchController,
            onChanged: (filter) => _applyFilter(model, filter),
            decoration: InputDecoration(
              labelText: 'Einsatzplan suchen',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () => {
                  _searchController.clear(),
                  _applyFilter(model, ''),
                  filtered = false
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: filtered
                  ? _buildList(context, model, filteredDeploymentPlans)
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
    } else {
      return SingleChildScrollView(
        child: Column(
          children: [
            if (filtered)
              _buildList(context, model, filteredDeploymentPlans)
            else
              _buildList(context, model, model.data)
          ],
        ),
      );
    }
  }

  Widget _buildList(
    BuildContext context,
    DeploymentPlanOverviewViewModel model,
    List<DeploymentPlan> deploymentPlans,
  ) =>
      RefreshIndicator(
        onRefresh: model.initialise,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: deploymentPlans.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, model, deploymentPlans[index]),
        ),
      );

  Widget _buildListItem(
    BuildContext context,
    DeploymentPlanOverviewViewModel model,
    DeploymentPlan deploymentPlan,
  ) {
    if (widget.adminModeEnabled) {
      return Dismissible(
        key: Key(deploymentPlan.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          setState(() {
            model.data.remove(deploymentPlan);
          });
          model.removeDeploymentPlan(deploymentPlan);
        },
        confirmDismiss: (DismissDirection direction) async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Löschen bestätigen"),
                content: Text(
                  "Soll '${deploymentPlan.description}' " +
                      "wirklich gelöscht werden?",
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
        child: _buildCardListItem(context, model, deploymentPlan),
      );
    } else {
      return _buildCardListItem(context, model, deploymentPlan);
    }
  }

  Widget _buildCardListItem(
    BuildContext context,
    DeploymentPlanOverviewViewModel model,
    DeploymentPlan deploymentPlan,
  ) =>
      Card(
        color: selectedToDelete.map((e) => e.id).contains(deploymentPlan.id)
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
                          .contains(deploymentPlan.id),
                      onChanged: (value) {
                        _selectToDelete(deploymentPlan);
                        _buildDeleteFab(model);
                      },
                    ),
                  ),
                ],
              ),
            Expanded(
              child: ListTile(
                title: Text(model.getDeploymentPlanTitle(deploymentPlan)),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(deploymentPlan.department.name),
                    Text(model.getDeploymentPlanSubtitle(deploymentPlan)),
                  ],
                ),
                onTap: () {
                  if (widget.adminModeEnabled) {
                    if (selectMultiple) {
                      _selectToDelete(deploymentPlan);
                    } else {
                      model.editDeploymentPlan(
                        deploymentPlan: deploymentPlan,
                        asDialog: getValueForScreenType<bool>(
                          context: context,
                          mobile: false,
                          desktop: true,
                        ),
                      );
                    }
                  } else {
                    model.openPdf(deploymentPlan);
                  }
                },
                onLongPress: () {
                  if (!selectMultiple) {
                    selectMultiple = true;
                  }
                  _selectToDelete(deploymentPlan);
                  _buildDeleteFab(model);
                },
              ),
            ),
            if (widget.adminModeEnabled)
              _buildPublishToggle(context, model, deploymentPlan)
          ],
        ),
      );

  Widget _buildPublishToggle(
    BuildContext context,
    DeploymentPlanOverviewViewModel model,
    DeploymentPlan deploymentPlan,
  ) =>
      Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            const Text("Veröffentlicht?"),
            Switch(
              value: deploymentPlan.published,
              onChanged: (bool newValue) {
                if (newValue) {
                  model.publishDeploymentPlan(deploymentPlan);
                } else {
                  model.hideDeploymentPlan(deploymentPlan);
                }
              },
              activeColor: CustomColors.secondary,
            ),
          ],
        ),
      );

  Widget _buildDeleteFab(DeploymentPlanOverviewViewModel model) {
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
                "Sollen ${selectedToDelete.length} " +
                    "Einsatzpläne wirklich gelöscht werden?",
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
            ? Text('${selectedToDelete.length} Einatzpläne löschen')
            : const Text('Löschen'),
      ),
    );
  }

  void _selectToDelete(DeploymentPlan deploymentPlan) {
    setState(() {
      if (!selectedToDelete
          .map((news) => news.id)
          .contains(deploymentPlan.id)) {
        selectedToDelete.add(deploymentPlan);
      } else if (selectedToDelete
          .map((news) => news.id)
          .contains(deploymentPlan.id)) {
        selectedToDelete.removeWhere(
          (news) => news.id == deploymentPlan.id,
        );
      }
    });
  }

  void _applyFilter(DeploymentPlanOverviewViewModel model, String filter) {
    filtered = true;
    model.filterDeploymentPlans(filter).then(
      (value) {
        setState(() {
          filteredDeploymentPlans = [];
          filteredDeploymentPlans.addAll(value);
        });
      },
    );
  }
}
