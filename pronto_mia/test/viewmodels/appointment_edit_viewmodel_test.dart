import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import 'package:pronto_mia/core/models/appointment.dart';
import 'package:pronto_mia/core/models/simple_file.dart';
import 'package:pronto_mia/core/models/department.dart';
import 'package:pronto_mia/ui/views/appointment/edit/appointment_edit_viewmodel.dart';

import '../setup/test_helpers.dart';

void main() {
  group('AppointmentEditViewModel', () {
    AppointmentEditViewModel appointmentEditViewModel;
    setUp(() {
      registerServices();
      appointmentEditViewModel = AppointmentEditViewModel();
    });
    tearDown(() => unregisterServices());

    group('submitForm', () {
      test('sets message on empty title', () async {
        await appointmentEditViewModel.submitForm();
        expect(
          appointmentEditViewModel.validationMessage,
          equals('Bitte Titel eingeben.'),
        );
      });

      test('sets message on wrong start- and endtime', () async {
        appointmentEditViewModel.formValueMap['title'] = 'foo';
        appointmentEditViewModel.formValueMap['location'] = 'bar';
        appointmentEditViewModel.formValueMap['from'] =
            DateTime.now().add(const Duration(hours: 2)).toIso8601String();
        appointmentEditViewModel.formValueMap['to'] =
            DateTime.now().toIso8601String();

        await appointmentEditViewModel.submitForm();
        expect(
          appointmentEditViewModel.validationMessage,
          equals('Die Startzeit muss vor der Endzeit liegen.'),
        );
      });

      test('creates appointment successfully as standalone', () async {
        final appointmentService = getAndRegisterMockAppointmentService();
        final navigationService = getAndRegisterMockNavigationService();

        appointmentEditViewModel.formValueMap['title'] = 'title';
        appointmentEditViewModel.formValueMap['location'] = 'location';
        appointmentEditViewModel.formValueMap['from'] =
            '2012-10-05T14:48:00.000Z';
        appointmentEditViewModel.formValueMap['to'] =
            '2012-10-05T14:58:00.000Z';
        appointmentEditViewModel.formValueMap['isAllDay'] = 'false';
        appointmentEditViewModel.formValueMap['isYearly'] = 'false';

        await appointmentEditViewModel.submitForm();
        expect(appointmentEditViewModel.validationMessage, isNull);
        verify(appointmentService.createAppointment(
          title: 'title',
          location: 'location',
          from: DateTime.parse('2012-10-05T14:48:00.000Z'),
          to: DateTime.parse('2012-10-05T14:58:00.000Z'),
          isAllDay: false,
          isYearly: false,
        )).called(1);
        verify(navigationService.back(result: true));
      });

      test('edits appointment successfully as standalone', () async {
        appointmentEditViewModel = AppointmentEditViewModel(
          appointment: Appointment(
            id: 1,
            title: 'title',
            location: 'location',
            from: DateTime.parse('2012-10-05T14:48:00.000Z'),
            to: DateTime.parse('2012-10-05T14:58:00.000Z'),
            isAllDay: false,
            isYearly: false,
          ),
        );
        final appointmentService = getAndRegisterMockAppointmentService();
        final navigationService = getAndRegisterMockNavigationService();
        appointmentEditViewModel.formValueMap['title'] = 'title';
        appointmentEditViewModel.formValueMap['location'] = 'bar';
        appointmentEditViewModel.formValueMap['from'] =
            '2012-10-05T14:48:00.000Z';
        appointmentEditViewModel.formValueMap['to'] =
            '2012-10-05T14:58:00.000Z';
        appointmentEditViewModel.formValueMap['isAllDay'] = 'false';
        appointmentEditViewModel.formValueMap['isYearly'] = 'false';

        await appointmentEditViewModel.submitForm();
        expect(appointmentEditViewModel.validationMessage, isNull);
        verify(appointmentService.updateAppointment(
          1,
          title: null,
          location: 'bar',
          from: null,
          to: null,
          isAllDay: false,
          isYearly: false,
        )).called(1);
        verify(navigationService.back(result: true));
      });
    });

    group('removeAppointment', () {
      test('removes appointment successfully as standalone', () async {
        appointmentEditViewModel = AppointmentEditViewModel(
          appointment: Appointment(id: 1),
        );
        final appointmentService = getAndRegisterMockAppointmentService();
        final navigationService = getAndRegisterMockNavigationService();

        await appointmentEditViewModel.removeAppointment();
        expect(appointmentEditViewModel.validationMessage, isNull);
        verify(appointmentService.removeAppointment(1)).called(1);
        verify(navigationService.back(result: true));
      });
    });
  });
}
