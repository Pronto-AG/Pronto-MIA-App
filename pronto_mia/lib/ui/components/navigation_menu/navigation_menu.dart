import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:pronto_mia/ui/components/navigation_menu/navigation_menu_viewmodel.dart';
import 'package:pronto_mia/ui/views/contact/contact_view.dart';
import 'package:pronto_mia/ui/views/department/overview/department_overview_view.dart';
import 'package:pronto_mia/ui/views/deployment_plan/overview/deployment_plan_overview_view.dart';
import 'package:pronto_mia/ui/views/external_news/overview/external_news_overview_view.dart';
import 'package:pronto_mia/ui/views/login/login_view.dart';
import 'package:pronto_mia/ui/views/user/overview/user_overview_view.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing a menu containing the main navigation.
class NavigationMenu extends StatelessWidget {
  static const paddingSideBar = 30.0;

  /// Binds [NavigationMenuViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<NavigationMenuViewModel>.reactive(
        viewModelBuilder: () => NavigationMenuViewModel(),
        builder: (context, model, child) => Drawer(
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
              const DrawerHeader(
                margin: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.scaleDown,
                    image: AssetImage('assets/images/pronto_logo.png'),
                  ),
                ),
                child: null,
              ),
              _buildProfile(context, model),
              ..._buildOverview(model),
              ..._buildAdministration(model),
            ],
          ),
        ),
      );

  Widget _buildProfile(BuildContext context, NavigationMenuViewModel model) {
    final userName =
        model.data != null ? model.data.userName : 'Hans Mustermann';
    final userImage = Jdenticon.toSvg(userName);
    final userProfile =
        model.data != null ? model.data.profile.description : 'Benutzer';

    if (model.data != null) {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: 23.0, right: 25.0),
        leading: SvgPicture.string(
          userImage,
          height: 48,
          width: 48,
        ),
        title: Text(userName),
        subtitle: Text(userProfile),
        trailing: const Icon(Icons.settings),
        onTap: () => model.openSettings(
          asDialog: getValueForScreenType<bool>(
            context: context,
            mobile: false,
            desktop: true,
          ),
        ),
      );
    } else {
      return ListTile(
        contentPadding: const EdgeInsets.only(left: paddingSideBar),
        leading: const Icon(
          Icons.login,
        ),
        title: const Text("Anmelden"),
        onTap: () => model.navigateTo(
          LoginView(),
        ),
      );
    }
  }

  List<Widget> _buildOverview(NavigationMenuViewModel model) =>
      _buildNavigationCategory(
        'Übersicht',
        [
          ListTile(
            contentPadding: const EdgeInsets.only(left: paddingSideBar),
            leading: const Icon(Icons.description),
            title: const Text('News'),
            onTap: () => model.navigateTo(
              const ExternalNewsOverviewView(),
            ),
          ),
          if (model.data != null &&
              (model.data.profile.accessControlList.canViewDeploymentPlans ||
                  model.data.profile.accessControlList
                      .canViewDepartmentDeploymentPlans))
            ListTile(
              contentPadding: const EdgeInsets.only(left: paddingSideBar),
              leading: const Icon(Icons.today),
              title: const Text('Einsatzpläne'),
              onTap: () => model.navigateTo(
                const DeploymentPlanOverviewView(),
              ),
            ),
          if (model.data == null)
            ListTile(
              contentPadding: const EdgeInsets.only(left: paddingSideBar),
              leading: const Icon(Icons.contact_page),
              title: const Text('Kontakt'),
              onTap: () => model.navigateTo(
                const ContactView(),
              ),
            ),
          /*
          const ListTile(
            leading: Icon(Icons.beach_access),
            title: Text('Ferien'),
          ),
          const ListTile(
            leading: Icon(Icons.school),
            title: Text('Schulungsunterlagen'),
          ), */
        ],
      );

  List<Widget> _buildAdministration(NavigationMenuViewModel model) =>
      _buildNavigationCategory(
        model.data != null &&
                (model.data.profile.accessControlList.canViewUsers ||
                    model.data.profile.accessControlList.canViewDepartmentUsers)
            ? 'Administration'
            : '',
        [
          if (model.data != null &&
              model.data.profile.accessControlList.canEditExternalNews)
            ListTile(
              contentPadding: const EdgeInsets.only(left: paddingSideBar),
              leading: const Icon(Icons.description),
              title: const Text('Newsverwaltung'),
              onTap: () => model.navigateTo(
                const ExternalNewsOverviewView(adminModeEnabled: true),
              ),
            ),
          if (model.data != null &&
              (model.data.profile.accessControlList.canEditDeploymentPlans ||
                  model.data.profile.accessControlList
                      .canEditDepartmentDeploymentPlans))
            ListTile(
              contentPadding: const EdgeInsets.only(left: paddingSideBar),
              leading: const Icon(Icons.today),
              title: const Text('Einsatzplanverwaltung'),
              onTap: () => model.navigateTo(
                const DeploymentPlanOverviewView(adminModeEnabled: true),
              ),
            ),
          /*
          const ListTile(
            leading: Icon(Icons.beach_access),
            title: Text('Ferienverwaltung'),
          ),
          const ListTile(
            leading: Icon(Icons.school),
            title: Text('Schulungsverwaltung'),
          ), */

          if (model.data != null &&
              (model.data.profile.accessControlList.canViewUsers ||
                  model.data.profile.accessControlList.canViewDepartmentUsers))
            ListTile(
              contentPadding: const EdgeInsets.only(left: paddingSideBar),
              leading: const Icon(Icons.person),
              title: const Text('Benutzerverwaltung'),
              onTap: () => model.navigateTo(const UserOverviewView()),
            ),
          if (model.data != null &&
              (model.data.profile.accessControlList.canViewDepartments ||
                  model.data.profile.accessControlList.canEditOwnDepartment))
            ListTile(
              contentPadding: const EdgeInsets.only(left: paddingSideBar),
              leading: const Icon(Icons.people),
              title: const Text('Abteilungsverwaltung'),
              onTap: () => model.navigateTo(const DepartmentOverviewView()),
            ),
        ],
      );

  List<Widget> _buildNavigationCategory(String title, List<Widget> tiles) => [
        if (title.isNotEmpty) const Divider(indent: 10.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        ...tiles,
      ];
}
