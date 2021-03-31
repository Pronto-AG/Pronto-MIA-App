import 'package:graphql/client.dart';
import 'package:http/http.dart';

import 'package:informbob_app/app/gql_client.dart';
import 'package:informbob_app/core/queries/upload_pdf.dart';

class FileService {
  final GraphQLClient _gqlClient = GqlConfig.client;

  Future<QueryResult> uploadFile(MultipartFile file) async {
    final options = MutationOptions(
      document: gql(UploadPdf.uploadPdf),
      variables: {
        "upload": file,
      },
    );

    var result = await _gqlClient.mutate(options);
    print(result);

    return result;
  }
}