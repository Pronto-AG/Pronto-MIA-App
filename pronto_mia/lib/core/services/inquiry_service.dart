import 'package:pronto_mia/app/service_locator.dart';
import 'package:pronto_mia/core/queries/mail_queries.dart';
import 'package:pronto_mia/core/services/graphql_service.dart';

/// A service, responsible for accessing inquiry informations.
///
/// Contains methods to send inquiry information.
class InquiryService {
  Future<GraphQLService> get _graphQLService =>
      locator.getAsync<GraphQLService>();

  /// Sends the content & subject of the inquiry as a mail via the backend.
  ///
  /// Takes [String] subject and [String] content of the inquiry as an input.
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
