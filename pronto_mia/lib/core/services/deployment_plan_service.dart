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

/// A service, responsible for accessing deployment plans.
///
/// Contains methods to modify and access deployment plan information.
class DeploymentPlanService with ChangeNotifier {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();
  PdfService get _pdfService => locator.get<PdfService>();
  NavigationService get _navigationService => locator.get<NavigationService>();

  /// Gets the list of all deployment plans.
  ///
  /// Returns a [List] list of deployment plans.
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

  /// Gets a single deployment plan, according to its id.
  ///
  /// Takes the deployment plans [int] id as an input.
  /// Returns the [DeploymentPlan], corresponding to the id.
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

  /// Gets the list of all currently available deployment plans.
  ///
  /// Returns a [List] list of departments.
  /// Currently available deployment plans include all deployment plans, which
  /// have an end date still in the future.
  Future<List<DeploymentPlan>> getAvailableDeploymentPlans() async {
    // TODO: Remove "toUtc()" when https://github.com/ChilliCream/hotchocolate/issues/3691 is fixed
    final queryVariables = {
      'availableUntil': DateTime.now().toUtc().toIso8601String(),
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

  /// Creates a new deployment plan.
  ///
  /// Takes different attributes of a deployment plan as an input.
  Future<void> createDeploymentPlan(
    String description,
    DateTime availableFrom,
    DateTime availableUntil,
    SimpleFile pdfFile,
    int departmentId,
  ) async {
    final Map<String, dynamic> queryVariables = {
      'description': description,
      'availableFrom': availableFrom.toIso8601String(),
      'availableUntil': availableUntil.toIso8601String(),
      'departmentId': departmentId,
    };

    queryVariables['file'] = MultipartFile.fromBytes(
      'file',
      pdfFile.bytes,
      filename: pdfFile.name,
      contentType: MediaType('application', 'pdf'),
    );

    await (await _graphQLService).mutate(
      DeploymentPlanQueries.createDeploymentPlan,
      variables: queryVariables,
    );
  }

  /// Updates an existing deployment plan.
  ///
  /// Takes the deployment plans [int] id, alongside different attributes of a
  /// deployment plan as an input.
  Future<void> updateDeploymentPlan(
    int id, {
    String description,
    DateTime availableFrom,
    DateTime availableUntil,
    SimpleFile pdfFile,
    int departmentId,
  }) async {
    final queryVariables = {
      'id': id,
      'description': description,
      'availableFrom': availableFrom?.toIso8601String(),
      'availableUntil': availableUntil?.toIso8601String(),
      'departmentId': departmentId,
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

  /// Removes an existing deployment plan.
  ///
  /// Takes the [int] id of the deployment plan to be removed as an input.
  Future<void> removeDeploymentPlan(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      DeploymentPlanQueries.removeDeploymentPlan,
      variables: queryVariables,
    );
  }

  /// Publishes an existing deployment plan.
  ///
  /// Takes the [int] id of the deployment plan to be published, alongside a
  /// publish message consisting of a [String] title and [String] body as an
  /// input.
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

  /// Unpublishes an existing deployment plan.
  ///
  /// Takes the [int] id of the deployment plan to not be published anymore as
  /// an input.
  Future<void> hideDeploymentPlan(int id) async {
    final queryVariables = {'id': id};
    await (await _graphQLService).mutate(
      DeploymentPlanQueries.hideDeploymentPlan,
      variables: queryVariables,
    );
  }

  /// Opens a view, containing a pdf file from a [SimpleFile].
  ///
  /// Takes a [SimpleFile] pdf file as an input.
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

  /// Opens a view, containing a pdf file from a [DeploymentPlan].
  ///
  /// Takes a [DeploymentPlan], containing a pdf file as an input.
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

  /// Replaces the current view with a pdf view, containing a pdf file from a
  /// [DeploymentPlan].
  ///
  /// Takes a [DeploymentPlan], containing a pdf file as an input.
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
      subTitle: getDeploymentPlanAvailability(deploymentPlan),
    );
  }

  /// Gets the deployment plan title from a deployment plan.
  ///
  /// Takes the [DeploymentPlan] to get the title from as an input.
  /// Returns a [String] representation of the title.
  /// The title will be the deployment plans description if its set. Otherwise
  /// it will be built as "Einsatzplan <start date>".
  String getDeploymentPlanTitle(DeploymentPlan deploymentPlan) {
    final dateFormat = DateFormat('dd.MM.yyyy');
    final availableFromDateFormatted =
        dateFormat.format(deploymentPlan.availableFrom);
    return deploymentPlan.description ??
        'Einsatzplan $availableFromDateFormatted';
  }

  /// Gets the deployment plan availability from a deployment plan.
  ///
  /// Takes the [DeploymentPlan] to get the availability from as an input.
  /// Returns a [String] representation of the availability.
  /// The availability will be as "<start date> - <end date>".
  String getDeploymentPlanAvailability(DeploymentPlan deploymentPlan) {
    final dateTimeFormat = DateFormat('dd.MM.yyyy HH:mm');
    final availableFromFormatted =
        dateTimeFormat.format(deploymentPlan.availableFrom);
    final availableUntilFormatted =
        dateTimeFormat.format(deploymentPlan.availableUntil);

    return '$availableFromFormatted - $availableUntilFormatted';
  }

  /// Notifies this objects listeners.
  void notifyDataChanged() {
    notifyListeners();
  }
}
