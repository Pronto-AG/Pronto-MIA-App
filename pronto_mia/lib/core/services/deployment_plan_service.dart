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

  Future<List<DeploymentPlan>> getDeploymentPlans() async {
    final data = await (await _graphQLService).query(
      DeploymentPlanQueries.deploymentPlans,
    );

    final dtoList = data['deploymentPlans'] as List<Object>;
    final deploymentPlanList = dtoList
      .map((dto) => DeploymentPlan.fromJson(dto as Map<String, dynamic>))
      .toList();

    return deploymentPlanList;
  }

  Future<List<DeploymentPlan>> getAvailableDeploymentPlans() async {
    final queryVariables = {
      'availableUntil': DateTime.now().toIso8601String(),
    };

    final data = await (await _graphQLService).query(
      DeploymentPlanQueries.deploymentPlansAvailableUntil,
      variables: queryVariables,
    );

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
    final Map<String, dynamic> queryVariables = {
      'description': description,
      'availableFrom': availableFrom.toIso8601String(),
      'availableUntil': availableUntil.toIso8601String(),
    };

    queryVariables['file'] = MultipartFile.fromBytes(
      'file',
      pdfFile.bytes,
      filename: pdfFile.name,
      contentType: MediaType('application', 'pdf'),
    );

    await (await _graphQLService).mutate(
      DeploymentPlanQueries.addDeploymentPlan,
      variables: queryVariables,
    );
  }

  Future<void> updateDeploymentPlan(
    int id,
    {
      String description,
      DateTime availableFrom,
      DateTime availableUntil,
      FileUpload pdfFile,
    }
  ) async {
    final queryVariables = {
      'id': id,
      'description': description,
      'availableFrom': availableFrom,
      'availableUntil': availableUntil,
    };

    if (pdfFile != null) {
      queryVariables['file'] = MultipartFile.fromBytes(
        'file',
        pdfFile.bytes,
        filename: pdfFile.name,
        contentType: MediaType('application', 'pdf'),
      );
    }

    await (await _graphQLService).mutate(
      DeploymentPlanQueries.updateDeploymentPlan,
      variables: queryVariables,
    );
  }

  Future<void> removeDeploymentPlan(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      DeploymentPlanQueries.removeDeploymentPlan,
      variables: queryVariables,
    );
  }
}
