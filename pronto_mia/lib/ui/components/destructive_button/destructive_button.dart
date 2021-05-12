import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/components/destructive_button/destructive_button_viewmodel.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';

class DestructiveButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  const DestructiveButton({
    @required this.onPressed,
    @required this.child,
  });

  @override
  Widget build(BuildContext context) =>
      ViewModelBuilder<DestructiveButtonViewModel>.reactive(
        viewModelBuilder: () => DestructiveButtonViewModel(),
        builder: (context, model, builderChild) {
          if (!model.hasClickedOnce) {
            return ElevatedButton(
              onPressed: model.clickOnce,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(CustomColors.danger),
              ),
              child: child,
            );
          }

          return ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(CustomColors.warning),
            ),
            child: const Text('Wirklich löschen?'),
          );
        },
      );
}
