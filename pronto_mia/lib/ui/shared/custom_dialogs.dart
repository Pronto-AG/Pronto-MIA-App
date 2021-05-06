import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/ui/shared/custom_colors.dart';
import 'package:pronto_mia/app/service_locator.dart';

enum DialogType { custom }

DialogService registerDialogs(DialogService dialogService) {
  final builders = {
    DialogType.custom: (
      BuildContext context, 
      DialogRequest sheetRequest, 
      Function(DialogResponse) completer,
    ) => _CustomDialog(request: sheetRequest),
  };
  
  dialogService.registerCustomDialogBuilders(builders);
  return dialogService;
}

class _CustomDialog extends StatelessWidget {
  NavigationService get _navigationService => locator.get<NavigationService>();

  final DialogRequest request;

  const _CustomDialog({Key key, this.request}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: () => _navigationService.back(),
    child: Container(
      decoration: const BoxDecoration(color: CustomColors.shade),
      child: Center(
        child: Container(
          width: 500.0,
          child: Card(
            child: request.customData as Widget,
          ),
        ),
      ),
    ),
  );
}