import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/components/navigation_menu/navigation_menu.dart';
import 'package:pronto_mia/ui/components/custom_app_bar.dart';

/// A widget, representing a main view layout with a navigation.
class NavigationLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<ActionSpecification> actions;

  /// Initializes a new instance of [NavigationLayout].
  ///
  /// Takes a [String] view title, a [Widget] view body and a [List] of actions
  /// to display on the app bar.
  const NavigationLayout({
    @required this.title,
    @required this.body,
    this.actions,
  });

  /// Builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  @override
  Widget build(BuildContext context) => ScreenTypeLayout(
        mobile: _buildMobileLayout(body: body),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      );

  Widget _buildMobileLayout({@required Widget body}) => Scaffold(
        appBar: _buildAppBar(),
        body: body,
        floatingActionButton: actions != null && actions.isNotEmpty
            ? FloatingActionButton(
                tooltip: actions[0].tooltip,
                backgroundColor: CustomColors.secondary,
                onPressed: actions[0].onPressed,
                child: actions[0].icon,
              )
            : null,
        floatingActionButtonLocation: kIsWeb
            ? FloatingActionButtonLocation.endFloat
            : FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: _buildBottomAppBar(),
      );

  Widget _buildTabletLayout() => _buildMobileLayout(
        body: Align(
          alignment: Alignment.topCenter,
          // ignore: sized_box_for_whitespace
          child: Container(width: 584.0, child: body),
        ),
      );

  Widget _buildDesktopLayout() => Scaffold(
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
                  Expanded(
                    child: NavigationMenu(),
                  ),
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
                      _buildAppBar(actions: actions),
                      Expanded(
                        child: body,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );

  PreferredSizeWidget _buildAppBar({List<ActionSpecification> actions}) =>
      AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          title,
          style: const TextStyle(color: CustomColors.primary),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        actions: actions
            ?.map((ActionSpecification action) => IconButton(
                  tooltip: action.tooltip,
                  icon: action.icon,
                  onPressed: action.onPressed,
                ))
            ?.toList(),
        actionsIconTheme: const IconThemeData(color: CustomColors.text),
      );

  Widget _buildBottomAppBar() => CustomAppBar(
      actions: actions.length > 1
          ? actions
              .sublist(1)
              .map((ActionSpecification action) => IconButton(
                    tooltip: action.tooltip,
                    icon: action.icon,
                    onPressed: action.onPressed,
                  ))
              .toList()
          : null);
}

class ActionSpecification {
  final String tooltip;
  final Icon icon;
  final void Function() onPressed;

  ActionSpecification({
    @required this.tooltip,
    @required this.icon,
    @required this.onPressed,
  });
}
