import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_viewmodel.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';

class DeploymentPlanOverviewView extends StatelessWidget {
  final bool adminModeEnabled;

  const DeploymentPlanOverviewView({
    Key key,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<DeploymentPlanOverviewViewModel>.reactive(
        viewModelBuilder: () => DeploymentPlanOverviewViewModel(
          adminModeEnabled: adminModeEnabled,
        ),
        builder: (context, model, child) => NavigationLayout(
          title: adminModeEnabled ? 'Einsatplanverwaltung' : 'Einsatzpläne',
          body: _buildDataView(context, model),
          actions: [
            if (adminModeEnabled)
              ActionSpecification(
                tooltip: 'Einsatzplan erstellen',
                icon: const Icon(Icons.post_add),
                onPressed: () => model.editDeploymentPlan(asDialog: true),
              ),
            ActionSpecification(
              tooltip: 'Suche öffnen',
              icon: const Icon(Icons.search),
              onPressed: () {},
            ),
            ActionSpecification(
              tooltip: 'Filteroptionen anzeigen',
              icon: const Icon(Icons.filter_list),
              onPressed: () {},
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
        childBuilder: () => _buildList(context, model),
      );

  Widget _buildList(
    BuildContext context,
    DeploymentPlanOverviewViewModel model,
  ) =>
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
    DeploymentPlanOverviewViewModel model,
    DeploymentPlan deploymentPlan,
  ) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final dateTimeFormat = DateFormat('dd.MM.yyyy hh:mm');
    final availableFromDateFormatted =
        dateFormat.format(deploymentPlan.availableFrom);
    final availableFromFormatted =
        dateTimeFormat.format(deploymentPlan.availableFrom);
    final availableUntilFormatted =
        dateTimeFormat.format(deploymentPlan.availableUntil);

    return Card(
      child: ListTile(
        title: Text(deploymentPlan.description ??
            'Einsatzplan $availableFromDateFormatted'),
        subtitle: Text(
          '$availableFromFormatted - $availableUntilFormatted',
        ),
        onTap: () {
          if (adminModeEnabled) {
            model.editDeploymentPlan(
              deploymentPlan: deploymentPlan,
              asDialog: getValueForScreenType<bool>(
                context: context,
                mobile: false,
                desktop: true,
              ),
            );
          } else {
            model.openPdf(deploymentPlan);
          }
        },
      ),
    );
  }
}
