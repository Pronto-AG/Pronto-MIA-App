import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pronto_mia/ui/components/navigation_menu/navigation_menu.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// A widget, representing the main view layout with a navigation.
class NavigationLayout extends StatelessWidget {
  final String title;
  final Widget body;
  final List<ActionSpecification> actions;
  final List<ActionSpecification> actionsAppBar;

  /// Initializes a new instance of [NavigationLayout].
  ///
  /// Takes a [String] view title, a [Widget] view body and a [List] of actions
  /// to display on the app bar.
  const NavigationLayout({
    @required this.title,
    @required this.body,
    this.actions,
    this.actionsAppBar,
  });

  /// Builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  @override
  Widget build(BuildContext context) => ScreenTypeLayout(
        mobile: _buildMobileLayout(body: body),
        tablet: _buildTabletLayout(),
        desktop: _buildDesktopLayout(),
      );

  Widget _buildMobileLayout({@required Widget body}) => Scaffold(
        drawer: NavigationMenu(),
        appBar: _buildAppBar(actions: actionsAppBar),
        body: body,
        floatingActionButton: actions != null && actions.isNotEmpty
            ? FloatingActionButton(
                tooltip: actions[0].tooltip,
                backgroundColor: CustomColors.secondary,
                onPressed: actions[0].onPressed,
                child: actions[0].icon,
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
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
                      _buildAppBar(
                        actions: actions.isNotEmpty && actionsAppBar.isNotEmpty
                            ? actions + actionsAppBar
                            : actionsAppBar.isNotEmpty
                                ? actionsAppBar
                                : actions,
                      ),
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

  PreferredSizeWidget _buildAppBar({
    List<ActionSpecification> actions,
  }) =>
      AppBar(
        title: Text(
          title,
          style: const TextStyle(color: CustomColors.primary),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: CustomColors.text),
        actions: actions
            ?.map(
              (ActionSpecification action) => IconButton(
                tooltip: action.tooltip,
                icon: action.icon,
                onPressed: action.onPressed,
              ),
            )
            ?.toList(),
      );
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
