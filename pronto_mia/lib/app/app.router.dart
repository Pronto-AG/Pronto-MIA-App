// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../ui/views/download_file/download_file_view.dart';
import '../ui/views/home/home_view.dart';
import '../ui/views/login/login_view.dart';
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
  static const String uploadFileView = '/';
  static const String downloadFileView = '/download';
  static const all = <String>{
    uploadFileView,
    downloadFileView,
  };
}

class HomeViewRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(HomeViewRoutes.uploadFileView, page: UploadFileView),
    RouteDef(HomeViewRoutes.downloadFileView, page: DownloadFileView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    UploadFileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UploadFileView(),
        settings: data,
      );
    },
    DownloadFileView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const DownloadFileView(),
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
