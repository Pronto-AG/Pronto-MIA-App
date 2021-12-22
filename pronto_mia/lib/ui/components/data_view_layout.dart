import 'package:flutter/material.dart';

/// A widget, representing a layout for a data view.
class DataViewLayout extends StatelessWidget {
  final bool isBusy;
  final String noDataMessage;
  final String errorMessage;
  final Widget Function() childBuilder;

  /// Initializes a new instance of [DataViewLayout].
  ///
  /// Takes a [Function] to build its child, a [bool] to determine if the
  /// data is busy, and [String] messages for either no data or error.
  const DataViewLayout({
    @required this.childBuilder,
    this.isBusy,
    this.noDataMessage,
    this.errorMessage,
  });

  /// Builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  /// Returns the built [Widget].
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

    return childBuilder();
  }
}
