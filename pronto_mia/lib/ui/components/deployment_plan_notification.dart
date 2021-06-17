import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A widget, representing a notification dialog for deployment plans
class DeploymentPlanNotification extends StatelessWidget {
  final AsyncCallback onViewPressed;
  final String title;
  final String body;

  /// Initializes a new instance of [DeploymentPlanNotification].
  ///
  /// Takes a [AsyncCallback] executed on button press, a [String] notification
  /// and a [String] notification body as an input.
  const DeploymentPlanNotification({
    @required this.onViewPressed,
    @required this.title,
    @required this.body,
  });

  /// Builds the widget.
  ///
  /// Takes the current [BuildContext] as an input.
  @override
  Widget build(BuildContext context) {
    // ignore: sized_box_for_whitespace
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 500.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20.0),
          ),
          const SizedBox(height: 24.0),
          Text(body),
          const SizedBox(height: 16.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                onPressed: onViewPressed,
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 16.0,
                  ),
                  child: Text("Ansehen"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
