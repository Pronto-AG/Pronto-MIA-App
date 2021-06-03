import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:stacked/stacked.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:pronto_mia/ui/views/user/overview/user_overview_viewmodel.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/core/models/user.dart';

class UserOverviewView extends StatelessWidget {
  const UserOverviewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<UserOverviewViewModel>.reactive(
        viewModelBuilder: () => UserOverviewViewModel(),
        onModelReady: (model) => model.fetchCurrentUser(),
        builder: (context, model, child) => NavigationLayout(
          title: 'Benutzerverwaltung',
          body: _buildDataView(context, model),
          actions: [
            if (model.currentUser == null ||
                model.currentUser.profile.accessControlList.canEditUsers ||
                model.currentUser.profile.accessControlList
                    .canEditDepartmentUsers)
              ActionSpecification(
                tooltip: 'Benutzer erstellen',
                icon: const Icon(Icons.person_add),
                onPressed: () => model.editUser(
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

  Widget _buildDataView(BuildContext context, UserOverviewViewModel model) =>
      DataViewLayout(
        isBusy: model.isBusy,
        errorMessage: model.errorMessage,
        noDataMessage: (model.data == null || model.data.isEmpty)
            ? 'Es sind keine Benutzer verfügbar.'
            : null,
        childBuilder: () => _buildList(context, model),
      );

  Widget _buildList(BuildContext context, UserOverviewViewModel model) =>
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
    UserOverviewViewModel model,
    User user,
  ) =>
      Card(
        child: ListTile(
            leading: SvgPicture.string(
              Jdenticon.toSvg(user.userName),
              height: 48,
              width: 48,
            ),
            title: Text(user.userName),
            subtitle: Text(user.department != null
                ? '${user.department.name} - '
                    '${user.profile.description}'
                : user.profile.description),
            onTap: () {
              if (model.currentUser == null ||
                  model.currentUser.profile.accessControlList.canEditUsers ||
                  model.currentUser.profile.accessControlList
                      .canEditDepartmentUsers) {
                model.editUser(
                  user: user,
                  asDialog: getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                );
              }
            }),
      );
}
