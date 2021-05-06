import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/components/side_menu/side_menu_viewmodel.dart';
import 'package:pronto_mia/app/app.router.dart';

class SideMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<SideMenuViewModel>.reactive(
        viewModelBuilder: () => SideMenuViewModel(),
        builder: (context, model, child) => Container(
          padding: const EdgeInsets.fromLTRB(16.0, 0, 16.0, 16.0),
          child: ListView(
            shrinkWrap: true,
            children: [
              _buildProfile(model),
              ..._buildOverview(model),
              ..._buildAdministration(model),
            ],
          ),
        ),
      );

  Widget _buildProfile(SideMenuViewModel model) {
    final username = model.data != null
      ? model.data.username
      : 'Hans Mustermann';
    final userImage = Jdenticon.toSvg(username);

    return ListTile(
      contentPadding: const EdgeInsets.only(left: 8.0),
      leading: SvgPicture.string(
        userImage,
        height: 48,
        width: 48,
      ),
      title: const Text("Benutzerprofil"),
      subtitle: Text(username),
    );
  }

  List<Widget> _buildOverview(SideMenuViewModel model) =>
      _buildNavigationCategory(
        'Übersicht',
        [
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Einsatzpläne'),
            onTap: () => model.navigateTo(
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
        ],
      );

  List<Widget> _buildAdministration(SideMenuViewModel model) =>
      _buildNavigationCategory(
        'Administration',
        [
          ListTile(
            leading: const Icon(Icons.today),
            title: const Text('Einsatzplanverwaltung'),
            onTap: () => model.navigateTo(
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
      );

  List<Widget> _buildNavigationCategory(String title, List<Widget> tiles) => [
    const Divider(),
    Text(
      title,
      textAlign: TextAlign.left,
      style: const TextStyle(fontWeight: FontWeight.w600),
    ),
    ...tiles,
  ];
}