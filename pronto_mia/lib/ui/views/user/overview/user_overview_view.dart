class UserOverviewView extends StatelessWidget {
  const UserOverviewView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<UserOverviewViewModel>.reactive(
        viewModelBuilder: () => UserOverviewViewModel(),
        builder: (context, model, child) => NavigationLayout(
          title: 'Benutzerverwaltung',
          body: _buildDataView(context, model),
          actions: [
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
            ActionSpecification(
              tooltip: 'Suche öffnen',
              icon: const Icon(Icons.search),
              onPressed: () {},
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
  ) => Card(
      child: Row(
        children: [
          Expanded(
            child: ListTile(
              title: Text(user.username),
              subtitle: Text('Administrator'),
              onTap: () {
                model.editUser(
                  user: user,
                  asDialog: getValueforScreenType<bool>(
                    context: context,
                    mobile: false,
                    desktop: true,
                  ),
                ),
              },
            ),
          ),
        ],
      ),
    );
}