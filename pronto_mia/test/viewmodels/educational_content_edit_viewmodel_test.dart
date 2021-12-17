import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/educational_content.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/views/educational_content/edit/educational_content_edit_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('EducationalContentEditViewModel', () {
    EducationalContentEditViewModel educationalContentEditViewModel;
    setUp(() {
      registerServices();
      educationalContentEditViewModel = EducationalContentEditViewModel();
    });
    tearDown(() => unregisterServices());

    group('submitForm', () {
      test('sets message on empty title', () async {
        await educationalContentEditViewModel.submitForm();
        expect(
          educationalContentEditViewModel.validationMessage,
          equals('Bitte Titel eingeben.'),
        );
      });

      test('sets message on empty description', () async {
        educationalContentEditViewModel.formValueMap['title'] = 'test';
        await educationalContentEditViewModel.submitForm();
        expect(
          educationalContentEditViewModel.validationMessage,
          equals('Bitte Beschreibung eingeben.'),
        );
      });

      test('sets message on empty file upload', () async {
        educationalContentEditViewModel.formValueMap['title'] = 'foo';
        educationalContentEditViewModel.formValueMap['description'] = 'bar';

        await educationalContentEditViewModel.submitForm();
        expect(
          educationalContentEditViewModel.validationMessage,
          equals('Bitte Schulungsvideo als MP4-Datei hochladen.'),
        );
      });

      test('creates educational content successfully as standalone', () async {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
        final navigationService = getAndRegisterMockNavigationService();
        SimpleFile file = SimpleFile();

        educationalContentEditViewModel.formValueMap['title'] = 'title';
        educationalContentEditViewModel.formValueMap['description'] =
            'description';
        educationalContentEditViewModel.formValueMap['upload.mp4'] = 'test';
        educationalContentEditViewModel.setVideoUpload(file);

        await educationalContentEditViewModel.submitForm();
        expect(educationalContentEditViewModel.validationMessage, isNull);
        verify(educationalContentService.createEducationalContent(
          'title',
          'description',
          file,
        )).called(1);
        verify(navigationService.back(result: true));
      });

      test('edits educational content successfully as standalone', () async {
        educationalContentEditViewModel = EducationalContentEditViewModel(
          educationalContent: EducationalContent(
            id: 1,
            title: 'title',
            description: 'description',
            link: 'http://example.com/',
          ),
        );
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
        final navigationService = getAndRegisterMockNavigationService();
        educationalContentEditViewModel.formValueMap['title'] = 'title';
        educationalContentEditViewModel.formValueMap['description'] = 'bar';
        educationalContentEditViewModel.formValueMap['upload.mp4'] = 'test';

        await educationalContentEditViewModel.submitForm();
        expect(educationalContentEditViewModel.validationMessage, isNull);
        verify(educationalContentService.updateEducationalContent(
          1,
          description: 'bar',
        )).called(1);
        verify(navigationService.back(result: true));
      });
    });

    group('removeEducationalContent', () {
      test('removes educational content successfully as standalone', () async {
        educationalContentEditViewModel = EducationalContentEditViewModel(
          educationalContent: EducationalContent(id: 1),
        );
        final educationalContentService =
            getAndRegisterMockEducationalContentService();
        final navigationService = getAndRegisterMockNavigationService();

        await educationalContentEditViewModel.removeEducationalContent();
        expect(educationalContentEditViewModel.validationMessage, isNull);
        verify(educationalContentService.removeEducationalContent(1)).called(1);
        verify(navigationService.back(result: true));
      });
    });

    group('getEducationalContentTitle', () {
      test('returns title', () {
        final educationalContentService =
            getAndRegisterMockEducationalContentService();

        educationalContentEditViewModel.getEducationalContentTitle(
          EducationalContent(),
        );
        verify(
          educationalContentService.getEducationalContentTitle(
            argThat(anything),
          ),
        ).called(1);
      });
    });
  });
}
