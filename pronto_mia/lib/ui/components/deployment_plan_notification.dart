import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class DeploymentPlanNotification extends StatelessWidget {
  final AsyncCallback navigationCallback;
  final String title;
  final String body;

  const DeploymentPlanNotification({
    @required this.navigationCallback,
    @required this.title,
    @required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500.0,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              title,
              style: const TextStyle(fontSize: 20.0),
            ),
          ),
          Text(body),
          ElevatedButton(
              onPressed: navigationCallback, child: const Text("Ansehen"))
        ],
      ),
    );
  }
}
