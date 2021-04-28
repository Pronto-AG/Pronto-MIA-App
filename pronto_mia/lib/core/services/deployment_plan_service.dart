import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/file_upload.dart';
import 'package:pronto_mia/core/queries/deployment_plan_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

class DeploymentPlanService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  Future<List<DeploymentPlan>> getAvailableDeploymentPlans() async {
    final queryVariables = {
      'availableUntil': DateTime.now().toIso8601String(),
    };

    final data = await (await _graphQLService).query(
        DeploymentPlanQueries.deploymentPlansAvailableUntil, queryVariables);

    final dtoList = data['deploymentPlans'] as List<Object>;
    final deploymentPlanList = dtoList
        .map((dto) => DeploymentPlan.fromJson(dto as Map<String, dynamic>))
        .toList();

    return deploymentPlanList;
  }

  Future<void> createDeploymentPlan(
    String description,
    DateTime availableFrom,
    DateTime availableUntil,
    FileUpload pdfFile,
  ) async {
    final multiPartFile = MultipartFile.fromBytes(
      'file',
      pdfFile.bytes,
      filename: pdfFile.name,
      contentType: MediaType("application", "pdf"),
    );

    final queryVariables = {
      "description": description,
      "file": multiPartFile,
      "availableFrom": availableFrom.toIso8601String(),
      "availableUntil": availableUntil.toIso8601String(),
    };

    await (await _graphQLService)
        .mutate(DeploymentPlanQueries.createDeploymentPlan, queryVariables);
  }
}
