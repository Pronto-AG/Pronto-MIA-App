import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/app/service_locator.dart';

enum DialogType { custom }

final _dialogService = locator.get<DialogService>();

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
              Card(child: request.customData as Widget),
              Positioned(
                top: 16.0,
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
