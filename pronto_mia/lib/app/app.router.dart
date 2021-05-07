// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../core/models/deployment_plan.dart';
import '../core/models/simple_file.dart';
import '../ui/views/deployment_plan/edit/deployment_plan_edit_view.dart';
import '../ui/views/deployment_plan/overview/deployment_plan_overview_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/pdf/pdf_view.dart';

class Routes {
  static const String loginView = '/login';
  static const String deploymentPlanOverviewView = '/einsatzplaene';
  static const String deploymentPlanEditView = '/einsatzplan-bearbeiten';
  static const String pdfView = '/pdf';
  static const all = <String>{
    loginView,
    deploymentPlanOverviewView,
    deploymentPlanEditView,
    pdfView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.deploymentPlanOverviewView,
        page: DeploymentPlanOverviewView),
    RouteDef(Routes.deploymentPlanEditView, page: DeploymentPlanEditView),
    RouteDef(Routes.pdfView, page: PdfView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    LoginView: (data) {
      var args = data.getArgs<LoginViewArguments>(
        orElse: () => LoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(key: args.key),
        settings: data,
      );
    },
    DeploymentPlanOverviewView: (data) {
      var args = data.getArgs<DeploymentPlanOverviewViewArguments>(
        orElse: () => DeploymentPlanOverviewViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => DeploymentPlanOverviewView(
          key: args.key,
          adminModeEnabled: args.adminModeEnabled,
        ),
        settings: data,
      );
    },
    DeploymentPlanEditView: (data) {
      var args = data.getArgs<DeploymentPlanEditViewArguments>(
        orElse: () => DeploymentPlanEditViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => DeploymentPlanEditView(
          key: args.key,
          deploymentPlan: args.deploymentPlan,
        ),
        settings: data,
      );
    },
    PdfView: (data) {
      var args = data.getArgs<PdfViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => PdfView(
          key: args.key,
          title: args.title,
          subTitle: args.subTitle,
          pdfUpload: args.pdfUpload,
          pdfPath: args.pdfPath,
        ),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// LoginView arguments holder class
class LoginViewArguments {
  final Key key;
  LoginViewArguments({this.key});
}

/// DeploymentPlanOverviewView arguments holder class
class DeploymentPlanOverviewViewArguments {
  final Key key;
  final bool adminModeEnabled;
  DeploymentPlanOverviewViewArguments(
      {this.key, this.adminModeEnabled = false});
}

/// DeploymentPlanEditView arguments holder class
class DeploymentPlanEditViewArguments {
  final Key key;
  final DeploymentPlan deploymentPlan;
  DeploymentPlanEditViewArguments({this.key, this.deploymentPlan});
}

/// PdfView arguments holder class
class PdfViewArguments {
  final Key key;
  final String title;
  final String subTitle;
  final SimpleFile pdfUpload;
  final String pdfPath;
  PdfViewArguments(
      {this.key,
      @required this.title,
      this.subTitle,
      this.pdfUpload,
      this.pdfPath});
}
