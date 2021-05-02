import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:pronto_mia/core/services/user_service.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/app/app.router.dart';
import 'package:pronto_mia/app/service_locator.dart';

class CustomAppBar extends StatelessWidget {
  NavigationService get _navigationService => locator.get<NavigationService>();
  UserService get _userService => locator.get<UserService>();

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
    final user = await _userService.getCurrentUser();
    final String userImage = (user != null)
        ? Jdenticon.toSvg(user.username)
        : Jdenticon.toSvg("Hans Mustermann");
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.fromLTRB(
              16.0, 0, 16.0, 16.0), //EdgeInsets.all(16.0),
          child: ListView(
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: SvgPicture.string(
                  userImage,
                  fit: BoxFit.contain,
                  height: 48,
                  width: 48,
                ), //Icon(Icons.person),
                title: const Text("Benutzerprofil"),
                subtitle: () {
                  if (user != null) {
                    return Text(user.username);
                  } else {
                    return const Text("Hans Mustermann");
                  }
                }(),
                onTap: () => {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const SimpleDialog(
                          titlePadding: EdgeInsets.all(16.0),
                          title: Text("Profil"),
                        );
                      })
                },
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
