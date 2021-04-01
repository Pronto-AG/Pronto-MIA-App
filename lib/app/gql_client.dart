import 'package:graphql/client.dart';
import 'package:informbob_app/app/app.locator.dart';
import 'package:informbob_app/core/services/token_service.dart';

// ignore: avoid_classes_with_only_static_members
class GqlConfig {
  static final TokenService _tokenService = locator<TokenService>();
  static final HttpLink _httpLink =
      HttpLink('https://localhost:5001/graphql/');

  static final AuthLink _authLink = AuthLink(
    getToken: () async {
      try {
        final token = await _tokenService.getToken();
        return 'bearer $token';
      } catch (_) {
        return '';
      }
    }
  );

  static final Link _link = _authLink.concat(_httpLink);

  static final GraphQLClient client =
      GraphQLClient(link: _link, cache: GraphQLCache());
}
