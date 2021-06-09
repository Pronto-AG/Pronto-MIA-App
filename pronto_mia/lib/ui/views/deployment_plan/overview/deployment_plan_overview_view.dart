import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_viewmodel.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';

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
          title: adminModeEnabled ? 'Einsatzplanverwaltung' : 'Einsatzpläne',
          body: _buildDataView(context, model),
          actions: [
            if (adminModeEnabled)
              ActionSpecification(
                tooltip: 'Einsatzplan erstellen',
                icon: const Icon(Icons.post_add),
                onPressed: () => model.editDeploymentPlan(
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
  ) =>
      Card(
        child: Row(
          children: [
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
            ),
            if (adminModeEnabled)
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
}
