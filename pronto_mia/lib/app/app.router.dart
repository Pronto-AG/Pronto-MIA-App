// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/deployment_plan/deployment_plan_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/pdf/pdf_view.dart';
import '../ui/views/upload_file/upload_file_view.dart';

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
  static const String deploymentPlanView = '/';
  static const String uploadFileView = '/upload';
  static const String pdfView = '/download';
  static const all = <String>{
    deploymentPlanView,
    uploadFileView,
    pdfView,
  };
}

class HomeViewRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(HomeViewRoutes.deploymentPlanView, page: DeploymentPlanView),
    RouteDef(HomeViewRoutes.uploadFileView, page: UploadFileView),
    RouteDef(HomeViewRoutes.pdfView, page: PdfView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    DeploymentPlanView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const DeploymentPlanView(),
        settings: data,
      );
    },
    UploadFileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UploadFileView(),
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

/// PdfView arguments holder class
class PdfViewArguments {
  final Key key;
  final String title;
  final String subTitle;
  final String pdfPath;
  PdfViewArguments(
      {this.key,
      @required this.title,
      @required this.subTitle,
      @required this.pdfPath});
}
