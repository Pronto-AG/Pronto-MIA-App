import 'package:flutter/material.dart';
import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:stacked_services/stacked_services.dart';

/// The representation of possible custom dialog types.
enum DialogType { custom }

final _dialogService = locator.get<DialogService>();

/// Registers all custom dialogs.
void setupDialogs() {
  final builders = {
    DialogType.custom: (
      BuildContext context,
      DialogRequest sheetRequest,
      Function(DialogResponse) completer,
    ) =>
        _CustomDialog(request: sheetRequest),
  };

  _dialogService.registerCustomDialogBuilders(builders);
}

class _CustomDialog extends StatelessWidget {
  final DialogRequest request;

  const _CustomDialog({Key key, this.request}) : super(key: key);

  /// Builds the custom dialog widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
  /// The dialog is wrapped by a [GestureDetector], which allows closing
  /// the dialog from tapping outside of it.
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _dialogService.completeDialog(DialogResponse()),
        child: Scaffold(
          backgroundColor: CustomColors.shade,
          body: Center(
            // ignore: sized_box_for_whitespace
            child: Container(
              width: 500.0,
              child: Stack(
                children: [
                  Card(
                    child: SingleChildScrollView(
                      child: request.customData as Widget,
                    ),
                  ),
                  Positioned(
                    top: 12.0,
                    right: 16.0,
                    child: IconButton(
                      tooltip: 'Schliessen',
                      icon: const Icon(Icons.close),
                      onPressed: () =>
                          _dialogService.completeDialog(DialogResponse()),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}
