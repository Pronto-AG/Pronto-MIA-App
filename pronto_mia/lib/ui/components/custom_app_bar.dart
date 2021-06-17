import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/components/navigation_menu/navigation_menu.dart';

/// A widget, representing a bottom app bar with actions
class CustomAppBar extends StatelessWidget {
  final List<Widget> actions;

  /// Initializes a new instance of [CustomAppBar].
  ///
  /// Takes a [List] of actions to display on the bar as input.
  const CustomAppBar({
    this.actions,
  });

  /// Builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  @override
  Widget build(BuildContext context) => BottomAppBar(
        shape: (() {
          if (!kIsWeb) {
            return const CircularNotchedRectangle();
          }
        })(),
        child: IconTheme(
          data: const IconThemeData(color: CustomColors.negativeText),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Navigation öffnen',
                icon: const Icon(Icons.menu),
                onPressed: () async => _showMenu(context),
              ),
              const Spacer(),
              if (actions != null && actions.isNotEmpty) ...actions,
            ],
          ),
        ),
      );

  Future<void> _showMenu(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => NavigationMenu(),
    );
  }
}
