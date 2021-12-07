import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/queries/mail_queries.dart';
import 'package:pronto_mia/core/services/inquiry_service.dart';

import '../setup/test_helpers.dart';

void main() {
  group('InquiryService', () {
    InquiryService inquiryService;
    setUp(() {
      registerServices();
      inquiryService = InquiryService();
    });
    tearDown(() => unregisterServices());

    group('sendMail', () {
      test('sendMailInquiryService', () async {
        final graphQLService = getAndRegisterMockGraphQLService();

        await inquiryService.sendMail("subject", "content");
        verify(
          graphQLService.mutate(
            MailQueries.sendMail,
            variables: {
              'subject': 'subject',
              'content': 'content',
            },
          ),
        ).called(1);
      });
    });
  });
}
