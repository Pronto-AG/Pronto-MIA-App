import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/ui/views/home/home_viewmodel.dart';
import 'package:pronto_mia/app/app.router.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text(model.title),
          actions: const <Widget>[
            IconButton(
              icon: Icon(Icons.admin_panel_settings),
              tooltip: 'Administrator-Modus'
            ),
            IconButton(
              icon: Icon(Icons.account_circle),
              tooltip: 'Benutzerprofil',
            ),
          ],
        ),
        body: ExtendedNavigator(
          router: HomeViewRouter(),
          navigatorKey: StackedService.nestedNavigationKey(1),
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: model.currentIndex,
          onTap: model.navigateTo,
          items: const [
            BottomNavigationBarItem(
              label: 'Einsatzplan',
              icon: Icon(Icons.today),
            ),
            BottomNavigationBarItem(
              label: 'Ferien',
              icon: Icon(Icons.beach_access),
            ),
            BottomNavigationBarItem(
              label: 'Schulung',
              icon: Icon(Icons.school),
            ),
            BottomNavigationBarItem(
              label: 'News',
              icon: Icon(Icons.description),
            ),
          ],
        ),
      ),
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}
