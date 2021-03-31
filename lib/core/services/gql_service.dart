import 'package:graphql/client.dart';
import 'package:informbob_app/app/gql_client.dart';

class GqlService {
  GraphQLClient client = GqlConfig.client;

  Future<QueryResult> query(QueryOptions options) async {
    return client.query(options);
  }
}
