import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DataViewLayout extends StatelessWidget {
  final bool isBusy;
  final String noDataMessage;
  final String errorMessage;
  final Widget Function() childBuilder;

  const DataViewLayout({
    @required this.childBuilder,
    this.isBusy,
    this.noDataMessage,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (isBusy) {
      return const Center(child: CircularProgressIndicator());
    }

    if (errorMessage != null && errorMessage.isNotEmpty) {
      return Center(
        child: Text(errorMessage),
      );
    }

    if (noDataMessage != null && noDataMessage.isNotEmpty) {
      return Center(
        child: Text(noDataMessage),
      );
    }

    if (kIsWeb) {
      return Expanded(
        child: childBuilder(),
      );
    }

    return childBuilder();
  }
}
