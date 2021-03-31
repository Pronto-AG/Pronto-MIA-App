import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'launches_viewmodel.dart';

class LaunchesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<LaunchesViewModel>.reactive(
        viewModelBuilder: () => LaunchesViewModel(),
        onModelReady: (model) => model.loadLaunches(),
        builder: (context, model, child) => Scaffold(
            appBar: AppBar(
              title: Text(model.title),
            ),
            body: (() {
              if (model.isLoading) {
                return const Text('Loading');
              }

              return ListView.builder(
                  itemCount: model.launches.length,
                  itemBuilder: (context, index) {
                    final launch = model.launches[index];
                    return Text(launch['mission_name'] as String);
                  });

              /*
          if (model.launchesResult.hasException) {
            return Text(model.launchesResult.exception.toString());
          }

          if (model.launchesResult.isLoading) {
            return const Text('Loading');
          }

          final List launches =
            model.launchesResult.data['launchesPast'] as List;

          return ListView.builder(
            itemCount: launches.length,
            itemBuilder: (context, index) {
              final launch = launches[index];
              return Text(launch['mission_name'] as String);
            }
          );
          */

              return Text('test');
            })()));
  }
}
