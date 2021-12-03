import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/ui/views/inquiry/inquiry_viewmodel.dart';
import 'package:pronto_mia/ui/views/inquiry/inquiry_view.dart';

import '../setup/test_helpers.dart';

void main() {
  group('InquiryViewModel', () {
    InquiryViewModel inquiryViewModel;
    setUp(() {
      registerServices();
      inquiryViewModel = InquiryViewModel();
    });
    tearDown(() => unregisterServices());

    group('submitForm', () {
      test('sets message on empty firstname', () async {
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Bitte Vornamen angeben'),
        );
      });

      test('sets message on empty lastname', () async {
        inquiryViewModel.formValueMap['firstname'] = 'gieri';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Bitte Nachnamen angeben'),
        );
      });

      test('sets message on empty street', () async {
        inquiryViewModel.formValueMap['firstname'] = 'gieri';
        inquiryViewModel.formValueMap['lastname'] = 'casutt';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Bitte Strasse angeben'),
        );
      });

      test('sets message on empty plz', () async {
        inquiryViewModel.formValueMap['firstname'] = 'gieri';
        inquiryViewModel.formValueMap['lastname'] = 'casutt';
        inquiryViewModel.formValueMap['street'] = 'via caglims';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Bitte Postleitzahl angeben'),
        );
      });

      test('sets message on wrong plz', () async {
        inquiryViewModel.formValueMap['firstname'] = 'gieri';
        inquiryViewModel.formValueMap['lastname'] = 'casutt';
        inquiryViewModel.formValueMap['street'] = 'via caglims';
        inquiryViewModel.formValueMap['plz'] = 'test';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Postleitzahl nicht korrekt'),
        );
      });

      test('sets message on empty location', () async {
        inquiryViewModel.formValueMap['firstname'] = 'gieri';
        inquiryViewModel.formValueMap['lastname'] = 'casutt';
        inquiryViewModel.formValueMap['street'] = 'via caglims';
        inquiryViewModel.formValueMap['plz'] = '8640';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Bitte Ort angeben'),
        );
      });

      test('sets message on empty phone', () async {
        inquiryViewModel.formValueMap['firstname'] = 'Gieri';
        inquiryViewModel.formValueMap['lastname'] = 'Casutt';
        inquiryViewModel.formValueMap['street'] = 'Via Caglims';
        inquiryViewModel.formValueMap['plz'] = '8640';
        inquiryViewModel.formValueMap['location'] = 'Rapperswil';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Bitte Telefonnummer angeben'),
        );
      });

      test('sets message on wrong phone', () async {
        inquiryViewModel.formValueMap['firstname'] = 'Gieri';
        inquiryViewModel.formValueMap['lastname'] = 'Casutt';
        inquiryViewModel.formValueMap['street'] = 'Via Caglims';
        inquiryViewModel.formValueMap['plz'] = '8640';
        inquiryViewModel.formValueMap['location'] = 'Rapperswil';
        inquiryViewModel.formValueMap['phone'] = 'test';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Telefonnummer nicht korrekt'),
        );
      });

      test('sets message on empty email', () async {
        inquiryViewModel.formValueMap['firstname'] = 'Gieri';
        inquiryViewModel.formValueMap['lastname'] = 'Casutt';
        inquiryViewModel.formValueMap['street'] = 'Via Caglims';
        inquiryViewModel.formValueMap['plz'] = '8640';
        inquiryViewModel.formValueMap['location'] = 'Rapperswil';
        inquiryViewModel.formValueMap['phone'] = '079';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('Bitte E-Mail angeben'),
        );
      });

      test('sets message on wrong email', () async {
        inquiryViewModel.formValueMap['firstname'] = 'Gieri';
        inquiryViewModel.formValueMap['lastname'] = 'Casutt';
        inquiryViewModel.formValueMap['street'] = 'Via Caglims';
        inquiryViewModel.formValueMap['plz'] = '8640';
        inquiryViewModel.formValueMap['location'] = 'Rapperswil';
        inquiryViewModel.formValueMap['phone'] = '079';
        inquiryViewModel.formValueMap['mail'] = 'test';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          equals('E-Mail Adresse nicht korrekt'),
        );
      });

      group('sendMail', () {
        test('generateMessage', () {
          final recipient = 'app@pronto-ag.ch';
          expect(inquiryViewModel.generateMessage(recipient),
              isInstanceOf<Message>());
        });

        test('getSmtpRecipient', () async {
          final inquiryService = getAndRegisterMockInquiryService();
          await inquiryViewModel.getRecipient();
          verify(inquiryService.getRecipient()).called(1);
        });

        test('createSmtpServer', () async {
          final inquiryService = getAndRegisterMockInquiryService();
          await inquiryViewModel.createSmtpServer();
          verify(inquiryService.createSmtpServer()).called(1);
        });

        test('sendMailToSmtpServer', () {
          final inquiryService = getAndRegisterMockInquiryService();
          final recipient = 'app@pronto-ag.ch';
          final dateTime = DateTime.parse('2011-10-05T14:48:00.000Z');
          final message = inquiryViewModel.generateMessage(recipient);
          final smtpServer = SmtpServer('smtp.pronto-ag.ch');
          when(inquiryService.sendMailToSmtpServer(message, smtpServer))
              .thenAnswer((realInvocation) => Future.value(
                  SendReport(message, dateTime, dateTime, dateTime)));
          expect(inquiryViewModel.sendMailToSmtpServer(message, smtpServer),
              isInstanceOf<Future<SendReport>>());
        });

        test('sendMail', () async {
          final inquiryService = getAndRegisterMockInquiryService();
          final navigationService = getAndRegisterMockNavigationService();
          final smtpServer = await inquiryViewModel.createSmtpServer();
          final recipient = 'app@pronto-ag.ch';
          final message = await inquiryViewModel.generateMessage(recipient);
          final dateTime = DateTime.parse('2011-10-05T14:48:00.000Z');
          when(inquiryService.sendMailToSmtpServer(message, smtpServer))
              .thenAnswer((realInvocation) => Future.value(
                  SendReport(message, dateTime, dateTime, dateTime)));
          await inquiryViewModel.sendEmail();
          expect(inquiryService.sendMailToSmtpServer(message, smtpServer),
              isInstanceOf<Future<SendReport>>());
          verify(
            navigationService.replaceWithTransition(
              argThat(isA<InquiryView>()),
              transition: NavigationTransition.UpToDown,
            ),
          );
        });
      });
    });
  });
}
