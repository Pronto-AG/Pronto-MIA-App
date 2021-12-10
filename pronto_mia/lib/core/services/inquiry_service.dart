import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/queries/mail_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

class InquiryService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  Future<void> sendMail(String subject, String content) async {
    final queryVariables = {
      'subject': subject,
      'content': content,
    };
    await (await _graphQLService).mutate(
      MailQueries.sendMail,
      variables: queryVariables,
    );
  }
}
