import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pronto_mia/core/models/appointment.dart';
import 'package:pronto_mia/ui/shared/custom_dialogs.dart';

import 'package:pronto_mia/ui/views/appointment/view/appointment_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../setup/test_helpers.dart';

void main() {
  group('AppointmentViewViewModel', () {
    AppointmentViewModel appointmentViewModel;
    Appointment appointment = Appointment();
    List<Appointment> appointments = List<Appointment>();
    setUp(() {
      registerServices();
      appointmentViewModel = AppointmentViewModel(appointment: appointment);
    });
    tearDown(() => unregisterServices());

    group('futureToRun', () {
      test('returns available appointment on default mode', () async {
        final appointmentService = getAndRegisterMockAppointmentService();
        when(appointmentService.getAppointments()).thenAnswer(
          (realInvocation) => Future.value(appointments),
        );

        expect(
          await appointmentViewModel.futureToRun(),
          isInstanceOf<List<Appointment>>(),
        );
        verify(appointmentService.getAppointments()).called(1);
      });
    });

    group('onError', () {
      test('calls error handling on error', () async {
        final errorService = getAndRegisterMockErrorService();
        when(errorService.getErrorMessage(captureAny)).thenReturn('test');

        await appointmentViewModel.onError(Exception());
        expect(appointmentViewModel.errorMessage, equals('test'));
        verify(
          errorService.handleError(
            'AppointmentViewModel',
            argThat(isException),
          ),
        ).called(1);
        verify(errorService.getErrorMessage(argThat(isException))).called(1);
      });
    });

    group('editAppointment', () {
      test('opens edit page for appointment', () async {
        final navigationService = getAndRegisterMockNavigationService();

        await appointmentViewModel.editAppointment(
            appointment: Appointment(
          id: 1,
          title: 'test',
          location: 'test',
          from: DateTime.now(),
          to: DateTime.now(),
          isAllDay: false,
          isYearly: false,
        ));
        verify(
          navigationService.navigateWithTransition(
            argThat(anything),
            transition: NavigationTransition.LeftToRight,
          ),
        ).called(1);
      });
    });

    group('dispose', () {
      test('removes listener from service', () {
        final appointmentService = getAndRegisterMockAppointmentService();

        appointmentViewModel.dispose();
        verify(
          appointmentService.removeListener(argThat(anything)),
        ).called(1);
      });
    });
  });
}
