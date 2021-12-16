import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/queries/mail_queries.dart';
import 'package:pronto_mia/core/services/inquiry_service.dart';
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

      test('submits form', () async {
        inquiryViewModel.formValueMap['firstname'] = 'Gieri';
        inquiryViewModel.formValueMap['lastname'] = 'Casutt';
        inquiryViewModel.formValueMap['street'] = 'Via Caglims';
        inquiryViewModel.formValueMap['plz'] = '8640';
        inquiryViewModel.formValueMap['location'] = 'Rapperswil';
        inquiryViewModel.formValueMap['phone'] = '079';
        inquiryViewModel.formValueMap['mail'] = 'test@pronto.ch';
        await inquiryViewModel.submitForm();
        expect(
          inquiryViewModel.validationMessage,
          isNull,
        );
      });
    });

    test('sendMail', () async {
      final inquiryService = getAndRegisterMockInquiryService();
      final navigationService = getAndRegisterMockNavigationService();

      when(inquiryService.sendMail("subject", "content")).thenAnswer(
        (realInvocation) => Future.value({
          'data': {
            'sendMail': true,
          }
        }),
      );

      await inquiryViewModel.sendMail();

      verify(
        navigationService.replaceWithTransition(
          argThat(isA<InquiryView>()),
          transition: NavigationTransition.UpToDown,
        ),
      ).called(1);
    });
  });
}
