import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import 'package:pronto_mia/app/service_locator.dart';
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

  Future<void> createDeploymentPlan(
    DateTime availableFrom,
    DateTime availableUntil,
    PlatformFile pdfFile) async {
    final multiPartFile = MultipartFile.fromBytes(
      'upload',
      pdfFile.bytes,
      filename: pdfFile.name,
      contentType: MediaType("application", "pdf"),
    );

    final queryVariables = {
      "file": multiPartFile,
      "availableFrom": availableFrom.toIso8601String(),
      "availableUntil": availableUntil.toIso8601String(),
    };

    final result = await (await _graphQLService).mutate(
        DeploymentPlans.createDeploymentPlan, queryVariables);
    print(result);
  }
}
