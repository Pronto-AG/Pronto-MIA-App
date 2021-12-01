import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/ui/views/inquiry/inquiry_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('InquiryViewModel', () {
    InquiryViewModel inquiryViewModel;
    setUp(() {
      // registerServices();
      inquiryViewModel = InquiryViewModel();
    });
    // tearDown(() => unregisterServices());

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
        test('sends mail', () async {
          // final departmentService = getAndRegisterMockDepartmentService();
          // when(inquiryViewModel.sendEmail()).thenAnswer(
          //   (realInvocation) => Future.value(),
          // );
          // inquiryViewModel = InquiryViewModel();
          inquiryViewModel.formValueMap['firstname'] = 'Gieri';
          inquiryViewModel.formValueMap['lastname'] = 'Casutt';
          inquiryViewModel.formValueMap['street'] = 'Via Caglims';
          inquiryViewModel.formValueMap['plz'] = '8640';
          inquiryViewModel.formValueMap['location'] = 'Rapperswil';
          inquiryViewModel.formValueMap['phone'] = '079';
          inquiryViewModel.formValueMap['mail'] = 'test@bar.ch';

          await inquiryViewModel.sendEmail();
          expect(inquiryViewModel.hasError, false);
          verify(inquiryViewModel.sendEmail()).called(1);
        });
      });

      // test('creates inquiry successfully as standalone', () async {
      //   final externalNewsService = getAndRegisterMockExternalNewsService();
      //   final navigationService = getAndRegisterMockNavigationService();
      //   SimpleFile file = SimpleFile();

      //   externalNewsEditViewModel.formValueMap['title'] = 'title';
      //   externalNewsEditViewModel.formValueMap['description'] = 'description';
      //   externalNewsEditViewModel.formValueMap['availableFrom'] =
      //       '2011-10-05T14:48:00.000Z';
      //   externalNewsEditViewModel.formValueMap['upload.png'] = 'test';
      //   externalNewsEditViewModel.setImageUpload(file);

      //   await externalNewsEditViewModel.submitForm();
      //   expect(externalNewsEditViewModel.validationMessage, isNull);
      //   verify(externalNewsService.createExternalNews(
      //     'title',
      //     'description',
      //     DateTime.parse('2011-10-05T14:48:00.000Z'),
      //     file,
      //   )).called(1);
      //   verify(navigationService.back(result: true));
      // });
    });
  });
}
