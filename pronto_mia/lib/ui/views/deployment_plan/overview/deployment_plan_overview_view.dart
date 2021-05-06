import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_viewmodel.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/components/custom_app_bar.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/side_menu/side_menu.dart';

class DeploymentPlanOverviewView extends StatelessWidget {
  final bool adminModeEnabled;

  const DeploymentPlanOverviewView({
    Key key,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<DeploymentPlanOverviewViewModel>.reactive(
          viewModelBuilder: () =>
              DeploymentPlanOverviewViewModel(
                adminModeEnabled: adminModeEnabled,
              ),
          builder: (context, model, child) =>
              ScreenTypeLayout(
                mobile: _buildMobileLayout(context, model),
                tablet: _buildTabletLayout(context, model),
                desktop: _buildDesktopLayout(context, model),
              )
      );

  Widget _buildMobileLayout(BuildContext context, DeploymentPlanOverviewViewModel model) => Scaffold(
    appBar: _buildAppBar(),
    body: _buildBaseLayout(context, model),
    floatingActionButton: adminModeEnabled
        ? _buildFloatingActionButton(model)
        : null,
    floatingActionButtonLocation: kIsWeb
        ? FloatingActionButtonLocation.endFloat
        : FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: _buildBottomAppBar(),
  );

  Widget _buildTabletLayout(BuildContext context, DeploymentPlanOverviewViewModel model) => Scaffold(
    appBar: _buildAppBar(),
    body: Align(
      alignment: Alignment.topCenter,
      // ignore: sized_box_for_whitespace
      child: Container(
        width: 584.0,
        child: _buildBaseLayout(context, model),
      ),
    ),
    floatingActionButton: adminModeEnabled
        ? _buildFloatingActionButton(model)
        : null,
    floatingActionButtonLocation: kIsWeb
        ? FloatingActionButtonLocation.endFloat
        : FloatingActionButtonLocation.centerDocked,
    bottomNavigationBar: _buildBottomAppBar(),
  );

  Widget _buildDesktopLayout(BuildContext context, DeploymentPlanOverviewViewModel model) => Scaffold(
    body: Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          width: 300.0,
          decoration: const BoxDecoration(
            color: CustomColors.background,
            boxShadow: [
              BoxShadow(
                color: CustomColors.shadow,
                spreadRadius: 1,
                blurRadius: 1,
              )
            ],
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                width: 240.0,
                child: Image.asset('assets/images/pronto_logo.png'),
              ),
              const Divider(),
              SideMenu(),
            ],
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            // ignore: sized_box_for_whitespace
            child: Container(
              width: 600.0,
              child: Column(
                children: [
                  _buildAppBar(
                    actions: [
                      if (adminModeEnabled)
                        IconButton(
                          tooltip: 'Einsatzplan erstellen',
                          icon: const Icon(Icons.post_add),
                          onPressed: () =>
                              model.editDeploymentPlan(asDialog: true),
                        ),
                      IconButton(
                        tooltip: 'Suche öffnen',
                        icon: const Icon(Icons.search),
                        onPressed: () {},
                      ),
                      IconButton(
                        tooltip: 'Filteroptionen anzeigen',
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  _buildBaseLayout(context, model),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );

  PreferredSizeWidget _buildAppBar({List<Widget> actions}) =>
      AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          adminModeEnabled ? 'Einsatzplanverwaltung' : 'Einsatzpläne',
          style: const TextStyle(color: CustomColors.primary),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: actions,
        actionsIconTheme: const IconThemeData(color: CustomColors.text),
      );

  Widget _buildBaseLayout(BuildContext context, DeploymentPlanOverviewViewModel model) =>
      DataViewLayout(
        isBusy: model.isBusy,
        errorMessage: model.errorMessage,
        emptyMessage: (model.data == null || model.data.isEmpty)
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

  Widget _buildFloatingActionButton(DeploymentPlanOverviewViewModel model) =>
      FloatingActionButton(
        tooltip: 'Einsatzplan erstellen',
        backgroundColor: CustomColors.secondary,
        onPressed: model.editDeploymentPlan,
        child: const Icon(Icons.post_add),
      );

  Widget _buildBottomAppBar() =>
      CustomAppBar(
        actions: [
          IconButton(
            tooltip: 'Suche öffnen',
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            tooltip: 'Filteroptionen anzeigen',
            icon: const Icon(Icons.filter_list),
            onPressed: () {},
          ),
        ],
      );
}
