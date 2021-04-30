import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/service_locator.dart';

class CustomAppBar extends StatelessWidget {
  NavigationService get _navigationService => locator.get<NavigationService>();

  final List<Widget> actions;

  const CustomAppBar({
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
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
              onPressed: () async => _showMenu(context),
            ),
            const Spacer(),
            ...actions,
          ],
        ),
      ),
    );
  }

  Future<void> _showMenu(BuildContext context) async {
    final String rawSvg = Jdenticon.toSvg('Your input string');
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                leading: SvgPicture.string(rawSvg, fit: BoxFit.contain, height: 24, width: 24,),//Icon(Icons.person),
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
                onTap: () => _navigationService.navigateTo(
                  Routes.deploymentPlanOverviewView,
                ),
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
                onTap: () => _navigationService.navigateTo(
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
