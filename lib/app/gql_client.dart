import 'package:flutter/cupertino.dart';
import 'package:graphql/client.dart';

// ignore: avoid_classes_with_only_static_members
class GqlConfig {
  static final HttpLink _httpLink =
      HttpLink('https://localhost:5001');

  /*
  static final AuthLink _authLink = AuthLink(
    getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
  );
  */

  // static final Link _link = _authLink.concat(_httpLink);
  static final Link _link = _httpLink;

  static final GraphQLClient client =
      GraphQLClient(link: _link, cache: GraphQLCache());
}
