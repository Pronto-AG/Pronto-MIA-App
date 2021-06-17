import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'package:pronto_mia/ui/components/destructive_button/destructive_button_viewmodel.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';

/// a widget, representing a button that deletes something.
///
/// A destructive button needs to be confirmed with another click to execute its
/// action after the first click.
class DestructiveButton extends StatelessWidget {
  final void Function() onPressed;
  final Widget child;

  /// Initializes a new instance of [DestructiveButton].
  ///
  /// Takes a [Function] that executes on button press, and a [Widget] to wrap
  /// the button around as an input.
  const DestructiveButton({
    @required this.onPressed,
    @required this.child,
  });

  /// Binds [DestructiveButtonViewModel] and builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
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
