import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:jdenticon_dart/jdenticon_dart.dart';
import 'package:pronto_mia/core/models/user.dart';
import 'package:pronto_mia/ui/components/data_view_layout.dart';
import 'package:pronto_mia/ui/components/navigation_layout.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/views/user/overview/user_overview_viewmodel.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:stacked/stacked.dart';

/// A widget, representing the deployment plan overview.
class UserOverviewView extends StatefulWidget {
  /// Initializes a new instance of [UserOverviewView].
  ///
  /// Takes a [Key] to uniquely identify the widget in the widget tree as an
  /// input.
  const UserOverviewView({Key key}) : super(key: key);

  @override
  UserOverviewViewState createState() => UserOverviewViewState();
}

class UserOverviewViewState extends State<UserOverviewView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  List<User> selectedToDelete = [];
  List<User> filteredUsers = [];
  bool filtered = false;
  bool selectMultiple = false;
  bool selectAll = false;

  /// Binds [UserOverviewViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<UserOverviewViewModel>.reactive(
        viewModelBuilder: () => UserOverviewViewModel(),
        onModelReady: (model) => model.fetchCurrentUser(),
        builder: (context, model, child) => NavigationLayout(
          title: 'Benutzerverwaltung',
          body: _buildDataView(context, model),
          actions: [
            if (selectMultiple &&
                model.currentUser != null &&
                (model.currentUser.profile.accessControlList.canEditUsers ||
                    model.currentUser.profile.accessControlList
                        .canEditDepartmentUsers))
              ActionSpecification(
                tooltip: 'Abbrechen',
                icon: const Icon(Icons.cancel),
                onPressed: () => {
                  setState(() {
                    selectMultiple = false;
                    selectedToDelete = [];
                    selectAll = false;
                  })
                },
              ),
            if (!selectMultiple &&
                model.currentUser != null &&
                (model.currentUser.profile.accessControlList.canEditUsers ||
                    model.currentUser.profile.accessControlList
                        .canEditDepartmentUsers))
              ActionSpecification(
                tooltip: 'Bentuzer erstellen',
                icon: const Icon(Icons.post_add),
                onPressed: () => model.editUser(
                  asDialog: getValueForScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                ),
              ),
          ],
          actionsAppBar: [
            if (selectMultiple &&
                model.currentUser != null &&
                (model.currentUser.profile.accessControlList.canEditUsers ||
                    model.currentUser.profile.accessControlList
                        .canEditDepartmentUsers))
              ActionSpecification(
                tooltip: 'Alle auswählen',
                icon: const Icon(Icons.crop_square),
                onPressed: () => {
                  setState(() {
                    selectedToDelete = [];
                    filtered
                        ? selectedToDelete.addAll(filteredUsers)
                        : selectedToDelete.addAll(model.data);
                    selectAll = true;
                  })
                },
              ),
            if (!selectMultiple &&
                model.currentUser != null &&
                (model.currentUser.profile.accessControlList.canEditUsers ||
                    model.currentUser.profile.accessControlList
                        .canEditDepartmentUsers))
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

  Widget _buildDataView(BuildContext context, UserOverviewViewModel model) =>
      DataViewLayout(
        isBusy: model.isBusy,
        errorMessage: model.errorMessage,
        noDataMessage: (model.data == null || model.data.isEmpty)
            ? 'Es sind keine Benutzer verfügbar.'
            : null,
        childBuilder: () => _buildFilter(context, model),
      );

  Widget _buildFilter(BuildContext context, UserOverviewViewModel model) {
    return Column(
      children: [
        TextField(
          controller: _searchController,
          onChanged: (filter) => _applyFilter(model, filter),
          decoration: InputDecoration(
            labelText: 'Benutzer suchen',
            prefixIcon: const Icon(Icons.search),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () => {
                _searchController.clear(),
                _applyFilter(model, ''),
                filtered = false,
              },
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            controller: _scrollController,
            child: filtered
                ? _buildList(context, model, filteredUsers)
                : _buildList(context, model, model.data),
          ),
        ),
        Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildDeleteFab(model),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildList(
    BuildContext context,
    UserOverviewViewModel model,
    List<User> users,
  ) =>
      RefreshIndicator(
        onRefresh: model.initialise,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: users.length,
          itemBuilder: (context, index) =>
              _buildListItem(context, model, users[index]),
        ),
      );

  Widget _buildListItem(
    BuildContext context,
    UserOverviewViewModel model,
    User user,
  ) =>
      Dismissible(
        key: Key(user.id.toString()),
        direction: DismissDirection.endToStart,
        onDismissed: (_) {
          setState(() {
            model.data.remove(user);
          });
          model.removeUser(user);
        },
        confirmDismiss: (DismissDirection direction) async {
          return showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Löschen bestätigen"),
                content: Text(
                  "Soll '${user.userName}' wirklich gelöscht werden?",
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
        child: _buildCardListItem(context, model, user),
      );

  Widget _buildCardListItem(
    BuildContext context,
    UserOverviewViewModel model,
    User user,
  ) =>
      Card(
        color: selectedToDelete.map((e) => e.id).contains(user.id)
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
                      value:
                          selectedToDelete.map((e) => e.id).contains(user.id),
                      onChanged: (value) {
                        _selectToDelete(user);
                        _buildDeleteFab(model);
                      },
                    ),
                  ),
                ],
              ),
            Expanded(
              child: ListTile(
                leading: SvgPicture.string(
                  Jdenticon.toSvg(user.userName),
                  height: 48,
                  width: 48,
                ),
                title: Text(user.userName),
                subtitle: Text(
                  user.departments.isNotEmpty
                      ? '${user.departments.map((d) => d.name)} - '
                          '${user.profile.description}'
                      : user.profile.description,
                ),
                onTap: () {
                  if (model.currentUser != null &&
                      (model.currentUser.profile.accessControlList
                              .canEditUsers ||
                          model.currentUser.profile.accessControlList
                              .canEditDepartmentUsers) &&
                      selectMultiple) {
                    _selectToDelete(user);
                  } else if (model.currentUser != null &&
                      (model.currentUser.profile.accessControlList
                              .canEditUsers ||
                          model.currentUser.profile.accessControlList
                              .canEditDepartmentUsers)) {
                    model.editUser(
                      user: user,
                      asDialog: getValueForScreenType<bool>(
                        context: context,
                        mobile: false,
                        desktop: true,
                      ),
                      selectedDepartments: user.departments,
                    );
                  }
                },
                onLongPress: () {
                  if (!selectMultiple) {
                    selectMultiple = true;
                  }
                  _selectToDelete(user);
                  _buildDeleteFab(model);
                },
              ),
            )
          ],
        ),
      );

  Widget _buildDeleteFab(UserOverviewViewModel model) {
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
                "Soll(en) ${selectedToDelete.length} " +
                    "User wirklich gelöscht werden?",
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
            ? Text('${selectedToDelete.length} User löschen')
            : const Text('Löschen'),
      ),
    );
  }

  void _selectToDelete(User user) {
    setState(() {
      if (!selectedToDelete.map((user) => user.id).contains(user.id)) {
        selectedToDelete.add(user);
      } else if (selectedToDelete.map((user) => user.id).contains(user.id)) {
        selectedToDelete.removeWhere(
          (usr) => usr.id == user.id,
        );
      }
    });
  }

  void _applyFilter(UserOverviewViewModel model, String filter) {
    filtered = true;
    model.filterUsers(filter).then((value) {
      setState(() {
        filteredUsers = [];
        filteredUsers.addAll(value);
      });
    });
  }
}
