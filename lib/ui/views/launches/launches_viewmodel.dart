import 'package:graphql/client.dart';
import 'package:informbob_app/core/queries/launches_past.dart';
import 'package:stacked/stacked.dart';

import 'package:informbob_app/core/services/gql_service.dart';
import 'package:informbob_app/app/app.locator.dart';

class LaunchesViewModel extends BaseViewModel {
  final _gqlService = locator<GqlService>();

  final _title = 'Launches View';
  String get title => _title;

  String _errorMessage;
  String get errorMessage => _errorMessage;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  List _launches;
  List get launches => _launches;

  Future<void> loadLaunches() async {
    final QueryOptions options = QueryOptions(
      document: gql(LaunchesPast.readLaunchesPast),
      variables: <String, dynamic>{
        'limit': 10,
      },
    );
    final result = await _gqlService.query(options);
    _errorMessage = result.exception.toString();
    _isLoading = false;
    _launches = result.data['launchesPast'] as List;
    notifyListeners();
  }
}
