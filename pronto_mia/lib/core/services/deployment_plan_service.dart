import 'package:graphql/client.dart';

import 'package:pronto_mia/app/app.locator.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/queries/deployment_plans.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

class DeploymentPlanService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  Future<List<DeploymentPlan>> getAvailableDeploymentPlans() async {
    // final availableUntil = DateTime.now().toIso8601String();
    const availableUntil = '2021-04-06T18:00:00.000+02:00';
    final queryVariables = {
      'availableUntil': availableUntil,
    };

    final data = await (await _graphQLService).query(
        DeploymentPlans.deploymentPlansAvailableUntil, queryVariables);

    final dtoList = data['deploymentPlans'] as List<Object>;
    final deploymentPlanList = dtoList
        .map((dto) => DeploymentPlan.fromJson(dto as Map<String, dynamic>))
        .toList();

    return deploymentPlanList;
  }
}
