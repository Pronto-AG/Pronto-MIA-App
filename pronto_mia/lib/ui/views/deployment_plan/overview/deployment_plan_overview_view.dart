import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_viewmodel.dart';

class DeploymentPlanOverviewView extends StatelessWidget {
  final bool adminModeEnabled;

  const DeploymentPlanOverviewView({
    Key key,
    this.adminModeEnabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DeploymentPlanOverviewViewModel>.reactive(
      viewModelBuilder: () => DeploymentPlanOverviewViewModel(
        adminModeEnabled: adminModeEnabled,
      ),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Einsatzpläne',
            style: TextStyle(color: Colors.black),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
        ),
        body: (() {
          if (model.isBusy) {
            return const Center(child: CircularProgressIndicator());
          }

          if (model.hasError) {
            return Center(
              child: Text(model.errorMessage),
            );
          }

          if (model.data == null || model.data.isEmpty) {
            return const Center(
              child: Text('Es sind keine Einsatzpläne verfügbar.'),
            );
          }

          return ListView.builder(
            itemCount: model.data.length,
            itemBuilder: (context, index) {
              final dateFormat = DateFormat('dd.MM.yyyy');
              final dateTimeFormat = DateFormat('dd.MM.yyyy hh:mm');
              final availableFromDateFormatted =
                  dateFormat.format(model.data[index].availableFrom);
              final availableFromFormatted =
                  dateTimeFormat.format(model.data[index].availableFrom);
              final availableUntilFormatted =
                  dateTimeFormat.format(model.data[index].availableUntil);

              return Card(
                child: ListTile(
                  title: Text(
                    model.data[index].description
                    ?? 'Einsatzplan $availableFromDateFormatted'
                  ),
                  subtitle: Text(
                    //'$availableFromFormatted - $availableUntilFormatted',
                    'Id ${model.data[index].id}'
                  ),
                  onTap: () {
                    if (adminModeEnabled) {
                      model.editDeploymentPlan(model.data[index]);
                    } else {
                      model.openPdf(model.data[index]);
                    }
                  },
                ),
              );
            },
          );
        })(),
        floatingActionButton: adminModeEnabled
          ? FloatingActionButton(
              tooltip: 'Einsatzplan erstellen',
              backgroundColor: Colors.green,
              onPressed: model.createDeploymentPlan,
              heroTag: null,
              child: const Icon(Icons.post_add),
            )
          : null,
        floatingActionButtonLocation: (() {
          if (kIsWeb) {
            return FloatingActionButtonLocation.endFloat;
          } else {
            return FloatingActionButtonLocation.centerDocked;
          }
        })(),
        bottomNavigationBar: BottomAppBar(
          shape: (() {
            if (!kIsWeb) {
              return const CircularNotchedRectangle();
            }
          })(),
          color: Colors.blue,
          child: IconTheme(
            data: const IconThemeData(color: Colors.white),
            child: Row(
              children: [
                IconButton(
                  tooltip: 'Navigation öffnen',
                  icon: const Icon(Icons.menu),
                  onPressed: () async => showMenu(context, model),
                ),
                const Spacer(),
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
          ),
        ),
      ),
    );
  }

  void showMenu(BuildContext context, DeploymentPlanOverviewViewModel model) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              const ListTile(
                leading: Icon(Icons.person),
                title: Text('Benutzerprofil'),
              ),
              const Divider(),
              const Text(
                'Übersicht',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ListTile(
                leading: const Icon(Icons.today),
                title: const Text('Einsatzpläne'),
                onTap: () =>
                    model.navigateFromMenu(Routes.deploymentPlanOverviewView),
              ),
              const ListTile(
                leading: Icon(Icons.beach_access),
                title: Text('Ferien'),
              ),
              const ListTile(
                leading: Icon(Icons.school),
                title: Text('Schulungsunterlagen'),
              ),
              const ListTile(
                leading: Icon(Icons.description),
                title: Text('News'),
              ),
              const Divider(),
              const Text(
                'Administration',
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              ListTile(
                leading: const Icon(Icons.today),
                title: const Text('Einsatzplanverwaltung'),
                onTap: () => model.navigateFromMenu(
                  Routes.deploymentPlanOverviewView,
                  arguments: DeploymentPlanOverviewViewArguments(
                    adminModeEnabled: true,
                  ),
                ),
              ),
              const ListTile(
                leading: Icon(Icons.beach_access),
                title: Text('Ferienverwaltung'),
              ),
              const ListTile(
                leading: Icon(Icons.school),
                title: Text('Schulungsverwaltung'),
              ),
              const ListTile(
                leading: Icon(Icons.description),
                title: Text('Newsverwaltung'),
              ),
              const ListTile(
                leading: Icon(Icons.people),
                title: Text('Benutzerverwaltung'),
              ),
            ],
          ),
        );
      },
    );
  }
}
