import 'package:flutter/foundation.dart';
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/models/deployment_plan.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/deployment_plan_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';
import 'package:pronto_mia/core/services/pdf_service.dart';
import 'package:pronto_mia/ui/views/pdf/pdf_view.dart';
import 'package:stacked_services/stacked_services.dart';

class DeploymentPlanService with ChangeNotifier {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  PdfService get _pdfService => locator.get<PdfService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

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

  Future<DeploymentPlan> getDeploymentPlan(int id) async {
    final queryVariables = {
      'id': id,
    };
    final data = await (await _graphQLService).query(
      DeploymentPlanQueries.deploymentPlanById,
      variables: queryVariables,
    );

    final dtoList = data['deploymentPlans'] as List<Object>;
    final deploymentPlan =
        DeploymentPlan.fromJson(dtoList.first as Map<String, dynamic>);

    return deploymentPlan;
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
    SimpleFile pdfFile,
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
    int id, {
    String description,
    DateTime availableFrom,
    DateTime availableUntil,
    SimpleFile pdfFile,
  }) async {
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

  Future<void> publishDeploymentPlan(int id, String title, String body) async {
    final queryVariables = {
      'id': id,
      'title': title,
      'body': body,
    };
    await (await _graphQLService).mutate(
      DeploymentPlanQueries.publishDeploymentPlan,
      variables: queryVariables,
    );
  }

  Future<void> hideDeploymentPlan(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      DeploymentPlanQueries.hideDeploymentPlan,
      variables: queryVariables,
    );
  }

  Future<void> openPdfSimpleFile(SimpleFile pdfFile) async {
    if (kIsWeb) {
      _pdfService.openPdfWeb(pdfFile);
    } else {
      _navigationService.navigateWithTransition(
        PdfView(
          pdfFile: pdfFile,
          title: 'Upload.pdf',
        ),
        transition: NavigationTransition.LeftToRight,
      );
    }
  }

  Future<void> openPdf(DeploymentPlan deploymentPlan) async {
    if (kIsWeb) {
      final _pdfFile = await _pdfService.downloadPdf(deploymentPlan.link);
      _pdfService.openPdfWeb(_pdfFile);
    } else {
      _navigationService.navigateWithTransition(
        _getPdfView(deploymentPlan),
        transition: NavigationTransition.LeftToRight,
      );
    }
  }

  Future<void> openPdfWithReplace(DeploymentPlan deploymentPlan) async {
    if (kIsWeb) {
      final _pdfFile = await _pdfService.downloadPdf(deploymentPlan.link);
      _pdfService.openPdfWeb(_pdfFile);
    } else {
      _navigationService.replaceWithTransition(
        _getPdfView(deploymentPlan),
        transition: NavigationTransition.LeftToRight,
      );
    }
  }

  PdfView _getPdfView(DeploymentPlan deploymentPlan) {
    return PdfView(
      pdfFile: deploymentPlan.link,
      title: getDeploymentPlanTitle(deploymentPlan),
      subTitle: getDeploymentPlanSubtitle(deploymentPlan),
    );
  }

  String getDeploymentPlanTitle(DeploymentPlan deploymentPlan) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final availableFromDateFormatted =
        dateFormat.format(deploymentPlan.availableFrom);
    return deploymentPlan.description ??
        'Einsatzplan $availableFromDateFormatted';
  }

  String getDeploymentPlanSubtitle(DeploymentPlan deploymentPlan) {
    final dateTimeFormat = DateFormat('dd.MM.yyyy hh:mm');
    final availableFromFormatted =
        dateTimeFormat.format(deploymentPlan.availableFrom);
    final availableUntilFormatted =
        dateTimeFormat.format(deploymentPlan.availableUntil);

    return '$availableFromFormatted - $availableUntilFormatted';
  }

  void notifyDataChanged() {
    notifyListeners();
  }
}
