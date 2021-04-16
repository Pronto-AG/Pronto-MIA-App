// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/deployment_plan/edit/deployment_plan_edit_view.dart';
import '../ui/views/deployment_plan/overview/deployment_plan_overview_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/pdf/pdf_view.dart';

class Routes {
  static const String loginView = '/login';
  static const String homeView = '/home';
  static const all = <String>{
    loginView,
    homeView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(
      Routes.homeView,
      page: HomeView,
      generator: HomeViewRouter(),
    ),
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
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
  };
}

class HomeViewRoutes {
  static const String deploymentPlanOverviewView = '/';
  static const String deploymentPlanEditView = '/deployment-plan-edit';
  static const String pdfView = '/pdf';
  static const all = <String>{
    deploymentPlanOverviewView,
    deploymentPlanEditView,
    pdfView,
  };
}

class HomeViewRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(HomeViewRoutes.deploymentPlanOverviewView,
        page: DeploymentPlanOverviewView),
    RouteDef(HomeViewRoutes.deploymentPlanEditView,
        page: DeploymentPlanEditView),
    RouteDef(HomeViewRoutes.pdfView, page: PdfView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    DeploymentPlanOverviewView: (data) {
      var args =
          data.getArgs<DeploymentPlanOverviewViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => DeploymentPlanOverviewView(
          key: args.key,
          adminModeEnabled: args.adminModeEnabled,
          toggleAdminModeCallback: args.toggleAdminModeCallback,
        ),
        settings: data,
      );
    },
    DeploymentPlanEditView: (data) {
      var args = data.getArgs<DeploymentPlanEditViewArguments>(
        orElse: () => DeploymentPlanEditViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => DeploymentPlanEditView(key: args.key),
        settings: data,
      );
    },
    PdfView: (data) {
      var args = data.getArgs<PdfViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => PdfView(
          key: args.key,
          pdfPath: args.pdfPath,
          title: args.title,
          subTitle: args.subTitle,
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
  final void Function() toggleAdminModeCallback;
  DeploymentPlanOverviewViewArguments(
      {this.key,
      @required this.adminModeEnabled,
      @required this.toggleAdminModeCallback});
}

/// DeploymentPlanEditView arguments holder class
class DeploymentPlanEditViewArguments {
  final Key key;
  DeploymentPlanEditViewArguments({this.key});
}

/// PdfView arguments holder class
class PdfViewArguments {
  final Key key;
  final String pdfPath;
  final String title;
  final String subTitle;
  PdfViewArguments(
      {this.key, @required this.pdfPath, @required this.title, this.subTitle});
}
