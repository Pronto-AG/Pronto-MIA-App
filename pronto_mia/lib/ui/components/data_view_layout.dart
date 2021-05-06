import 'package:flutter/material.dart';

class DataViewLayout extends StatelessWidget {
  final bool isBusy;
  final String emptyMessage;
  final String errorMessage;
  final Widget Function() childBuilder;

  const DataViewLayout({
    @required this.childBuilder,
    this.isBusy,
    this.emptyMessage,
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

    if (emptyMessage != null && emptyMessage.isNotEmpty) {
      return Center(
        child: Text(emptyMessage),
      );
    }

    return childBuilder();
  }
}