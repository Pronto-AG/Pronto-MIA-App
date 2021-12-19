import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/external_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/views/external_news/edit/external_news_edit_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('ExternalNewsEditViewModel', () {
    ExternalNewsEditViewModel externalNewsEditViewModel;
    setUp(() {
      registerServices();
      externalNewsEditViewModel = ExternalNewsEditViewModel();
    });
    tearDown(() => unregisterServices());

    group('submitForm', () {
      test('sets message on empty title', () async {
        await externalNewsEditViewModel.submitForm();
        expect(
          externalNewsEditViewModel.validationMessage,
          equals('Bitte Titel eingeben.'),
        );
      });

      test('sets message on empty description', () async {
        externalNewsEditViewModel.formValueMap['title'] = 'test';
        await externalNewsEditViewModel.submitForm();
        expect(
          externalNewsEditViewModel.validationMessage,
          equals('Bitte Beschreibung eingeben.'),
        );
      });

      test('sets message on empty file upload', () async {
        externalNewsEditViewModel.formValueMap['title'] = 'foo';
        externalNewsEditViewModel.formValueMap['description'] = 'bar';
        externalNewsEditViewModel.formValueMap['availableFrom'] =
            '2012-10-05T14:48:00.000Z';

        await externalNewsEditViewModel.submitForm();
        expect(
          externalNewsEditViewModel.validationMessage,
          equals('Bitte Neuigkeiten Bild als PNG-Datei hochladen.'),
        );
      });

      test('creates external news successfully as standalone', () async {
        final externalNewsService = getAndRegisterMockExternalNewsService();
        final navigationService = getAndRegisterMockNavigationService();
        SimpleFile file = SimpleFile();

        externalNewsEditViewModel.formValueMap['title'] = 'title';
        externalNewsEditViewModel.formValueMap['description'] = 'description';
        externalNewsEditViewModel.formValueMap['availableFrom'] =
            '2011-10-05T14:48:00.000Z';
        externalNewsEditViewModel.formValueMap['upload.png'] = 'test';
        externalNewsEditViewModel.setImageUpload(file);

        await externalNewsEditViewModel.submitForm();
        expect(externalNewsEditViewModel.validationMessage, isNull);
        verify(externalNewsService.createExternalNews(
          'title',
          'description',
          DateTime.parse('2011-10-05T14:48:00.000Z'),
          file,
        )).called(1);
        verify(navigationService.back(result: true));
      });

      // test('creates external news successfully as dialog', () async {
      //   externalNewsEditViewModel = ExternalNewsEditViewModel(
      //     isDialog: true,
      //   );
      //   final externalNewsService = getAndRegisterMockExternalNewsService();
      //   final dialogService = getAndRegisterMockDialogService();
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
      //   verify(dialogService.completeDialog(argThat(anything)));
      // });

      test('edits external news successfully as standalone', () async {
        externalNewsEditViewModel = ExternalNewsEditViewModel(
          externalNews: ExternalNews(
            id: 1,
            title: 'title',
            description: 'description',
            availableFrom: DateTime.parse('2011-10-05T14:48:00.000Z'),
            link: 'http://example.com/',
          ),
        );
        final externalNewsService = getAndRegisterMockExternalNewsService();
        final navigationService = getAndRegisterMockNavigationService();
        externalNewsEditViewModel.formValueMap['title'] = 'title';
        externalNewsEditViewModel.formValueMap['description'] = 'bar';
        externalNewsEditViewModel.formValueMap['availableFrom'] =
            '2011-10-05T14:48:00.000Z';
        externalNewsEditViewModel.formValueMap['upload.png'] = 'test';

        await externalNewsEditViewModel.submitForm();
        expect(externalNewsEditViewModel.validationMessage, isNull);
        verify(externalNewsService.updateExternalNews(
          1,
          description: 'bar',
        )).called(1);
        verify(navigationService.back(result: true));
      });

      // test('edits external news successfully as dialog', () async {
      //   externalNewsEditViewModel = ExternalNewsEditViewModel(
      //     isDialog: true,
      //     externalNews: ExternalNews(
      //       id: 1,
      //       title: 'bar',
      //       description: 'foo',
      //       availableFrom: DateTime.parse('2011-10-05T14:48:00.000Z'),
      //       link: 'http://example.com/',
      //     ),
      //   );
      //   final externalNewsService = getAndRegisterMockExternalNewsService();
      //   final dialogService = getAndRegisterMockDialogService();
      //   externalNewsEditViewModel.formValueMap['title'] = 'bar';
      //   externalNewsEditViewModel.formValueMap['description'] = 'bar';
      //   externalNewsEditViewModel.formValueMap['availableFrom'] =
      //       '2011-10-05T14:48:00.000Z';
      //   externalNewsEditViewModel.formValueMap['upload.png'] = 'test';

      //   await externalNewsEditViewModel.submitForm();
      //   expect(externalNewsEditViewModel.validationMessage, isNull);
      //   verify(externalNewsService.updateExternalNews(
      //     1,
      //     description: 'bar',
      //   )).called(1);
      //   verify(dialogService.completeDialog(argThat(anything)));
      // });
    });

    group('removeExternalNews', () {
      test('removes external news successfully as standalone', () async {
        externalNewsEditViewModel = ExternalNewsEditViewModel(
          externalNews: ExternalNews(id: 1),
        );
        final externalNewsService = getAndRegisterMockExternalNewsService();
        final navigationService = getAndRegisterMockNavigationService();

        await externalNewsEditViewModel.removeExternalNews();
        expect(externalNewsEditViewModel.validationMessage, isNull);
        verify(externalNewsService.removeExternalNews(1)).called(1);
        verify(navigationService.back(result: true));
      });

      // test('removes external news successfully as dialog', () async {
      //   externalNewsEditViewModel = ExternalNewsEditViewModel(
      //     isDialog: true,
      //     externalNews: ExternalNews(id: 1),
      //   );
      //   final externalNewsService = getAndRegisterMockExternalNewsService();
      //   final dialogService = getAndRegisterMockDialogService();

      //   await externalNewsEditViewModel.removeExternalNews();
      //   expect(externalNewsEditViewModel.validationMessage, isNull);
      //   verify(externalNewsService.removeExternalNews(1)).called(1);
      //   verify(dialogService.completeDialog(argThat(anything)));
      // });
    });

    group('getExternalNewsTitle', () {
      test('returns title', () {
        final externalNewsService = getAndRegisterMockExternalNewsService();

        externalNewsEditViewModel.getExternalNewsTitle(
          ExternalNews(),
        );
        verify(
          externalNewsService.getExternalNewsTitle(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('cancelForm', () {
      test('replaces view', () async {
        final navigationService = getAndRegisterMockNavigationService();
        externalNewsEditViewModel.cancelForm();
        verify(
          navigationService.replaceWithTransition(
            argThat(anything),
          ),
        ).called(1);
      });
    });
  });
}
