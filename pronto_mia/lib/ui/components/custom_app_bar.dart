import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/ui/components/navigation_menu/navigation_menu.dart';

class CustomAppBar extends StatelessWidget {
  final List<Widget> actions;

  const CustomAppBar({
    this.actions,
  });

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
              ...actions,
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
