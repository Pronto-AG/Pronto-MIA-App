import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/internal_news.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/views/internal_news/edit/internal_news_edit_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('InternalNewsEditViewModel', () {
    InternalNewsEditViewModel internalNewsEditViewModel;
    setUp(() {
      registerServices();
      internalNewsEditViewModel = InternalNewsEditViewModel();
    });
    tearDown(() => unregisterServices());

    group('submitForm', () {
      test('sets message on empty title', () async {
        await internalNewsEditViewModel.submitForm();
        expect(
          internalNewsEditViewModel.validationMessage,
          equals('Bitte Titel eingeben.'),
        );
      });

      test('sets message on empty description', () async {
        internalNewsEditViewModel.formValueMap['title'] = 'test';
        await internalNewsEditViewModel.submitForm();
        expect(
          internalNewsEditViewModel.validationMessage,
          equals('Bitte Beschreibung eingeben.'),
        );
      });

      test('sets message on empty file upload', () async {
        internalNewsEditViewModel.formValueMap['title'] = 'foo';
        internalNewsEditViewModel.formValueMap['description'] = 'bar';
        internalNewsEditViewModel.formValueMap['availableFrom'] =
            '2012-10-05T14:48:00.000Z';

        await internalNewsEditViewModel.submitForm();
        expect(
          internalNewsEditViewModel.validationMessage,
          equals('Bitte Neuigkeiten Bild als PNG-Datei hochladen.'),
        );
      });

      test('creates internal news successfully as standalone', () async {
        final internalNewsService = getAndRegisterMockInternalNewsService();
        final navigationService = getAndRegisterMockNavigationService();
        SimpleFile file = SimpleFile();

        internalNewsEditViewModel.formValueMap['title'] = 'title';
        internalNewsEditViewModel.formValueMap['description'] = 'description';
        internalNewsEditViewModel.formValueMap['availableFrom'] =
            '2011-10-05T14:48:00.000Z';
        internalNewsEditViewModel.formValueMap['upload.png'] = 'test';
        internalNewsEditViewModel.setImageUpload(file);

        await internalNewsEditViewModel.submitForm();
        expect(internalNewsEditViewModel.validationMessage, isNull);
        verify(internalNewsService.createInternalNews(
          'title',
          'description',
          DateTime.parse('2011-10-05T14:48:00.000Z'),
          file,
        )).called(1);
        verify(navigationService.back(result: true));
      });

      // test('creates internal news successfully as dialog', () async {
      //   internalNewsEditViewModel = InternalNewsEditViewModel(
      //     isDialog: true,
      //   );
      //   final internalNewsService = getAndRegisterMockInternalNewsService();
      //   final dialogService = getAndRegisterMockDialogService();
      //   SimpleFile file = SimpleFile();

      //   internalNewsEditViewModel.formValueMap['title'] = 'title';
      //   internalNewsEditViewModel.formValueMap['description'] = 'description';
      //   internalNewsEditViewModel.formValueMap['availableFrom'] =
      //       '2011-10-05T14:48:00.000Z';
      //   internalNewsEditViewModel.formValueMap['upload.png'] = 'test';
      //   internalNewsEditViewModel.setImageUpload(file);

      //   await internalNewsEditViewModel.submitForm();
      //   expect(internalNewsEditViewModel.validationMessage, isNull);
      //   verify(internalNewsService.createInternalNews(
      //     'title',
      //     'description',
      //     DateTime.parse('2011-10-05T14:48:00.000Z'),
      //     file,
      //   )).called(1);
      //   verify(dialogService.completeDialog(argThat(anything)));
      // });

      test('edits internal news successfully as standalone', () async {
        internalNewsEditViewModel = InternalNewsEditViewModel(
          internalNews: InternalNews(
            id: 1,
            title: 'title',
            description: 'description',
            availableFrom: DateTime.parse('2011-10-05T14:48:00.000Z'),
            link: 'http://example.com/',
          ),
        );
        final internalNewsService = getAndRegisterMockInternalNewsService();
        final navigationService = getAndRegisterMockNavigationService();
        internalNewsEditViewModel.formValueMap['title'] = 'title';
        internalNewsEditViewModel.formValueMap['description'] = 'bar';
        internalNewsEditViewModel.formValueMap['availableFrom'] =
            '2011-10-05T14:48:00.000Z';
        internalNewsEditViewModel.formValueMap['upload.png'] = 'test';

        await internalNewsEditViewModel.submitForm();
        expect(internalNewsEditViewModel.validationMessage, isNull);
        verify(internalNewsService.updateInternalNews(
          1,
          description: 'bar',
        )).called(1);
        verify(navigationService.back(result: true));
      });

      // test('edits internal news successfully as dialog', () async {
      //   internalNewsEditViewModel = InternalNewsEditViewModel(
      //     isDialog: true,
      //     internalNews: InternalNews(
      //       id: 1,
      //       title: 'bar',
      //       description: 'foo',
      //       availableFrom: DateTime.parse('2011-10-05T14:48:00.000Z'),
      //       link: 'http://example.com/',
      //     ),
      //   );
      //   final internalNewsService = getAndRegisterMockInternalNewsService();
      //   final dialogService = getAndRegisterMockDialogService();
      //   internalNewsEditViewModel.formValueMap['title'] = 'bar';
      //   internalNewsEditViewModel.formValueMap['description'] = 'bar';
      //   internalNewsEditViewModel.formValueMap['availableFrom'] =
      //       '2011-10-05T14:48:00.000Z';
      //   internalNewsEditViewModel.formValueMap['upload.png'] = 'test';

      //   await internalNewsEditViewModel.submitForm();
      //   expect(internalNewsEditViewModel.validationMessage, isNull);
      //   verify(internalNewsService.updateInternalNews(
      //     1,
      //     description: 'bar',
      //   )).called(1);
      //   verify(dialogService.completeDialog(argThat(anything)));
      // });
    });

    group('removeInternalNews', () {
      test('removes internal news successfully as standalone', () async {
        internalNewsEditViewModel = InternalNewsEditViewModel(
          internalNews: InternalNews(id: 1),
        );
        final internalNewsService = getAndRegisterMockInternalNewsService();
        final navigationService = getAndRegisterMockNavigationService();

        await internalNewsEditViewModel.removeInternalNews();
        expect(internalNewsEditViewModel.validationMessage, isNull);
        verify(internalNewsService.removeInternalNews(1)).called(1);
        verify(navigationService.back(result: true));
      });

      // test('removes internal news successfully as dialog', () async {
      //   internalNewsEditViewModel = InternalNewsEditViewModel(
      //     isDialog: true,
      //     internalNews: InternalNews(id: 1),
      //   );
      //   final internalNewsService = getAndRegisterMockInternalNewsService();
      //   final dialogService = getAndRegisterMockDialogService();

      //   await internalNewsEditViewModel.removeInternalNews();
      //   expect(internalNewsEditViewModel.validationMessage, isNull);
      //   verify(internalNewsService.removeInternalNews(1)).called(1);
      //   verify(dialogService.completeDialog(argThat(anything)));
      // });
    });

    group('getInternalNewsTitle', () {
      test('returns title', () {
        final internalNewsService = getAndRegisterMockInternalNewsService();

        internalNewsEditViewModel.getInternalNewsTitle(
          InternalNews(),
        );
        verify(
          internalNewsService.getInternalNewsTitle(
            argThat(anything),
          ),
        ).called(1);
      });
    });

    group('cancelForm', () {
      test('replaces view', () async {
        final navigationService = getAndRegisterMockNavigationService();
        internalNewsEditViewModel.cancelForm();
        verify(
          navigationService.replaceWithTransition(
            argThat(anything),
          ),
        ).called(1);
      });
    });
  });
}
